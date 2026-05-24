/* ============================================================
   Panel: Decision Gates
   ============================================================ */
function renderPanelGates(data) {
    const container = document.getElementById('panel-gates');
    if (!container) return;

    const gates = data.status?.decision_gates || data.decision_gates || {};
    const labels = {
        'G1_project_approved': 'G1: Approved',
        'G2_requirements_baselined': 'G2: Reqs Baselined',
        'G3_architecture_defined': 'G3: Architecture',
        'G4_design_completed': 'G4: Design',
        'G5_implementation_done': 'G5: Impl Done',
        'G6_integration_done': 'G6: Integ Done',
        'G7_verification_done': 'G7: Verified',
        'G8_validation_done': 'G8: Validated',
        'G9_project_completed': 'G9: Completed'
    };

    let html = '<div style="display:flex;flex-wrap:wrap;gap:8px">';
    for (const [key, label] of Object.entries(labels)) {
        const passed = gates[key] || false;
        html += `<span style="padding:4px 10px;border-radius:20px;font-size:0.75em;font-weight:600;
            ${passed ? 'background:#1a3d2b;color:#2ecc71;border:1px solid #2ecc71' : 'background:#2a2a2a;color:#888;border:1px solid #444'}">
            ${passed ? '✅' : '⏳'} ${label}</span>`;
    }
    html += '</div>';
    container.innerHTML = html;
}

if (typeof DashboardPanels !== 'undefined') {
    DashboardPanels.register('gates', renderPanelGates);
}
