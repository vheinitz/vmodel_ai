/* ============================================================
   Panel: V-Model Phase Diagram
   Self-contained — only reads data, writes to #panel-vmodel
   ============================================================ */
function renderPanelVModel(data) {
    const container = document.getElementById('panel-vmodel');
    if (!container) return;

    const phases = data.status?.phases || data.phases || {};

    const leftPhases = [
        { key: '00_project_initiation', label: 'Initiation' },
        { key: '01_requirements', label: 'Requirements' },
        { key: '02_architecture', label: 'Architecture' },
        { key: '03_design', label: 'Design' },
    ];
    const rightPhases = [
        { key: '07_validation', label: 'Validation (OQ/PQ)' },
        { key: '06_verification', label: 'Verification' },
        { key: '05_integration', label: 'Integration' },
        { key: '04_implementation', label: 'Implementation' },
    ];

    function vnode(label, info) {
        const s = info?.status || 'pending';
        const pct = info?.completion || 0;
        return `<div class="vnode status-${s}" title="${label}: ${pct}%">
            <span class="status-dot dot-${s}"></span>
            <span style="flex:1;font-size:0.78em">${label}</span>
            <span style="font-weight:600;font-size:0.78em">${pct}%</span>
        </div>`;
    }

    let html = '<div style="display:grid;grid-template-columns:1fr 40px 1fr;gap:2px;align-items:start">';
    html += '<div style="display:flex;flex-direction:column;gap:2px">';
    for (const p of leftPhases) html += vnode(p.label, phases[p.key]);
    html += '</div>';

    html += '<div style="display:flex;flex-direction:column;align-items:center;justify-content:center;color:var(--text-dim);font-size:0.7em;padding-top:8px">';
    html += '<div style="color:var(--accent)">▼ Def</div><div>│</div>';
    html += '<div>Impl</div><div>│</div>';
    html += '<div style="color:var(--accent)">▲ Int</div>';
    html += '</div>';

    html += '<div style="display:flex;flex-direction:column;gap:2px">';
    for (const p of rightPhases) html += vnode(p.label, phases[p.key]);
    html += '</div>';
    html += '</div>';

    container.innerHTML = html;
}

// Register panel
if (typeof DashboardPanels !== 'undefined') {
    DashboardPanels.register('vmodel', renderPanelVModel);
}
