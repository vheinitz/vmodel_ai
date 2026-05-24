#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Report Generator
# Renders project artifacts (MD → HTML) for dashboard display.
# Places output in dashboard/data/reports/
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPORTS_DIR="${PROJECT_ROOT}/dashboard/data/reports"
TIMESTAMP=$(date -Iseconds)

mkdir -p "${REPORTS_DIR}"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            V-Model XT — Report Generator                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Helper: Convert markdown to HTML with basic styling ---
md_to_html() {
    local input="$1"
    local output="$2"
    local title="$3"

    if [[ ! -f "${input}" ]]; then
        echo "  ⚠ Skipping (not found): ${input}"
        return
    fi

    python3 -c "
import sys, re

with open('${input}') as f:
    md = f.read()

# Basic markdown → HTML conversion
html = '<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\">'
html += '<title>${title}</title>'
html += '<style>'
html += 'body{font-family:system-ui,sans-serif;max-width:900px;margin:40px auto;padding:0 20px;'
html += 'color:#c8d6e5;background:#0a0e14;line-height:1.6}'
html += 'h1{color:#fff;border-bottom:1px solid #2a3545;padding-bottom:8px}'
html += 'h2{color:#39a0ff;margin-top:28px}h3{color:#c8d6e5}'
html += 'table{border-collapse:collapse;width:100%;margin:12px 0}'
html += 'th,td{border:1px solid #2a3545;padding:8px 12px;text-align:left}'
html += 'th{background:#141b22;color:#fff}'
html += 'code{background:#1c2530;padding:1px 5px;border-radius:3px;color:#e74c3c}'
html += 'pre{background:#1c2530;padding:12px;border-radius:6px;overflow-x:auto}'
html += 'a{color:#39a0ff}blockquote{border-left:3px solid #39a0ff;margin:12px 0;padding:4px 16px;color:#6b7d95}'
html += 'hr{border:0;border-top:1px solid #2a3545;margin:24px 0}'
html += 'ul,ol{padding-left:24px}li{margin:4px 0}'
html += 'input[type=checkbox]{margin-right:6px}'
html += '.timestamp{color:#6b7d95;font-size:0.85em;margin-bottom:20px}'
html += '</style></head><body>'
html += '<div class=\"timestamp\">Generated: ${TIMESTAMP}</div>'

# Convert markdown to HTML (simple approach)
lines = md.split('\n')
in_code_block = False
in_table = False
code_lang = ''
table_rows = []
list_buf = []

def flush_list():
    global list_buf
    if list_buf:
        result = '<' + list_buf[0] + '>\n'
        for item in list_buf[1:]:
            result += '<li>' + item + '</li>\n'
        result += '</' + list_buf[0] + '>\n'
        list_buf = []
        return result
    return ''

result = []
i = 0
while i < len(lines):
    line = lines[i]

    # Code blocks
    if line.startswith('\`\`\`'):
        if in_code_block:
            result.append('</code></pre>')
            in_code_block = False
        else:
            code_lang = line[3:].strip()
            result.append('<pre><code>')
            in_code_block = True
        i += 1
        continue

    if in_code_block:
        result.append(line.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;'))
        i += 1
        continue

    # Tables
    if '|' in line and line.strip().startswith('|'):
        cells = [c.strip() for c in line.split('|')[1:-1]]
        if i + 1 < len(lines) and '---' in lines[i+1]:
            # Header row
            headers = cells
            i += 2
            body_rows = []
            while i < len(lines) and '|' in lines[i] and lines[i].strip().startswith('|'):
                body_cells = [c.strip() for c in lines[i].split('|')[1:-1]]
                body_rows.append(body_cells)
                i += 1
            result.append('<table><thead><tr>')
            for h in headers:
                result.append('<th>' + h + '</th>')
            result.append('</tr></thead><tbody>')
            for row in body_rows:
                result.append('<tr>')
                for cell in row:
                    result.append('<td>' + cell + '</td>')
                result.append('</tr>')
            result.append('</tbody></table>')
            continue
        i += 1
        continue

    # Headers
    if line.startswith('### '):
        result.append(flush_list())
        result.append('<h3>' + line[4:] + '</h3>')
    elif line.startswith('## '):
        result.append(flush_list())
        result.append('<h2>' + line[3:] + '</h2>')
    elif line.startswith('# '):
        result.append(flush_list())
        result.append('<h1>' + line[2:] + '</h1>')
    elif line.startswith('> '):
        result.append(flush_list())
        result.append('<blockquote>' + line[2:] + '</blockquote>')
    elif line.startswith('---'):
        result.append(flush_list())
        result.append('<hr>')
    elif line.startswith('- [ ]') or line.startswith('- [x]') or line.startswith('- [X]'):
        checked = 'checked' if line[3:6].strip().lower() == '[x]' else ''
        result.append(flush_list())
        result.append('<div><input type=\"checkbox\" ' + checked + ' disabled> ' + line[6:] + '</div>')
    elif line.startswith('- ') or line.startswith('* '):
        if not list_buf:
            list_buf.append('ul')
        list_buf.append(line[2:])
    elif re.match(r'^\d+\.\s', line):
        if not list_buf:
            list_buf.append('ol')
        list_buf.append(re.sub(r'^\d+\.\s', '', line))
    elif line.strip() == '':
        result.append(flush_list())
        result.append('')
    else:
        result.append(flush_list())
        # Inline formatting
        line = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', line)
        line = re.sub(r'\*(.+?)\*', r'<em>\1</em>', line)
        line = re.sub(r'\`(.+?)\`', r'<code>\1</code>', line)
        line = re.sub(r'\[(.+?)\]\((.+?)\)', r'<a href=\"\2\">\1</a>', line)
        result.append(line + '<br>' if line.strip() else '')

    i += 1

result.append(flush_list())
html += '\n'.join(result)
html += '</body></html>'

with open('${output}', 'w') as f:
    f.write(html)
"
    echo "  ✓ ${output}"
}

# --- Generate reports for key artifacts ---
echo "Rendering project artifacts to HTML..."

# Requirements
md_to_html "${PROJECT_ROOT}/project/01_Requirements/README.md" \
           "${REPORTS_DIR}/requirements-flow.html" \
           "Requirements Flow"

[[ -f "${PROJECT_ROOT}/project/01_Requirements/02_SystemReqs/SystemRequirements_SyRS.md" ]] && \
    md_to_html "${PROJECT_ROOT}/project/01_Requirements/02_SystemReqs/SystemRequirements_SyRS.md" \
               "${REPORTS_DIR}/system-requirements.html" \
               "System Requirements (SyRS)"

[[ -f "${PROJECT_ROOT}/project/01_Requirements/03_SoftwareReqs/SoftwareRequirements_SRS.md" ]] && \
    md_to_html "${PROJECT_ROOT}/project/01_Requirements/03_SoftwareReqs/SoftwareRequirements_SRS.md" \
               "${REPORTS_DIR}/software-requirements.html" \
               "Software Requirements (SRS)"

# Architecture
[[ -f "${PROJECT_ROOT}/project/02_Architecture/01_SystemArchitecture/SystemArchitecture_SyAD.md" ]] && \
    md_to_html "${PROJECT_ROOT}/project/02_Architecture/01_SystemArchitecture/SystemArchitecture_SyAD.md" \
               "${REPORTS_DIR}/system-architecture.html" \
               "System Architecture (SyAD)"

# Risk Management
md_to_html "${PROJECT_ROOT}/project/08_RiskManagement/README.md" \
           "${REPORTS_DIR}/risk-management-flow.html" \
           "Risk Management Flow"

[[ -f "${PROJECT_ROOT}/project/08_RiskManagement/02_FMEA/SystemFMEA.md" ]] && \
    md_to_html "${PROJECT_ROOT}/project/08_RiskManagement/02_FMEA/SystemFMEA.md" \
               "${REPORTS_DIR}/fmea.html" \
               "System FMEA"

[[ -f "${PROJECT_ROOT}/project/08_RiskManagement/02_FMEA/SoftwareFMEA.md" ]] && \
    md_to_html "${PROJECT_ROOT}/project/08_RiskManagement/02_FMEA/SoftwareFMEA.md" \
               "${REPORTS_DIR}/software-fmea.html" \
               "Software FMEA"

# Traceability
[[ -f "${PROJECT_ROOT}/project/10_Documentation/TraceabilityMatrix.md" ]] && \
    md_to_html "${PROJECT_ROOT}/project/10_Documentation/TraceabilityMatrix.md" \
               "${REPORTS_DIR}/traceability-matrix.html" \
               "Traceability Matrix"

# Document Index
md_to_html "${PROJECT_ROOT}/project/10_Documentation/DocumentIndex.md" \
           "${REPORTS_DIR}/document-index.html" \
           "Document Index"

# IEC 62304 Compliance
[[ -f "${PROJECT_ROOT}/project/09_Regulatory/01_IEC62304/IEC62304_ComplianceMatrix.md" ]] && \
    md_to_html "${PROJECT_ROOT}/project/09_Regulatory/01_IEC62304/IEC62304_ComplianceMatrix.md" \
               "${REPORTS_DIR}/iec62304-compliance.html" \
               "IEC 62304 Compliance"

# Generate report index
python3 -c "
import json, os, glob
reports_dir = '${REPORTS_DIR}'
reports = sorted(glob.glob(reports_dir + '/*.html'))
index = {
    'generated': '${TIMESTAMP}',
    'reports': []
}
for r in reports:
    name = os.path.basename(r)
    title = name.replace('.html', '').replace('-', ' ').title()
    index['reports'].append({
        'file': name,
        'title': title,
        'size': os.path.getsize(r)
    })
with open(reports_dir + '/index.json', 'w') as f:
    json.dump(index, f, indent=2)
print(f'  Report index: {len(index[\"reports\"])} reports')
"

echo ""
echo "✅ Reports generated in dashboard/data/reports/"
bash "${SCRIPT_DIR}/log-activity.sh" "report-generator" "generated-reports" "$(ls ${REPORTS_DIR}/*.html 2>/dev/null | wc -l) HTML reports"
