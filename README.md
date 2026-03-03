# BIAS — Background Investigation & Adjudication Services
## v2.1 Production Architecture

---

## Quick Start

Neo4j credentials are pre-configured — no .env needed to get started.
Anthropic key is only needed for the AI Adjudication tab (optional).

### Step 1 — Start the backend

**IMPORTANT: Run uvicorn from inside the `backend/` folder, not from `bias/`**

```bash
cd bias/backend
python3 -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

Or use the one-click script from the bias/ root:
```bash
bash start_backend.sh
```

You should see:
```
✓  Uvicorn running on http://0.0.0.0:8000
```

API docs available at: http://localhost:8000/api/docs

### Step 2 — Open the frontend

**Option A** — Vite dev server (recommended):
```bash
cd bias/frontend
npm install
npm run dev
# Open http://localhost:5173
```

**Option B** — Open `frontend/index.html` directly in your browser
(data will load as long as the backend is running on port 8000)

---

## Getting an Anthropic API Key (for AI Adjudication tab)

1. Go to https://console.anthropic.com
2. Sign in → API Keys → Create Key
3. Copy the key (starts with `sk-ant-...`)
4. Create `bias/backend/.env`:
   ```
   ANTHROPIC_API_KEY=sk-ant-your-key-here
   ```
All other tabs work without this.

---

## Why the backend crashed before

The error `Could not import module "main"` happens when you run
`uvicorn main:app` from the wrong directory. It must be run from
inside `backend/`, not from `bias/`. The `start_backend.sh` script
handles this automatically.

The pip conflicts with Anaconda's pydantic are harmless warnings —
the virtual environment (venv) isolates BIAS from your system Python.
Always activate the venv before running the backend.

---

## Project Structure

```
bias/
├── start_backend.sh         ← one-click backend startup
├── backend/
│   ├── main.py              ← FastAPI entry point (run uvicorn from here)
│   ├── config.py            ← settings (Neo4j creds pre-filled)
│   ├── db.py                ← Neo4j driver
│   └── routers/
│       ├── subjects.py      ← profiles, risk flags, drill-down
│       ├── cases.py         ← overview stats, ROI, documents
│       ├── network.py       ← graph panels
│       ├── adjudication.py  ← timeline, whole-person, AI draft
│       ├── notes.py         ← analyst notes read/write
│       ├── search.py        ← global search
│       ├── compliance.py    ← NIEM counts
│       └── geo.py           ← foreign contacts + coordinates
└── frontend/
    └── src/
        ├── App.jsx                   ← root, routing, state
        ├── api/client.js             ← all API calls (replaces runQuery)
        └── components/
            ├── layout/               ← Header, TabNav, SubjectSelector, DemoRibbon
            └── tabs/
                ├── SubjectDashboard.jsx  ✓ full
                ├── AIAdjudication.jsx    ✓ full
                ├── AnalystNotes.jsx      ✓ full
                ├── GeoMap.jsx            ✓ full
                └── [10 others]          → stub, ready to implement
```

---

## Implementing a Stub Tab

```jsx
import { useData } from '../../api/useData.js'
import { getSomeData } from '../../api/client.js'

export default function MyTab({ caseId }) {
  const { data, loading, error } = useData(() => getSomeData(caseId), [caseId])
  if (loading) return <div className="loading-text">LOADING...</div>
  if (error)   return <div className="error-text">Error: {error}</div>
  return <div>{/* render data */}</div>
}
```
