# CV - Anthony Belhadj

[![Lint CV](https://github.com/a-belhadj/cv/workflows/Lint%20CV/badge.svg)](https://github.com/a-belhadj/cv/actions)
[![Build and Deploy CV](https://github.com/a-belhadj/cv/workflows/Build%20and%20Deploy%20CV/badge.svg)](https://github.com/a-belhadj/cv/actions)

CV professionnel en LaTeX avec le template [AltaCV](https://github.com/liantze/AltaCV).

**📄 Voir le CV**: [https://a-belhadj.github.io/cv/](https://a-belhadj.github.io/cv/)

## Démarrage rapide

```bash
# Installer les dépendances
make install

# Compiler les deux versions du CV
make build

# Voir le CV
make view
```

## Structure du projet

```
cv/
├── latex/
│   ├── cv-full.tex           # CV avec coordonnées complètes
│   ├── cv-public.tex         # CV sans téléphone ni adresse
│   └── sections/
│       ├── personal-info-full.tex    # Infos complètes (ignoré par Git)
│       ├── personal-info-public.tex  # Infos publiques
│       ├── summary.tex
│       ├── experience.tex
│       ├── education.tex
│       └── ...
└── Makefile
```

## Versions du CV

- **cv-full.pdf** : Version avec téléphone et adresse (non versionné dans Git)
- **cv-public.pdf** : Version sans informations sensibles (non versionné dans Git)

Le fichier `latex/sections/personal-info-full.tex` contient vos données personnelles et est ignoré par Git pour des raisons de confidentialité.

## CI/CD et Déploiement

Le projet utilise GitHub Actions pour automatiser le linting, la compilation et le déploiement.

### Workflow de Lint
- **Déclenchement** : À chaque push sur `main` ou pull request
- **Conteneur** : `ghcr.io/a-belhadj/cv-latex:latest` (image Alpine minimale custom)
- **Action** : Vérifie la syntaxe LaTeX avec `chktex`

### Workflow de Build et Déploiement
- **Déclenchement** : Après succès du workflow de lint sur `main`
- **Conteneur** : `ghcr.io/a-belhadj/cv-latex:latest` (image Alpine minimale custom)
- **Actions** :
  1. Compile `cv-public.tex` en PDF avec pdfLaTeX
  2. Déploie le PDF sur GitHub Pages
  3. Accessible sur : [https://a-belhadj.github.io/cv/](https://a-belhadj.github.io/cv/)

### Architecture des Workflows
Les workflows utilisent une image Docker Alpine custom (539 MB) hébergée sur GitHub Container Registry :
- **Image** : `ghcr.io/a-belhadj/cv-latex:latest`
- **Base** : Alpine Linux 3.23 + TeX Live 2025 minimal
- **Packages** : 30 packages LaTeX installés (uniquement ce qui est nécessaire)
- **Outils inclus** : pdflatex, latexmk, chktex, GNU tar
- **Optimisation** : 90% plus légère que l'image TeX Live officielle (5.5 GB)
- **Build** : Multi-stage Dockerfile avec un seul layer pour tous les packages
- **Source** : [Dockerfile](./Dockerfile) disponible dans le repo

## Prérequis

- **Podman** (ou Docker)
- **chktex** (optionnel, pour le linting local)
- **evince** (optionnel, pour visualiser le PDF)

Aucune installation LaTeX locale nécessaire, tout se fait via conteneur Docker.

## Image Docker Custom

Le projet utilise une image Docker Alpine minimale et optimisée disponible sur GHCR.

### Utilisation

```bash
# Pull l'image depuis GHCR
podman pull ghcr.io/a-belhadj/cv-latex:latest

# Ou build localement
make build-image

# Push sur GHCR (nécessite authentication)
make push-image
```

**Contenu de l'image :**
- Alpine Linux 3.23 (~7 MB base)
- TeX Live 2025 minimal avec 30 packages LaTeX
- pdflatex, latexmk, chktex
- GNU tar (pour compatibilité GitHub Actions)
- **Taille totale** : 539 MB (vs 5.5 GB pour texlive/texlive:latest)

**Documentation complète** : Voir [docker/README.md](docker/README.md) pour plus de détails sur l'image, les packages inclus, et la maintenance.
