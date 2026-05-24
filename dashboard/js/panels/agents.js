/* ============================================================
   Panel: Agent Status
   ============================================================ */
function renderPanelAgents(data) {
    const container = document.getElementById('panel-agents');
    if (!container) return;

    const agents = data.status?.agents || data.agents || {};
    let html = '';
    for (const [name, info] of Object.entries(agents)) {
        const s = info.status || 'idle';
        const lastRun = info.last_run ? info.last_run.replace('T',' ').substring(0,16) : 'never';
        html += `<div style="display:flex;align-items:center;justify-content:space-between;padding:6px 10px;background:var(--surface2);border-radius:6px;margin-bottom:4px;font-size:0.78em">
            <span style="text-transform:capitalize">${name.replace(/-/g,' ')}</span>
            <span style="padding:2px 8px;border-radius:10px;font-size:0.85em;
                ${s==='idle'?'color:#888;background:#222':
                  s==='running'?'color:#3498db;background:#1a2d44':
                  s==='done'?'color:#2ecc71;background:#1a3d2b':
                  'color:#e74c3c;background:#3d1a1a'}">${s}</span>
            <span style="font-size:0.85em;color:var(--text-dim)" title="Last run">${lastRun}</span>
        </div>`;
    }
    // Agent suggestions
    let suggestions = '';
    for (const [name, info] of Object.entries(agents)) {
        if (info.suggestions && info.suggestions.length > 0) {
            suggestions += `<div style="font-size:0.78em;margin-top:8px"><strong style="text-transform:capitalize">${name.replace(/-/g,' ')}:</strong>`;
            for (const s of info.suggestions) {
                suggestions += `<div style="padding:2px 0 2px 10px;border-left:2px solid var(--accent);margin:3px 0;color:var(--text-dim)">→ ${s}</div>`;
            }
            suggestions += '</div>';
        }
    }
    container.innerHTML = html + (suggestions || '<div style="font-size:0.78em;color:var(--text-dim);margin-top:8px">Run <code>make agents</code> for AI suggestions.</div>');
}

if (typeof DashboardPanels !== 'undefined') {
    DashboardPanels.register('agents', renderPanelAgents);
}
