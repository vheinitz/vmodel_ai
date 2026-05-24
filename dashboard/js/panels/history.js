/* ============================================================
   Panel: Activity History
   Loads history.json independently and renders a timeline.
   ============================================================ */
async function renderPanelHistory() {
    const container = document.getElementById('panel-history');
    if (!container) return;

    container.innerHTML = '<div class="panel-loading">Loading history...</div>';

    try {
        const resp = await fetch('../../dashboard/data/history.json?' + Date.now());
        if (!resp.ok) throw new Error('HTTP ' + resp.status);
        const data = await resp.json();
        const activities = data.activities || [];

        if (activities.length === 0) {
            container.innerHTML = '<div style="color:var(--text-dim);font-size:0.82em">No activity recorded yet. Run agents or use the prompt panel.</div>';
            return;
        }

        // Show last 50, newest first
        const recent = activities.slice(-50).reverse();
        let html = '<div class="timeline">';
        for (const a of recent) {
            const ts = (a.timestamp || '').replace('T', ' ').substring(0, 19);
            html += `<div class="timeline-entry">
                <div class="ts">${ts}</div>
                <span class="agent-tag">${(a.agent||'unknown').replace(/-/g,' ')}</span>
                <span>${a.action || ''}</span>
                ${a.details ? `<div style="color:var(--text-dim);margin-top:2px;font-size:0.9em">${a.details}</div>` : ''}
            </div>`;
        }
        html += '</div>';
        if (activities.length > 50) {
            html += `<div style="text-align:center;color:var(--text-dim);font-size:0.75em;margin-top:8px">Showing last 50 of ${activities.length} activities</div>`;
        }
        container.innerHTML = html;
    } catch (e) {
        container.innerHTML = `<div class="panel-error">Could not load history: ${e.message}. Run <code>make dashboard</code>.</div>`;
    }
}

// Auto-load if element exists (doesn't need register — loads independently)
if (document.getElementById('panel-history')) {
    document.addEventListener('DOMContentLoaded', renderPanelHistory);
}
