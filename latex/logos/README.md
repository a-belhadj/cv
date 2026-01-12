# Company Logos

This directory contains company logos to be displayed next to work experience entries in the CV.

## Requirements

- **Format**: PNG or JPG (PNG with transparent background recommended)
- **Size**: Square format recommended (e.g., 200x200px, 300x300px, 500x500px)
- **File naming**: Use lowercase with company abbreviation (e.g., `hpe.png`, `google.png`)

## Current Logos Needed

- `hpe.png` - Hewlett Packard Enterprise logo

## How to Add a Logo

1. Download the company logo (preferably from the company's official press kit or brand guidelines)
2. Resize it to a square format if needed
3. Save it in this directory with an appropriate name
4. The logo will automatically be displayed in the CV

## Usage in cv.tex

The logos are used with the `\cveventlogo` command:

```latex
\cveventlogo{Job Title}{Company Name}{Dates}{Location}{logos/company.png}
```

Example:
```latex
\cveventlogo{Platform Engineer}{Hewlett Packard Enterprise}{Sep 2022 -- Present}{Grenoble, FR}{logos/hpe.png}
```

## Tips

- For best results, use logos with transparent backgrounds (PNG format)
- Logos will be automatically resized to fit the layout
- If you don't want a logo for a specific position, use the standard `\cvevent` command instead
