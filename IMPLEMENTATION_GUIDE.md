# 📃 DETAILLIERTE IMPLEMENTIERUNGSANLEITUNG

## Genesis Core Reconstruction - Vollständiger Leitfaden

---

## TEIL 1: VORBEREITUNG

### Schritt 1.1: Umgebung prüfen

```bash
# Python-Version
python3 --version
# Erwartet: Python 3.11+

# Git installiert?
git --version

# Speicherplatz
df -h
# Erwartet: mind. 500MB verfolgbar
```

### Schritt 1.2: Repository klonen

```bash
git clone https://github.com/Newboy667/genesis-core-reconstruction.git
cd genesis-core-reconstruction

# Branch überprüfen
git branch -v
```

### Schritt 1.3: Virtuelle Umgebung erstellen

```bash
# Erstellen
python3 -m venv venv

# Aktivieren (Linux/macOS)
source venv/bin/activate

# Aktivieren (Windows PowerShell)
.\venv\Scripts\Activate.ps1

# Pip upgraden
pip install --upgrade pip setuptools wheel
```

---

## TEIL 2: KONFIGURATION

### Schritt 2.1: Environment-Datei erstellen

```bash
# .env.example kopieren
cp .env.example .env

# Mit deinem Editor öffnen
vim .env  # oder nano, gedit, VSCode
```

### Schritt 2.2: Kritische Parameter setzen

```bash
# In .env:

# 1. Umgebung
ENVIRONMENT=development    # oder production
DEBUG=true                 # oder false in production

# 2. Datenbank (OPTIONAL - falls PostgreSQL verfügbar)
# Wenn nicht gesetzt: verwendet SQLite fallback
DATABASE_URL=sqlite:///./genesis_core.db
# ODER für PostgreSQL:
# DATABASE_URL=postgresql://user:password@localhost:5432/genesis_core

# 3. GEMINI API Key (ERFORDERLICH!)
# Von https://makersuite.google.com/app/apikey abrufen
GEMINI_API_KEY=sk_live_xxxxxxxxxxxxxxxxxxxxx

# 4. Optional: Ollama lokal
OLLAMA_API_URL=http://localhost:11434

# 5. Agenten-Verhalten
MAX_AGENT_TASKS=10
AGENT_TIMEOUT_SECONDS=300
ENABLE_HUMAN_APPROVAL=true

# 6. Sandbox
SANDBOX_TIMEOUT=60
SANDBOX_CLEANUP=true
```

### Schritt 2.3: Konfiguration validieren

```bash
# Syntax prüfen
python3 -c "from pathlib import Path; print(Path('.env').read_text())"

# Später nach Installation testen:
python3 -c "from core.config import get_config; cfg = get_config(); print(cfg.environment)"
```

---

## TEIL 3: AUTOMATISCHE INSTALLATION

### Schritt 3.1: Rekonstruktions-Skript ausführen

```bash
# Linux/macOS
chmod +x run_reconstruction.sh
./run_reconstruction.sh

# Windows (PowerShell)
python3 genesis_reconstruction.py
```

### Schritt 3.2: Fortschritt überwachen

Während der Ausführung siehst du:

```
==============================================================================
🚀 GENESIS CORE RECONSTRUCTION - AUTOMATISCHE IMPLEMENTIERUNG
==============================================================================
Strategischer Evolutionsplan für KI-Agenten-Architekturen
==============================================================================

[INFO] 
========================🔧 PHASE 1: INITIALIZATION
========================
✓ Erstellt: core
✓ Erstellt: api
... (mehr Verzeichnisse)
✅ Phase INITIALIZATION erfolgreich (250ms)

[INFO]
========================📋 PHASE 2: FILESYSTEM
========================
... (Dateierstellung)
✅ Phase FILESYSTEM erfolgreich (50ms)

... (weitere Phasen)
✅ Dateisystem-Struktur initialisiert (13 Ordner, 4 Dateien)
```

### Schritt 3.3: Auf Abschluss warten

Die Rekonstruktion dauert normalerweise **1-5 Minuten** abhängig von:
- Internetgeschwindigkeit (für API-Requests)
- Systemleistung
- Verfugbarkeit externer Tools (Mypy, Ruff, Bandit)

**Erfolgreiche Beendigung:**
```
==============================================================================
📊 REKONSTRUKTION ABGESCHLOSSEN
==============================================================================
Phasen erfolgreich: 10/10
Selbsttest: ✅ BESTANDEN
Gesamtstatus: ✅ ERFOLGREICH
==============================================================================

📄 Report exportiert: ./genesis_core/reconstruction_report_20250101_120000.json
📁 Projekt-Verzeichnis: ./genesis_core
✨ Genesis Core Rekonstruktion ABGESCHLOSSEN!
```

---

## TEIL 4: POST-INSTALLATION VERIFIKATION

### Schritt 4.1: Verzeichnisstruktur überprüfen

```bash
ls -la genesis_core/

# Erwartet:
core/
api/
modules/
shared/
expert_tools/
data/
logs/
tests/
requirements.txt
pyproject.toml
.env
.gitignore
```

### Schritt 4.2: Dependencies installieren

```bash
cd genesis_core
pip install -r requirements.txt

# Mit Fortschrittsanzeige
pip install -r requirements.txt --verbose
```

### Schritt 4.3: Imports testen

```bash
# Python-Shell öffnen
python3

# Testen:
from core.config import get_config
from core.analyzer import GenesisScanner
from core.dci import DeterministicControlInstance
from core.orchestrator import Orchestrator
from api.server import GenesisAPI

print("✅ Alle Imports erfolgreich!")
exit()
```

### Schritt 4.4: Report analysieren

```bash
# Report öffnen
python3 -m json.tool logs/genesis_reconstruction_*.log | head -50

# Oder mit jq (wenn installiert):
jq '.phases' logs/reconstruction_report_*.json
```

---

## TEIL 5: DATENBANK-INITIALISIERUNG (Optional)

### Schritt 5.1: PostgreSQL vorbereiten

```bash
# Wenn PostgreSQL lokal läuft:
sudo -u postgres createdb genesis_core

# Benutzer erstellen:
sudo -u postgres createuser genesis --password

# Berechtigungen:
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE genesis_core TO genesis;"
```

### Schritt 5.2: Tabellen erstellen

```python
# Python-Script ausführen:
import asyncio
from sqlalchemy import create_engine
from shared.database.models import Base
from core.config import get_config

config = get_config()
engine = create_engine(config.database_url)
Base.metadata.create_all(engine)

print("✅ Datenbank-Tabellen erstellt")
```

---

## TEIL 6: API-SERVER STARTEN

### Schritt 6.1: Flask-Server starten

```bash
cd genesis_core
python3 api/server.py

# Erwartet:
 * Running on http://127.0.0.1:5000
 * Press CTRL+C to quit
```

### Schritt 6.2: Health-Check durchführen

```bash
# In neuem Terminal:
curl http://localhost:5000/api/health

# Erwartet:
{"status": "healthy", "version": "5.0.0"}
```

### Schritt 6.3: Weitere API-Tests

```bash
# Projekte abrufen
curl http://localhost:5000/api/projects

# Tasks abrufen
curl http://localhost:5000/api/tasks

# WebSocket verbinden (browser console)
const ws = new WebSocket('ws://localhost:5000/socket.io/?transport=websocket');
ws.onopen = () => console.log('Connected');
```

---

## TEIL 7: LOGS ÜBERWACHEN

### Schritt 7.1: Real-time Log-Verfolgung

```bash
# Alle Logs
tail -f genesis_core/logs/genesis_reconstruction_*.log

# Nur Fehler
grep ERROR genesis_core/logs/genesis_reconstruction_*.log

# Nach Agent-ID
grep "Agent:engineer" genesis_core/logs/genesis_reconstruction_*.log
```

### Schritt 7.2: Log-Analyse

```python
import json
from pathlib import Path

# Report laden
report_file = sorted(Path('genesis_core').glob('reconstruction_report_*.json'))[-1]
report = json.loads(report_file.read_text())

# Phasen-Status
for phase, data in report['phases'].items():
    print(f"{phase}: {data['status']}")
```

---

## TEIL 8: ERSTE VERWENDUNG

### Schritt 8.1: Projekt erstellen

```python
from pathlib import Path
from shared.database.models import Project
from sqlalchemy.orm import Session

# DB Session öffnen
session = Session(engine)

# Projekt erstellen
project = Project(
    name="My First Project",
    path="/path/to/project",
    description="Test project"
)
session.add(project)
session.commit()

print(f"✅ Projekt erstellt: {project.name}")
```

### Schritt 8.2: Datei analysieren

```python
from core.analyzer import scan_python_file
from pathlib import Path

result = scan_python_file(Path("my_module.py"))
print(f"Elemente: {result['element_count']}")
print(f"Komplexität: {result['total_complexity']}")

for element in result['elements']:
    print(f"  - {element['name']} ({element['type']}): {element['complexity']}")
```

### Schritt 8.3: Code validieren

```python
import asyncio
from core.dci import DeterministicControlInstance

async def validate():
    dci = DeterministicControlInstance()
    
    code = '''
def hello(name: str) -> str:
    return f"Hello, {name}!"
'''
    
    valid, results = await dci.validate_code(
        Path("test.py"),
        code
    )
    
    print(f"Valid: {valid}")
    print(f"Results: {results}")

asyncio.run(validate())
```

---

## TEIL 9: TROUBLESHOOTING

### Problem: "ModuleNotFoundError: No module named 'X'"

```bash
# venv aktivieren?
source venv/bin/activate

# Dependencies installieren
pip install -r genesis_core/requirements.txt

# Spezifisches Paket
pip install sqlalchemy flask pydantic
```

### Problem: "DATABASE_URL invalid"

```bash
# .env prüfen
grep DATABASE_URL .env

# PostgreSQL läuft?
pg_isready

# oder SQLite verwenden:
DATABASE_URL=sqlite:///./genesis_core.db
```

### Problem: "GEMINI_API_KEY not set"

```bash
# API-Key von https://makersuite.google.com generieren
# In .env setzen:
GEMINI_API_KEY=sk_live_xxxxxxxxxxxxx

# Validieren:
python3 -c "import os; print(os.getenv('GEMINI_API_KEY'))"
```

### Problem: "Permission denied" beim Ausführen des Shell-Scripts

```bash
chmod +x run_reconstruction.sh
./run_reconstruction.sh
```

### Problem: "Port 5000 already in use"

```bash
# Andere Prozesse finden
lsof -i :5000

# Und killen
kill -9 <PID>

# oder anderen Port verwenden
python3 api/server.py --port 5001
```

---

## TEIL 10: NÄCHSTE SCHRITTE

### Fortgeschrittene Konfiguration

1. **Multi-LLM Support**
   - OpenAI, Anthropic hinzufügen
   - Fallback-Logik implementieren

2. **Docker Deployment**
   - Dockerfile erstellen
   - Docker Compose orchestrieren

3. **CI/CD Pipeline**
   - GitHub Actions einrichten
   - Automatische Tests

4. **Frontend Dashboard**
   - React/Vue.js UI bauen
   - WebSocket-Integration

5. **Expert-Tools Integration**
   - Alle 145 Tools migrieren
   - Custom Tool-Entwicklung

---

## Erfolgs-Checkliste

- [ ] Python 3.11+ installiert
- [ ] Repository geklont
- [ ] venv erstellt & aktiviert
- [ ] .env konfiguriert mit GEMINI_API_KEY
- [ ] Rekonstruktions-Skript ausgeführt
- [ ] genesis_core/ Verzeichnis erstellt
- [ ] Alle 10 Phasen erfolgreich
- [ ] Dependencies installiert
- [ ] Imports funktionieren
- [ ] API-Server startet
- [ ] Health-Check bestätigt
- [ ] Logs Überwachung läuft

---

**📄 Wenn alle Schritte erfolgreich: Genesis Core ist vollständig funktionsfähig!**

Fragen? Siehe [README.md](./README.md) oder die Logs in `genesis_core/logs/`
