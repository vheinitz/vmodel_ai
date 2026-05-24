/* ============================================================
   Panel: Bidirectional Prompt Interface
   Accepts user prompts and launches pi in the project directory.
   Falls back to showing a copyable shell command.
   ============================================================ */
async function renderPanelPrompt() {
    const container = document.getElementById('panel-prompt');
    if (!container) return;

    let projectDir = '';
    try {
        const resp = await fetch('/api/project-dir');
        if (resp.ok) {
            const data = await resp.json();
            projectDir = data.project_dir || '';
        }
    } catch (e) {
        // Server not running — detect from URL
        projectDir = window.location.pathname.replace(/\/dashboard\/.*/, '') || '(project directory)';
    }

    container.innerHTML = `
        <div style="margin-bottom:10px">
            <div style="font-size:0.78em;color:var(--text-dim);margin-bottom:6px">
                📁 ${projectDir}
            </div>
            <textarea id="prompt-textarea" class="prompt-input"
                placeholder="Type a prompt for the AI coding agent...&#10;&#10;Examples:&#10;• Analyze src/MainTool/ and suggest UI improvements&#10;• Review requirements for completeness&#10;• Generate unit tests for DataAnalyser&#10;• Run innovation review" 
            ></textarea>
        </div>
        <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
            <button class="btn btn-primary" onclick="submitPrompt()" id="prompt-submit-btn">
                🚀 Send to pi
            </button>
            <button class="btn" style="background:var(--surface2);color:var(--text);border:1px solid var(--border)" onclick="copyPromptCommand()">
                📋 Copy Command
            </button>
            <span style="font-size:0.75em;color:var(--text-dim)" id="prompt-status"></span>
        </div>
        <div id="prompt-result"></div>
        <div style="margin-top:12px;border-top:1px solid var(--border);padding-top:10px">
            <div style="font-size:0.78em;color:var(--text-dim);margin-bottom:6px">Quick Actions:</div>
            <div style="display:flex;gap:6px;flex-wrap:wrap">
                ${quickAction('make all', 'Full analysis cycle')}
                ${quickAction('make agents', 'Trigger all agents')}
                ${quickAction('make dashboard', 'Update dashboard')}
                ${quickAction('make reports', 'Generate reports')}
                ${quickAction('make innovate', 'Innovation review')}
                ${quickAction('make medical-review', 'Medical review')}
            </div>
        </div>
    `;
}

function quickAction(cmd, label) {
    return `<button class="btn btn-sm" style="background:var(--surface2);color:var(--text);border:1px solid var(--border)"
        onclick="document.getElementById('prompt-textarea').value='${cmd}';submitPrompt()"
        title="${label}">⚡ ${cmd}</button>`;
}

async function submitPrompt() {
    const textarea = document.getElementById('prompt-textarea');
    const resultDiv = document.getElementById('prompt-result');
    const statusSpan = document.getElementById('prompt-status');
    const prompt = textarea.value.trim();

    if (!prompt) {
        showSnackbar('Please enter a prompt', 'error');
        return;
    }

    statusSpan.textContent = 'Sending...';
    resultDiv.innerHTML = '';

    try {
        const resp = await fetch('/api/prompt', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ prompt: prompt })
        });
        const data = await resp.json();

        if (data.status === 'launched') {
            statusSpan.textContent = '';
            resultDiv.innerHTML = `<div class="prompt-result success">
                ✅ pi launched (PID: ${data.pid})<br>
                <span style="font-size:0.85em;opacity:0.8">Prompt: "${data.prompt}"</span>
            </div>`;
            showSnackbar('pi launched successfully', 'success');
            textarea.value = '';
        } else if (data.status === 'command-only' || data.status === 'dry-run') {
            statusSpan.textContent = 'Command ready';
            resultDiv.innerHTML = `<div class="prompt-result info">
                📋 Run this command in your terminal:
                <pre>${escapeHtml(data.command)}</pre>
                <button class="btn btn-sm btn-primary" style="margin-top:6px" onclick="navigator.clipboard.writeText('${escapeHtml(data.command).replace(/'/g, "\\'")}')">📋 Copy</button>
            </div>`;
            showSnackbar('Command copied — paste in terminal', 'info');
        } else if (data.error) {
            statusSpan.textContent = '';
            resultDiv.innerHTML = `<div class="prompt-result" style="background:#3d1a1a;color:var(--danger)">❌ ${data.error}</div>`;
        }
    } catch (e) {
        // Server not available — show command
        statusSpan.textContent = '';
        const cmd = `cd "$(pwd)" && pi '${prompt.replace(/'/g, "'\\''")}'`;
        resultDiv.innerHTML = `<div class="prompt-result info">
            ⚠ Dashboard server not running.<br>
            Run this in your terminal:
            <pre>${escapeHtml(cmd)}</pre>
            <div style="margin-top:8px">
                <button class="btn btn-sm btn-primary" onclick="navigator.clipboard.writeText('${escapeHtml(cmd).replace(/'/g, "\\'")}')">📋 Copy</button>
                <span style="font-size:0.75em;color:var(--text-dim);margin-left:8px">Or start server: <code>make serve</code></span>
            </div>
        </div>`;
        showSnackbar('Server not running — copy the command', 'info');
    }
}

function copyPromptCommand() {
    const textarea = document.getElementById('prompt-textarea');
    const prompt = textarea.value.trim();
    if (!prompt) { showSnackbar('Enter a prompt first', 'error'); return; }

    const cmd = `cd "$(pwd)" && pi '${prompt.replace(/'/g, "'\\''")}'`;
    navigator.clipboard.writeText(cmd).then(() => {
        showSnackbar('Command copied to clipboard', 'success');
    }).catch(() => {
        // Fallback: show in result
        document.getElementById('prompt-result').innerHTML = `<div class="prompt-result info"><pre>${escapeHtml(cmd)}</pre></div>`;
    });
}

function escapeHtml(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function showSnackbar(msg, type) {
    const existing = document.querySelector('.snackbar');
    if (existing) existing.remove();
    const el = document.createElement('div');
    el.className = `snackbar ${type}`;
    el.textContent = msg;
    document.body.appendChild(el);
    setTimeout(() => el.remove(), 4000);
}

if (document.getElementById('panel-prompt')) {
    document.addEventListener('DOMContentLoaded', renderPanelPrompt);
}
