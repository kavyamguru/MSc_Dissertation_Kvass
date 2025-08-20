# Functional Profiling – DRAM v2 (Kvass Dissertation 2025)

This directory contains **DRAM v2 functional profiling results** for kvass samples, including CAZymes, PHAGC genes, curated pathways, and overlaps with HUMAnN3.

---

## 📂 Directory Overview

results/dram/
├── figures/ # Visualisations generated from DRAM outputs
├── tables/ # Processed and raw DRAM annotation tables
└── README.md # Master documentation


---

## 📊 Tables (`tables/`)

### Functional Outputs
- `cazyme_abundance_matrix.tsv` → CAZyme abundance table (all detected).  
- `cazyme_classification.tsv` → CAZyme family classifications.  
- `dram_filtered_pathway_filtered.csv` → Filtered DRAM pathway annotations.  
- `dram_humann_overlap.tsv` → Overlap between DRAM and HUMAnN annotations.  
- `final_curated_pathways.tsv` → Kvass/sourdough-relevant curated pathway panel.  
- `curated_pathway_matrix.tsv` → Abundance matrix for curated pathways only.  
- `curated_summarized_genomes_nonzero.tsv` → Curated genome-level summaries.  
- `summarised_genome_nonzero.tsv` → Genome summaries (non-curated).  

### PHAGC Genes
- `phagc_summary_hits_nonzero_v4.tsv` → Summary of PHAGC gene hits (nonzero).  
- `phagc_heatmap_KOids_ylgnbu_rowsZ_collapsed_input.tsv` → Input matrix for PHAGC heatmap.  

### Helper Scripts
- `heatmap_cazyme.py` → Script to generate CAZyme heatmaps.  

### Visualisation Exports
- `cazy_heatmap.png` → Default CAZyme heatmap.  
- `pathway_heatmap.png` → Pathway-level heatmap.  

---

## 📈 Figures (`figures/`)

- `cazy_heatmap_top50_rowsZ.tiff` → Top 50 CAZymes, row-normalised Z-score.  
- `Pathway_Panel_Zscore.tiff` → Curated pathway panel (Z-scored).  
- `phagc_heatmap_KOids_ylgnbu_rowsZ.tiff` → PHAGC gene heatmap (row-normalised, YlGnBu palette).  

---

## 📝 Notes

- DRAM v2.0.0 run via Nextflow, using custom database at `~/Kvass_project/dram_db`.  
- Reads were assembled with MEGAHIT, annotated with DRAM, and summarised at gene, pathway, and genome levels.  
- CAZyme (carbohydrate-active enzymes) and PHAGC (phage-associated genes) outputs highlight diet-related and viral/host interaction functions.  
- Curated kvass/sourdough pathway panel created for functional interpretation (aligned with HUMAnN3 results).  
- Figures are consistent with HUMAnN visualisation styles (e.g., YlGnBu palette, Z-score scaling).  

