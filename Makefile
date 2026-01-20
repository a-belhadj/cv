# Makefile pour compiler un CV LaTeX avec Podman

LATEX_IMAGE = ghcr.io/a-belhadj/cv-latex:latest
SOURCE_DIR = $(shell pwd)
LATEX_DIR = latex
MAIN_FILE_FULL = $(LATEX_DIR)/cv-full.tex
MAIN_FILE_PUBLIC = $(LATEX_DIR)/cv-public.tex
MAIN_FILE_OLD = $(LATEX_DIR)/cv.tex
OUTPUT_PDF_FULL = cv-full.pdf
OUTPUT_PDF_PUBLIC = cv-public.pdf

PODMAN_OPTS = --rm \
              --volume $(SOURCE_DIR):/workspace:Z \
              --workdir /workspace

.PHONY: build build-full build-public build-both view view-full view-public clean watch install check build-image push-image clean-runs

# Build both versions by default
build: build-both

# Build full version (with phone and address)
build-full:
	@echo "==> Compilation du CV complet (avec téléphone et adresse)..."
	@cd $(LATEX_DIR) && podman run $(PODMAN_OPTS)/$(LATEX_DIR) $(LATEX_IMAGE) pdflatex -interaction=nonstopmode cv-full.tex
	@cp $(LATEX_DIR)/cv-full.pdf $(OUTPUT_PDF_FULL)
	@echo "==> PDF généré: $(OUTPUT_PDF_FULL)"

# Build public version (without phone and address)
build-public:
	@echo "==> Compilation du CV public (sans téléphone ni adresse)..."
	@cd $(LATEX_DIR) && podman run $(PODMAN_OPTS)/$(LATEX_DIR) $(LATEX_IMAGE) pdflatex -interaction=nonstopmode cv-public.tex
	@cp $(LATEX_DIR)/cv-public.pdf $(OUTPUT_PDF_PUBLIC)
	@echo "==> PDF généré: $(OUTPUT_PDF_PUBLIC)"

# Build both versions
build-both: build-full build-public
	@echo "==> Les deux versions ont été générées:"
	@echo "    - $(OUTPUT_PDF_FULL) (version complète)"
	@echo "    - $(OUTPUT_PDF_PUBLIC) (version publique)"

view: view-full

view-full:
	evince $(LATEX_DIR)/$(OUTPUT_PDF_FULL) 2>/dev/null &

view-public:
	evince $(LATEX_DIR)/$(OUTPUT_PDF_PUBLIC) 2>/dev/null &

clean:
	@rm -f $(LATEX_DIR)/*.aux $(LATEX_DIR)/*.log $(LATEX_DIR)/*.out $(LATEX_DIR)/*.pdf $(LATEX_DIR)/*.bbl $(LATEX_DIR)/*.blg $(LATEX_DIR)/*.bcf $(LATEX_DIR)/*.run.xml $(LATEX_DIR)/*.fls $(LATEX_DIR)/*.fdb_latexmk $(LATEX_DIR)/*.synctex.gz $(LATEX_DIR)/*.toc $(LATEX_DIR)/*.lof $(LATEX_DIR)/*.lot $(LATEX_DIR)/*.nav $(LATEX_DIR)/*.snm $(LATEX_DIR)/*.vrb
	@rm -f $(OUTPUT_PDF_FULL) $(OUTPUT_PDF_PUBLIC)
	@echo "==> Nettoyage terminé"

watch:
	@cd $(LATEX_DIR) && podman run -it $(PODMAN_OPTS)/$(LATEX_DIR) $(LATEX_IMAGE) \
		latexmk -pdf -pvc -interaction=nonstopmode cv-full.tex

install:
	@echo "==> Vérification et installation des dépendances..."
	@command -v podman >/dev/null 2>&1 || { echo "Installing podman..."; sudo apt-get update && sudo apt-get install -y podman; }
	@command -v chktex >/dev/null 2>&1 || { echo "Installing chktex..."; sudo apt-get update && sudo apt-get install -y chktex; }
	@command -v evince >/dev/null 2>&1 || { echo "Installing evince..."; sudo apt-get update && sudo apt-get install -y evince; }
	@echo "==> Toutes les dépendances sont installées"
	@echo "==> Récupération de l'image LaTeX depuis GHCR..."
	podman pull $(LATEX_IMAGE)

build-image:
	@echo "==> Build de l'image Docker Alpine minimale..."
	podman build -t cv-latex:minimal docker/
	@echo "==> Tagging de l'image pour GHCR..."
	podman tag cv-latex:minimal $(LATEX_IMAGE)
	@echo "==> Image buildée avec succès: cv-latex:minimal"
	@podman images cv-latex:minimal --format "Taille: {{.Size}}"

push-image: build-image
	@echo "==> Push de l'image vers GitHub Container Registry..."
	@echo "Vous devez être connecté à GHCR (podman login ghcr.io)"
	@echo ""
	podman push $(LATEX_IMAGE)
	@echo ""
	@echo "==> Image poussée avec succès !"
	@echo "Image disponible: $(LATEX_IMAGE)"
	@echo ""
	@echo "Pour rendre l'image publique:"
	@echo "  1. Allez sur https://github.com/a-belhadj?tab=packages"
	@echo "  2. Cliquez sur 'cv-latex' -> Package settings"
	@echo "  3. Change visibility to Public"

check:
	@echo "==> Vérification LaTeX avec chktex..."
	@podman run $(PODMAN_OPTS)/$(LATEX_DIR) $(LATEX_IMAGE) chktex cv-full.tex
	@podman run $(PODMAN_OPTS)/$(LATEX_DIR) $(LATEX_IMAGE) chktex cv-public.tex

clean-runs:
	@gh run list --repo a-belhadj/cv --limit 100 --json databaseId -q '.[1:][].databaseId' | xargs -I {} gh api -X DELETE repos/a-belhadj/cv/actions/runs/{} --silent
	@gh api repos/a-belhadj/cv/deployments -q '.[1:][].id' | xargs -I {} gh api -X DELETE repos/a-belhadj/cv/deployments/{} --silent 2>/dev/null || true
