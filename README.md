# MSc_Dissertation_Kvass

Integrated **16S rRNA + shotgun metagenomics** analysis of sourdough-based kvass fermentation.
This project evaluates how dietary fibre supplementation impacts microbial composition and functional potential using reproducible workflows.

## Project Highlights
- Multi-layer microbiome profiling (taxonomic + functional)
- Cross-tool comparison (QIIME2, MetaPhlAn4, Kraken2/Bracken, Kaiju)
- Functional interpretation (HUMAnN3, DRAM2)
- Reproducible folder structure from metadata to publication-ready figures

## Repository Structure
- `code/` — pipeline and analysis scripts
- `metadata/` — manifests and sample annotations
- `raw_data_links/` — references to raw/processed inputs
- `results/` — processed outputs, figures, and summary tables

## Workflow Overview
1. **16S processing (QIIME2):** import → denoise → taxonomy → alpha/beta diversity
2. **Shotgun taxonomy:** MetaPhlAn4, Kraken2/Bracken, Kaiju
3. **Functional profiling:** HUMAnN3 and DRAM2
4. **Visualization/reporting:** R scripts for heatmaps, pathway summaries, and differential interpretation

## Software Stack
- QIIME2 2024.2
- MetaPhlAn4, Kraken2, Bracken, Kaiju
- HUMAnN3, DRAM2
- R 4.3+ (ggplot2, pheatmap, vegan, etc.)
- Python 3.8+

## Reproducibility Notes
- Tool-specific scripts are organized under each `code/*/` directory.
- Input manifests are versioned under `metadata/`.
- Generated outputs are stored in structured subfolders under `results/`.
- This repository is intended as a traceable dissertation workflow archive.

## Key Output Areas
- Diversity and composition trends across conditions
- Taxonomic agreement/disagreement across profilers
- Pathway and gene-family shifts associated with fibre treatment

## Contact
For collaboration or role-related discussion, connect via GitHub profile: https://github.com/kavyamguru
