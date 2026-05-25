#!/usr/bin/env python3
"""
V-Model XT — Artifact Renderer
Recursively walks project/ and converts each .md file to .html for the dashboard.
Gracefully handles projects with zero artifacts.
"""
import argparse, json, os, sys, re, html
from datetime import datetime, timezone
from pathlib import Path

def md_to_html(text: str) -> str:
    """Minimal markdown-to-HTML converter (no external deps)."""
    out = []
    in_code_block = False
    code_lang = ""
    code_buf = []

    def flush_code():
        nonlocal code_buf, code_lang
        if not code_buf:
            return ""
        lang_attr = f' class="language-{code_lang}"' if code_lang else ""
        return f"<pre><code{lang_attr}>{''.join(code_buf)}</code></pre>\n"

    def flush_para(buf):
        if not buf:
            return ""
        t = "".join(buf).strip()
        if t.startswith("<h") or t.startswith("<table") or t.startswith("<ul") or t.startswith("<ol") or t.startswith("<pre"):
            return t + "\n"
        return f"<p>{t}</p>\n"

    para = []
    for line in text.split("\n"):
        if line.startswith("```"):
            if in_code_block:
                out.append(flush_code())
                code_buf = []
                code_lang = ""
                in_code_block = False
            else:
                out.append(flush_para(para))
                para = []
                code_lang = line[3:].strip()
                in_code_block = True
            continue
        if in_code_block:
            code_buf.append(html.escape(line) + "\n")
            continue

        stripped = line.strip()
        if not stripped:
            out.append(flush_para(para))
            para = []
            continue

        # Headings
        m = re.match(r"^(#{1,6})\s+(.*)", line)
        if m:
            out.append(flush_para(para))
            para = []
            level = len(m.group(1))
            out.append(f"<h{level}>{m.group(2)}</h{level}>\n")
            continue

        # Horizontal rule
        if re.match(r"^[-*_]{3,}$", stripped):
            out.append(flush_para(para))
            para = []
            out.append("<hr>\n")
            continue

        # Tables
        if stripped.startswith("|"):
            if "---" in stripped:
                out.append(flush_para(para))
                para = []
                # Emit table header as separate row
                if para_table_rows:
                    headers = para_table_rows[0]
                    out.append("<table>\n<thead><tr>")
                    for h in headers:
                        out.append(f"<th>{h.strip()}</th>")
                    out.append("</tr></thead>\n<tbody>\n")
                    for row in para_table_rows[1:]:
                        out.append("<tr>")
                        for c in row:
                            out.append(f"<td>{c.strip()}</td>")
                        out.append("</tr>\n")
                    out.append("</tbody></table>\n")
                para_table_rows = []
                continue
            if not para:
                para_table_rows = []
            cells = [c.strip() for c in stripped.strip("|").split("|")]
            para_table_rows.append(cells)
            continue

        # Inline formatting
        line = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", line)
        line = re.sub(r"\*(.+?)\*", r"<em>\1</em>", line)
        line = re.sub(r"`(.+?)`", r"<code>\1</code>", line)
        # Links
        line = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', line)

        para.append(line + "\n")

    out.append(flush_para(para))
    if in_code_block:
        out.append(flush_code())

    return "".join(out)


def extract_metadata(md_path: Path) -> dict:
    """Extract YAML-like frontmatter as a dict."""
    meta = {}
    try:
        with open(md_path, "r", encoding="utf-8") as f:
            in_frontmatter = False
            for line in f:
                line = line.rstrip("\n")
                if line == "---":
                    if not in_frontmatter:
                        in_frontmatter = True
                        continue
                    else:
                        break
                if in_frontmatter:
                    m = re.match(r"^([a-zA-Z_][a-zA-Z0-9_]*)\s*:\s*(.*)", line)
                    if m:
                        meta[m.group(1)] = m.group(2).strip()
    except Exception:
        pass
    return meta


def render_artifact(md_path: Path, output_path: Path, title: str):
    """Convert one .md file to a self-contained .html file."""
    try:
        text = md_path.read_text(encoding="utf-8")
    except Exception:
        return False

    meta = extract_metadata(md_path)
    body = md_to_html(text)
    artifact_id = meta.get("id", md_path.stem)

    html_doc = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{html.escape(title)} — {artifact_id}</title>
<style>
body {{ font-family: 'Segoe UI', system-ui, sans-serif; margin: 0; padding: 40px; max-width: 900px; margin: 0 auto; color: #222; line-height: 1.7; }}
h1 {{ border-bottom: 2px solid #3498db; padding-bottom: 6px; }}
h2 {{ border-bottom: 1px solid #ddd; padding-bottom: 4px; }}
table {{ border-collapse: collapse; width: 100%; margin: 12px 0; }}
th, td {{ border: 1px solid #ccc; padding: 6px 10px; text-align: left; }}
th {{ background: #f0f4f8; }}
pre {{ background: #f5f5f5; padding: 12px; border-radius: 4px; overflow-x: auto; }}
code {{ background: #f0f0f0; padding: 1px 4px; border-radius: 3px; font-size: 0.92em; }}
pre code {{ background: none; padding: 0; }}
hr {{ border: none; border-top: 1px solid #ddd; }}
</style>
</head>
<body>
<h1>{html.escape(title)}</h1>
{body}
</body>
</html>"""

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(html_doc, encoding="utf-8")
    return True


def main():
    parser = argparse.ArgumentParser(description="Render project artifacts to HTML")
    parser.add_argument("--project-root", required=True, help="Project root directory")
    parser.add_argument("--output-dir", required=True, help="Output directory for HTML")
    args = parser.parse_args()

    project_root = Path(args.project_root)
    output_dir = Path(args.output_dir)
    artifacts_dir = output_dir / "artifacts"
    artifacts_dir.mkdir(parents=True, exist_ok=True)

    project_dir = project_root / "project"
    artifacts = []

    if not project_dir.is_dir():
        print(f"  (project/ directory not found — nothing to render)")
        artifacts_dir.mkdir(parents=True, exist_ok=True)
        _write_index(artifacts_dir, output_dir, [])
        return

    # Walk project/ and render every .md file
    md_files = sorted(project_dir.rglob("*.md"))
    if not md_files:
        print(f"  (no .md artifacts found in project/ — nothing to render)")
        _write_index(artifacts_dir, output_dir, [])
        return

    rendered, skipped = 0, 0
    for md_path in md_files:
        try:
            rel = md_path.relative_to(project_dir)
        except ValueError:
            rel = md_path

        # Build a flat filename: 01_Requirements_02_SystemReqs_REQ-SYS-001.html
        parts = list(rel.parts[:-1]) + [rel.stem]
        html_name = "_".join(parts) + ".html"
        html_path = artifacts_dir / html_name

        category = rel.parts[0] if rel.parts else ""
        title = str(rel.with_suffix(""))

        if render_artifact(md_path, html_path, title):
            rendered += 1
            artifacts.append({
                "path": str(rel),
                "html": html_name,
                "category": category,
                "title": title,
            })
        else:
            skipped += 1

    print(f"  Rendered {rendered} artifact(s) to HTML" + (f", {skipped} skipped" if skipped else ""))

    _write_index(artifacts_dir, output_dir, artifacts)


def _write_index(artifacts_dir: Path, output_dir: Path, artifacts: list):
    """Write index.json so the dashboard can discover rendered artifacts."""
    idx = {
        "generated": datetime.now(timezone.utc).isoformat(),
        "artifact_count": len(artifacts),
        "artifacts": artifacts,
    }
    (artifacts_dir / "index.json").write_text(json.dumps(idx, indent=2), encoding="utf-8")

    # Also write reports/index.json for the reports panel
    reports_idx = {
        "generated": datetime.now(timezone.utc).isoformat(),
        "pages": ["document-index.html", "traceability-matrix.html"],
        "artifact_count": len(artifacts),
    }
    if len(artifacts) == 0:
        reports_idx["pages"] = [p for p in reports_idx["pages"] if (output_dir / p).exists()]
    (output_dir / "index.json").write_text(json.dumps(reports_idx, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
