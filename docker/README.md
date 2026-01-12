# Image Docker pour LaTeX

Image Docker légère basée sur Alpine Linux pour compiler des documents LaTeX.

## Pourquoi cette image ?

Compiler du LaTeX nécessite habituellement une installation de plusieurs gigaoctets. Cette image contient uniquement ce qui est nécessaire pour ce projet.

**Résultat :** 539 MB au lieu de 5.5 GB (90% plus léger).

## Ce qui est inclus

- **LaTeX** : pdflatex pour compiler les documents
- **Outils** : latexmk (compilation auto), chktex (vérification syntaxe)
- **Packages** : 30 packages LaTeX sélectionnés pour le template AltaCV
- **Base** : Alpine Linux 3.23 + TeX Live 2025

## Utilisation

### Récupérer l'image

```bash
podman pull ghcr.io/a-belhadj/cv-latex:latest
```

### Compiler un document

```bash
podman run --rm \
  -v $(pwd):/workspace:Z \
  -w /workspace \
  ghcr.io/a-belhadj/cv-latex:latest \
  pdflatex document.tex
```

### Dans GitHub Actions

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: ghcr.io/a-belhadj/cv-latex:latest
    steps:
      - uses: actions/checkout@v4
      - run: pdflatex document.tex
```

## Build de l'image

### Depuis la racine du projet

```bash
make build-image
```

### Pousser sur GitHub Container Registry

```bash
# Login (première fois)
podman login ghcr.io -u a-belhadj

# Push
make push-image
```

## Architecture

**Multi-stage build** pour optimiser la taille :

1. **Stage 1** : Télécharge et installe TeX Live + packages nécessaires
2. **Stage 2** : Copie uniquement TeX Live dans une image Alpine propre

Résultat : image finale sans les outils de build.

## Packages LaTeX

Liste des 30 packages installés :

```
latex-bin, latex, extsizes, geometry, etoolbox, xcolor,
pdfx, hyperref, xmpincl, everyshi, accsupp, cmap,
epstopdf-pkg, l3packages, pgf, tcolorbox, tikzfill,
adjustbox, trimspaces, enumitem, multirow, changepage,
paracol, dashrule, ifmtarg, fontawesome5, roboto,
fontaxes, lato, latexmk, chktex
```

Choix basé sur les besoins du template AltaCV utilisé dans ce projet.

## Maintenance

### Ajouter un package manquant

Si un package LaTeX manque lors de la compilation :

1. Ouvrir `docker/Dockerfile`
2. Ajouter le package à la liste dans la section `RUN tlmgr install`
3. Rebuild : `make build-image`
4. Push : `make push-image`

### Mettre à jour TeX Live

Modifier la version dans le Dockerfile si une nouvelle version de TeX Live sort.

## Comparaison

| Image | Taille | Usage |
|-------|--------|-------|
| texlive/texlive:latest | 5.5 GB | Installation complète |
| texlive/texlive:latest-small | 500 MB | Trop limité pour ce projet |
| **cv-latex:minimal** | **539 MB** | **Optimisé pour ce CV** |

## Liens

- **Source** : [Dockerfile](./Dockerfile)
- **Registry** : [ghcr.io/a-belhadj/cv-latex](https://github.com/a-belhadj/cv/pkgs/container/cv-latex)
- **Documentation projet** : [README principal](../README.md)
