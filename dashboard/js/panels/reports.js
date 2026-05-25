/* ============================================================
   Panel: Reports & Artifacts Viewer
   Loads artifact index from dashboard/data/reports/artifacts/index.json
   and displays rendered HTML artifacts grouped by category.
   Also loads legacy reports from dashboard/data/reports/index.json.
   ============================================================ */
async function renderPanelReports() {
    const container = document.getElementById('panel-reports');
    if (!container) return;

    container.innerHTML = '<div class="panel-loading">Loading reports...</div>';

    let artifactsData = null;
    let legacyData = null;

    // Try loading artifact index first (individual rendered artifacts)
    try {
        const resp = await fetch('data/reports/artifacts/index.json?' + Date.now());
        if (resp.ok) artifactsData = await resp.json();
    } catch (e) { /* fall through */ }

    // Also try legacy report index
    try {
        const resp = await fetch('data/reports/index.json?' + Date.now());
        if (resp.ok) legacyData = await resp.json();
    } catch (e) { /* fall through */ }

    const categories = artifactsData?.categories || {};
    const allArtifacts = artifactsData?.artifacts || [];
    const legacyReports = legacyData?.reports || [];

    if (Object.keys(categories).length === 0 && legacyReports.length === 0) {
        container.innerHTML = `<div style="color:var(--text-dim);font-size:0.82em;padding:8px 0">
            No reports generated yet.<br>
            Run <code>make reports</code> to render project artifacts to HTML.
        </div>`;
        return;
    }

    // Category order (matching V-Model phases)
    const categoryOrder = [
        'Overview',
        'Project Management',
        'User Needs', 'Risk Inputs',
        'Stakeholder Requirements', 'System Requirements', 'Software Requirements', 'Hardware Requirements',
        'Requirements (Overview)',
        'System Architecture', 'Software Architecture', 'Hardware Architecture',
        'Architecture (Overview)',
        'System Design', 'Software Design', 'Hardware Design',
        'Design (Overview)',
        'Implementation', 'Integration',
        'Unit Tests', 'Integration Tests', 'System Tests', 'Architecture Tests',
        'Verification (Overview)',
        'Validation',
        'Risk Analysis', 'FMEA', 'Safety Classification',
        'Risk Management (Overview)',
        'Regulatory', 'Documentation', 'Templates',
        'Other'
    ];

    let html = '<div style="font-size:0.78em;color:var(--text-dim);margin-bottom:8px">';
    if (allArtifacts.length > 0) {
        html += `${allArtifacts.length} artifact(s) rendered`;
        if (artifactsData?.generated) {
            html += ` — ${artifactsData.generated.replace('T',' ').substring(0,19)}`;
        }
    }
    html += '</div>';

    // Tab bar: switch between "Artifacts" and "Overview Reports"
    html += '<div class="tabs">';
    html += '<div class="tab active" onclick="switchReportTab(this, \'artifacts\')">📄 Artifacts (' + allArtifacts.length + ')</div>';
    if (legacyReports.length > 0) {
        html += '<div class="tab" onclick="switchReportTab(this, \'legacy\')">📊 Overview (' + legacyReports.length + ')</div>';
    }
    html += '</div>';

    // Artifacts tab content
    html += '<div id="report-tab-artifacts" class="report-tab-content" style="max-height:420px;overflow-y:auto">';
    if (Object.keys(categories).length > 0) {
        // Sort categories by order
        const sortedCategories = Object.keys(categories).sort((a, b) => {
            const ai = categoryOrder.indexOf(a), bi = categoryOrder.indexOf(b);
            if (ai === -1 && bi === -1) return a.localeCompare(b);
            if (ai === -1) return 1;
            if (bi === -1) return -1;
            return ai - bi;
        });

        for (const cat of sortedCategories) {
            const items = categories[cat];
            html += `<div style="margin-bottom:6px">`;
            html += `<div class="category-header" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('collapsed')" style="cursor:pointer;padding:6px 8px;background:var(--surface2);border-radius:4px;display:flex;justify-content:space-between;align-items:center;font-size:0.82em">`;
            html += `<span style="color:#fff;font-weight:600">📁 ${cat}</span>`;
            html += `<span style="color:var(--text-dim);font-size:0.85em">${items.length} files</span>`;
            html += `</div>`;
            html += `<div style="margin-top:2px">`;
            for (const item of items) {
                const statusCls = item.status === 'baselined' || item.status === 'approved' ? 'color:var(--success)' : 'color:var(--text-dim)';
                const statusDot = item.status ? `<span style="${statusCls};font-size:0.85em">● </span>` : '';
                html += `<div class="report-item" style="padding:3px 12px">
                    <span style="font-size:0.8em">${statusDot}<span title="${item.source || ''}">${item.title || item.id}</span></span>
                    <span style="display:flex;gap:4px;align-items:center">
                        <button class="btn btn-primary btn-sm" onclick="viewArtifact('${item.file}', '${(item.title||'').replace(/'/g, "\\'")}')">View</button>
                        <a href="data/reports/artifacts/${item.file}" target="_blank" class="btn btn-sm" style="background:var(--surface2);color:var(--text);text-decoration:none;border:1px solid var(--border);padding:4px 8px;font-size:0.75em">↗</a>
                    </span>
                </div>`;
            }
            html += `</div></div>`;
        }
    } else {
        html += '<div style="color:var(--text-dim);font-size:0.82em;padding:8px">No artifact files rendered yet.</div>';
    }
    html += '</div>';

    // Legacy tab content (hidden by default)
    html += '<div id="report-tab-legacy" class="report-tab-content" style="display:none;max-height:420px;overflow-y:auto">';
    for (const r of legacyReports) {
        const sizeKB = r.size ? (r.size / 1024).toFixed(1) + ' KB' : '';
        html += `<div class="report-item">
            <span>📄 ${r.title}</span>
            <span style="display:flex;gap:6px;align-items:center">
                <span style="font-size:0.75em;color:var(--text-dim)">${sizeKB}</span>
                <button class="btn btn-primary btn-sm" onclick="viewReport('${r.file}')">View</button>
                <a href="data/reports/${r.file}" target="_blank" class="btn btn-sm" style="background:var(--surface2);color:var(--text);text-decoration:none;border:1px solid var(--border)">↗</a>
            </span>
        </div>`;
    }
    html += '</div>';

    // Shared viewer
    html += '<div id="report-viewer-container" style="display:none;margin-top:12px">';
    html += '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">';
    html += '<span id="report-viewer-title" style="font-size:0.9em;color:#fff"></span>';
    html += '<button class="btn btn-sm" style="background:var(--surface2);color:var(--text);border:1px solid var(--border)" onclick="closeReport()">✕ Close</button>';
    html += '</div>';
    html += '<iframe id="report-viewer-iframe" class="report-viewer" src=""></iframe>';
    html += '</div>';

    container.innerHTML = html;
}

function switchReportTab(el, tab) {
    // Update tab styles
    const tabs = el.parentElement.querySelectorAll('.tab');
    tabs.forEach(t => t.classList.remove('active'));
    el.classList.add('active');
    // Toggle content
    document.querySelectorAll('.report-tab-content').forEach(c => c.style.display = 'none');
    const target = document.getElementById('report-tab-' + tab);
    if (target) target.style.display = 'block';
}

function viewArtifact(filename, title) {
    const viewer = document.getElementById('report-viewer-container');
    const iframe = document.getElementById('report-viewer-iframe');
    const label = document.getElementById('report-viewer-title');
    if (viewer && iframe) {
        viewer.style.display = 'block';
        iframe.src = 'data/reports/artifacts/' + filename;
        label.textContent = title || filename.replace('.html','').replace(/_/g,' ');
        viewer.scrollIntoView({ behavior: 'smooth' });
    }
}

function viewReport(filename) {
    const viewer = document.getElementById('report-viewer-container');
    const iframe = document.getElementById('report-viewer-iframe');
    const title = document.getElementById('report-viewer-title');
    if (viewer && iframe) {
        viewer.style.display = 'block';
        iframe.src = 'data/reports/' + filename;
        title.textContent = filename.replace('.html','').replace(/-/g,' ').replace(/\b\w/g, c => c.toUpperCase());
        // Scroll to viewer
        viewer.scrollIntoView({ behavior: 'smooth' });
    }
}

function closeReport() {
    const viewer = document.getElementById('report-viewer-container');
    const iframe = document.getElementById('report-viewer-iframe');
    if (viewer && iframe) {
        viewer.style.display = 'none';
        iframe.src = '';
    }
}

if (document.getElementById('panel-reports')) {
    document.addEventListener('DOMContentLoaded', renderPanelReports);
}
