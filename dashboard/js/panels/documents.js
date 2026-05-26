/* ============================================================
   Panel: Document / Artifact Inventory
   Shows artifact counts organized by V-Model phase
   ============================================================ */
function renderPanelDocuments(data) {
    const container = document.getElementById('panel-documents');
    if (!container) return;

    const ac = data.status?.artifact_counts || data.artifact_counts || {};

    const sections = [
        {
            label: 'Requirements',
            items: [
                { key: 'stakeholder_reqs', label: 'Stakeholder Needs (STK)' },
                { key: 'system_reqs', label: 'System Requirements (REQ-SYS)' },
                { key: 'software_reqs', label: 'Software Requirements (REQ-SW)' },
                { key: 'hardware_reqs', label: 'Hardware Requirements (REQ-HW)' },
            ]
        },
        {
            label: 'Architecture & Design',
            items: [
                { key: 'system_arch', label: 'System Architecture (COMP)' },
                { key: 'software_arch', label: 'Software Architecture (COMP)' },
                { key: 'hardware_arch', label: 'Hardware Architecture' },
                { key: 'system_design', label: 'System Design (MOD)' },
                { key: 'software_design', label: 'Software Design (MOD)' },
            ]
        },
        {
            label: 'Implementation',
            items: [
                { key: 'source_files', label: 'Source Files' },
                { key: 'unit_test_files', label: 'Unit Test Files' },
                { key: 'unit_test_files_md', label: 'Unit Test Documentation' },
            ]
        },
        {
            label: 'Verification & Validation',
            items: [
                { key: 'verification_files', label: 'Verification Documents' },
                { key: 'integration_test_files', label: 'Integration Tests (TC-INT)' },
                { key: 'system_test_files', label: 'System Tests (TC-SYS)' },
            ]
        },
        {
            label: 'Risk Management',
            items: [
                { key: 'risk_docs', label: 'Risk Analysis Documents' },
                { key: 'fmea_docs', label: 'FMEA Entries' },
            ]
        },
        {
            label: 'Project Management',
            items: [
                { key: 'project_mgmt', label: 'Project Management Docs' },
            ]
        },
    ];

    let totalAll = 0;
    let html = '<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:16px">';

    for (const section of sections) {
        let sectionTotal = 0;
        let itemsHtml = '';
        for (const item of section.items) {
            const count = ac[item.key] || 0;
            sectionTotal += count;
            itemsHtml += `
                <div style="display:flex;justify-content:space-between;padding:3px 0;font-size:0.82em">
                    <span style="color:var(--text-dim)">${item.label}</span>
                    <span style="font-weight:600;color:${count > 0 ? '#fff' : 'var(--text-dim)'}">${count}</span>
                </div>`;
        }
        totalAll += sectionTotal;

        html += `<div style="background:var(--surface2);border-radius:8px;padding:14px">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;border-bottom:1px solid var(--border);padding-bottom:8px">
                <span style="font-weight:600;color:#fff;font-size:0.9em">📂 ${section.label}</span>
                <span style="background:var(--accent);color:#fff;border-radius:10px;padding:2px 8px;font-size:0.78em;font-weight:600">${sectionTotal}</span>
            </div>
            ${itemsHtml}
        </div>`;
    }
    html += '</div>';

    // Summary bar
    html += `<div style="margin-top:16px;padding:10px 16px;background:var(--surface2);border-radius:8px;display:flex;align-items:center;gap:12px;font-size:0.85em">
        <span style="color:var(--text-dim)">Total artifacts:</span>
        <span style="font-size:1.3em;font-weight:700;color:#fff">${totalAll}</span>
        <span style="color:var(--text-dim);font-size:0.8em;margin-left:auto">Run <code>make dashboard</code> to refresh</span>
    </div>`;

    container.innerHTML = html;
}

if (typeof DashboardPanels !== 'undefined') {
    DashboardPanels.register('documents', renderPanelDocuments);
}
