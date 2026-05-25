/* ============================================================
   V-Model XT — Dashboard Panel Registry & Data Loader
   Modular: each panel is independent. Panels register themselves
   via DashboardPanels.register(). The loader fetches data and
   calls each panel with the combined project + status data.
   ============================================================ */
const DashboardPanels = {
    panels: {},

    register(name, renderFn) {
        this.panels[name] = renderFn;
    },

    async loadAndRender() {
        let data = { project: {}, status: {} };

        // Try API (bidirectional server)
        try {
            const resp = await fetch('/api/status?' + Date.now());
            if (resp.ok) {
                data = await resp.json();
                this.setHeader(data, ' (live API)');
            } else {
                throw new Error('API not available');
            }
        } catch (e) {
            // Fallback: fetch status.json directly
            try {
                const resp = await fetch('data/status.json?' + Date.now());
                if (resp.ok) {
                    data.status = await resp.json();
                    this.setHeader(data, ' (file)');
                }
            } catch (e2) {
               
            }

            // Load project.json
            try {
                const resp = await fetch('data/project.json?' + Date.now());
                if (resp.ok) {
                    data.project = await resp.json();
                }
            } catch (e2) {}
        }

        // If still no data, warn
        if (!data.status || Object.keys(data.status).length === 0) {
            this.setHeader(data, ' (NO DATA — run make init + make dashboard)');
        }

        // Render all registered panels
        for (const [name, renderFn] of Object.entries(this.panels)) {
            try {
                renderFn(data);
            } catch (e) {
                console.error(`Panel "${name}" render error:`, e);
                const el = document.getElementById('panel-' + name);
                if (el) el.innerHTML = `<div class="panel-error">Panel error: ${e.message}</div>`;
            }
        }

        this.updateLastUpdate(data);
    },

    setHeader(data, source) {
        const el = document.getElementById('projectInfo');
        if (!el) return;
        const s = data.status || {};
        const p = data.project?.project || data.project || {};
        el.textContent = `Project: ${s.project || p.name || 'N/A'} (${s.number || p.number || 'N/A'}) | Safety Class: ${s.safety_class || p.safety_class || '?'}${source}`;
    },

    updateLastUpdate(data) {
        const el = document.getElementById('lastUpdate');
        if (!el) return;
        const ts = (data.status?.last_update || '').replace('T', ' ');
        el.textContent = ts ? `Updated: ${ts}` : '';
    }
};

// Auto-load on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    DashboardPanels.loadAndRender();

    // Refresh button
    const btn = document.getElementById('refreshBtn');
    if (btn) {
        btn.addEventListener('click', () => DashboardPanels.loadAndRender());
    }
});
