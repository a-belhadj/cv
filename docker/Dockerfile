FROM alpine:3.23 AS texlive-installer

# Install tools needed for installation
RUN apk add --no-cache \
    perl \
    wget \
    xz \
    tar

# Download and install TeX Live minimal
RUN wget -qO- "https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz" | tar -xz -C /tmp \
    && cd /tmp/install-tl-* \
    && printf "selected_scheme scheme-minimal\ninstopt_adjustrepo 0\n" > profile.txt \
    && ./install-tl --profile=profile.txt \
    && rm -rf /tmp/install-tl-*

# Install all LaTeX packages in a single layer
RUN /usr/local/texlive/2025/bin/x86_64-linuxmusl/tlmgr install \
    latex-bin \
    latex \
    extsizes \
    geometry \
    etoolbox \
    xcolor \
    pdfx \
    hyperref \
    xmpincl \
    everyshi \
    accsupp \
    cmap \
    epstopdf-pkg \
    l3packages \
    pgf \
    tcolorbox \
    tikzfill \
    adjustbox \
    trimspaces \
    enumitem \
    multirow \
    changepage \
    paracol \
    dashrule \
    ifmtarg \
    fontawesome5 \
    roboto \
    fontaxes \
    lato \
    latexmk \
    chktex \
    xstring \
    catchfile

# Final stage
FROM alpine:3.23

# OCI Labels
LABEL org.opencontainers.image.title="cv-latex"
LABEL org.opencontainers.image.description="Minimal Alpine LaTeX image for AltaCV template"
LABEL org.opencontainers.image.authors="Anthony Belhadj <https://github.com/a-belhadj>"
LABEL org.opencontainers.image.source="https://github.com/a-belhadj/cv"
LABEL org.opencontainers.image.url="https://github.com/a-belhadj/cv"
LABEL org.opencontainers.image.documentation="https://github.com/a-belhadj/cv/blob/main/docker/README.md"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="a-belhadj"
LABEL org.opencontainers.image.base.name="alpine:3.23"

# Install runtime dependencies
RUN apk add --no-cache \
    perl \
    fontconfig \
    tar

# Copy TeX Live from installer stage
COPY --from=texlive-installer /usr/local/texlive /usr/local/texlive

# Set PATH
ENV PATH="/usr/local/texlive/2025/bin/x86_64-linuxmusl:$PATH"

WORKDIR /workspace

CMD ["pdflatex", "--version"]
