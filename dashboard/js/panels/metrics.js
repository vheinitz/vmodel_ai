/* ============================================================
   Panel: Key Metrics & Overall Progress
   ============================================================ */
function renderPanelMetrics(data) {
    const container = document.getElementById('panel-metrics');
    if (!container) return;

    const m = data.status?.metrics || data.metrics || {};
    const ac = data.status?.artifact_counts || data.artifact_counts || {};

    const totalReqs = (ac.stakeholder_reqs||0)+(ac.system_reqs||0)+(ac.software_reqs||0)+(ac.hardware_reqs||0);
    const totalArch = (ac.system_arch||0)+(ac.software_arch||0)+(ac.hardware_arch||0);
    const totalDesign = (ac.system_design||0)+(ac.software_design||0);
    const totalTests = (ac.verification_files||0)+(ac.integration_test_files||0)+(ac.system_test_files||0)+(ac.unit_test_files||0);
    const totalRisk = (ac.risk_docs||0)+(ac.fmea_docs||0);

    // Overall progress
    const phases = data.status?.phases || data.phases || {};
    let totalPct = 0, count = 0;
    for (const v of Object.values(phases)) { totalPct += v.completion||0; count++; }
    const avg = count ? Math.round(totalPct/count) : 0;

    container.innerHTML = `
        <div style="text-align:center;margin-bottom:16px">
            <div class="progress-bar" style="height:14px;border-radius:7px">
                <div class="fill" style="width:${avg}%;background:var(--accent)"></div>
            </div>
            <div style="font-size:1.8em;font-weight:700;color:#fff;margin-top:6px">${avg}%</div>
            <div style="font-size:0.78em;color:var(--text-dim)">Overall Completion</div>
        </div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px">
            <div class="metric-box"><div class="mv">${totalReqs||0}</div><div class="ml">Requirements</div></div>
            <div class="metric-box"><div class="mv">${totalArch||0}</div><div class="ml">Architecture</div></div>
            <div class="metric-box"><div class="mv">${totalDesign||0}</div><div class="ml">Design Docs</div></div>
            <div class="metric-box"><div class="mv">${ac.source_files||0}</div><div class="ml">Source Files</div></div>
            <div class="metric-box"><div class="mv">${totalTests||0}</div><div class="ml">Test Artifacts</div></div>
            <div class="metric-box"><div class="mv">${totalRisk||0}</div><div class="ml">Risk Docs</div></div>
            <div class="metric-box"><div class="mv" style="color:${(m.open_defects||0)>0?'var(--danger)':'var(--success)'}">${m.open_defects||0}</div><div class="ml">Open Defects</div></div>
            <div class="metric-box"><div class="mv">${m.code_coverage_percent||0}%</div><div class="ml">Code Coverage</div></div>
        </div>
    `;
}

// Inject metric box styles
const metricStyles = document.createElement('style');
metricStyles.textContent = `
    .metric-box{background:var(--surface2);padding:10px;border-radius:6px;text-align:center}
    .metric-box .mv{font-size:1.4em;font-weight:700;color:#fff}
    .metric-box .ml{font-size:0.7em;color:var(--text-dim);margin-top:2px}
`;
document.head.appendChild(metricStyles);

if (typeof DashboardPanels !== 'undefined') {
    DashboardPanels.register('metrics', renderPanelMetrics);
}
