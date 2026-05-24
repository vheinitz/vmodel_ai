/* ============================================================
   Panel: Reports Viewer
   Loads report index from dashboard/data/reports/index.json
   and displays rendered HTML reports in an iframe.
   ============================================================ */
async function renderPanelReports() {
    const container = document.getElementById('panel-reports');
    if (!container) return;

    container.innerHTML = '<div class="panel-loading">Loading reports...</div>';

    try {
        const resp = await fetch('../../dashboard/data/reports/index.json?' + Date.now());
        if (!resp.ok) throw new Error('No reports generated');
        const data = await resp.json();
        const reports = data.reports || [];

        if (reports.length === 0) {
            container.innerHTML = `<div style="color:var(--text-dim);font-size:0.82em">
                No reports generated yet.<br>
                Run <code>make reports</code> to render project artifacts to HTML.
            </div>`;
            return;
        }

        let html = `<div style="font-size:0.78em;color:var(--text-dim);margin-bottom:10px">
            ${reports.length} report(s) generated: ${(data.generated||'').replace('T',' ').substring(0,19)}
        </div>`;
        html += '<div class="report-list">';
        for (const r of reports) {
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
        html += '<div id="report-viewer-container" style="display:none;margin-top:12px">';
        html += '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">';
        html += '<span id="report-viewer-title" style="font-size:0.9em;color:#fff"></span>';
        html += '<button class="btn btn-sm" style="background:var(--surface2);color:var(--text);border:1px solid var(--border)" onclick="closeReport()">✕ Close</button>';
        html += '</div>';
        html += '<iframe id="report-viewer-iframe" class="report-viewer" src=""></iframe>';
        html += '</div>';
        container.innerHTML = html;
    } catch (e) {
        container.innerHTML = `<div class="panel-error">No reports available. Run <code>make reports</code> to generate them.</div>`;
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
