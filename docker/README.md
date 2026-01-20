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


### Pousser sur GitHub Container Registry

```bash
# Login (première fois)
podman login ghcr.io -u a-belhadj

# Push
make push-image
```

## Liens

- **Source** : [Dockerfile](./Dockerfile)
- **Registry** : [ghcr.io/a-belhadj/cv-latex](https://github.com/users/a-belhadj/packages/container/package/cv-latex)
- **Documentation projet** : [README principal](../README.md)
