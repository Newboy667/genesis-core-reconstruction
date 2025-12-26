#!/bin/bash

################################################################################
# GENESIS CORE RECONSTRUCTION - EXECUTER SCRIPT
# Automatische Ausführung mit vollständiger Fehlerbehandlung
################################################################################

set -euo pipefail

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Konstanten
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="Genesis Core Reconstruction"
VERSION="5.0.0"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

################################################################################
# HILFSFUNKTIONEN
################################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_header() {
    echo ""
    echo "════════════════════════════════════════════════════════════════════════════════"
    echo "  $1"
    echo "════════════════════════════════════════════════════════════════════════════════"
    echo ""
}

check_python_version() {
    log_info "Überprüfe Python-Version..."
    
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 nicht gefunden!"
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    REQUIRED_VERSION="3.11"
    
    if [[ $(echo -e "$PYTHON_VERSION\n$REQUIRED_VERSION" | sort -V | head -n1) != $REQUIRED_VERSION ]]; then
        log_error "Python $REQUIRED_VERSION oder höher erforderlich (gefunden: $PYTHON_VERSION)"
        exit 1
    fi
    
    log_success "Python $PYTHON_VERSION ✓"
}

setup_venv() {
    log_info "Erstelle virtuelle Umgebung..."
    
    VENV_DIR="${SCRIPT_DIR}/venv"
    
    if [ -d "$VENV_DIR" ]; then
        log_warning "Virtuelle Umgebung existiert bereits. Lösche und erstelle neu..."
        rm -rf "$VENV_DIR"
    fi
    
    python3 -m venv "$VENV_DIR"
    source "${VENV_DIR}/bin/activate"
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel > /dev/null 2>&1
    
    log_success "Virtuelle Umgebung erstellt ✓"
}

run_reconstruction() {
    print_header "🚀 GENESIS CORE RECONSTRUCTION STARTET"
    
    log_info "Projekt: $PROJECT_NAME"
    log_info "Version: $VERSION"
    log_info "Timestamp: $TIMESTAMP"
    log_info "Basis-Verzeichnis: $SCRIPT_DIR"
    echo ""
    
    cd "$SCRIPT_DIR"
    python3 genesis_reconstruction.py
    
    RECONSTRUCTION_EXIT_CODE=$?
    
    if [ $RECONSTRUCTION_EXIT_CODE -eq 0 ]; then
        log_success "Rekonstruktion erfolgreich abgeschlossen!"
        return 0
    else
        log_error "Rekonstruktion mit Fehler beendet (Code: $RECONSTRUCTION_EXIT_CODE)"
        return 1
    fi
}

post_reconstruction_checks() {
    print_header "🔍 POST-REKONSTRUKTION VERIFIKATION"
    
    CHECKS_PASSED=0
    CHECKS_TOTAL=0
    
    # Array von Checks
    declare -a checks=(
        "genesis_core:Hauptverzeichnis"
        "genesis_core/core/config.py:Konfigurationsmodul"
        "genesis_core/core/analyzer.py:AST-Analyzer"
        "genesis_core/core/dci.py:DCI-Validierung"
        "genesis_core/core/orchestrator.py:Orchestrator"
        "genesis_core/core/injection_engine.py:Injektions-Engine"
        "genesis_core/shared/database/models.py:ORM-Modelle"
        "genesis_core/api/server.py:API-Server"
        "genesis_core/requirements.txt:Abhängigkeiten"
        "genesis_core/pyproject.toml:Projekt-Konfiguration"
    )
    
    for check in "${checks[@]}"; do
        IFS=':' read -r path description <<< "$check"
        CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
        
        if [ -e "${SCRIPT_DIR}/$path" ]; then
            log_success "$description"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
        else
            log_error "$description - NICHT GEFUNDEN: $path"
        fi
    done
    
    echo ""
    echo "Verifikation: $CHECKS_PASSED/$CHECKS_TOTAL bestanden"
    
    if [ $CHECKS_PASSED -eq $CHECKS_TOTAL ]; then
        log_success "Alle Verifikationen bestanden ✓"
        return 0
    else
        log_warning "Einige Verifikationen fehlgeschlagen"
        return 1
    fi
}

print_final_summary() {
    print_header "📊 REKONSTRUKTION ABGESCHLOSSEN"
    
    echo -e "${GREEN}✓ Genesis Core erfolgreich rekonstruiert!${NC}"
    echo ""
    echo "Projektstruktur erstellt unter: ${SCRIPT_DIR}/genesis_core"
    echo ""
    echo "Nächste Schritte:"
    echo "  1. Überprüfe die README.md im genesis_core Verzeichnis"
    echo "  2. Konfiguriere .env mit deinen API-Keys"
    echo "  3. Starte den API-Server: python api/server.py"
    echo "  4. Öffne http://localhost:5000 im Browser"
    echo ""
    echo "Logs: genesis_core/logs/genesis_reconstruction_${TIMESTAMP}.log"
    echo ""
}

handle_error() {
    print_header "✗ FEHLER WÄHREND REKONSTRUKTION"
    log_error "Ein Fehler ist aufgetreten!"
    log_info "Überprüfe die Logs für weitere Details."
    exit 1
}

################################################################################
# HAUPTPROGRAMM
################################################################################

main() {
    trap handle_error ERR
    
    print_header "🔧 GENESIS CORE RECONSTRUCTION INITIALIZATION"
    
    # Überprüfungen
    check_python_version
    setup_venv
    
    # Hauptrekonstruktion
    run_reconstruction || return 1
    
    # Post-Verifikation
    post_reconstruction_checks || {
        log_warning "Einige Verifikationen fehlgeschlagen, fahre trotzdem fort..."
    }
    
    # Zusammenfassung
    print_final_summary
}

# Starte Hauptprogramm
main
exit $?
