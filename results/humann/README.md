# Functional Profiling – HUMAnN3 (Kvass Dissertation 2025)

This directory contains the **HUMAnN3 functional profiling results** for kvass samples. Outputs include gene families, KEGG orthologs (KOs), UniRef hits, pathways, and curated gene panels.

---

## 📂 Directory Overview

results/humann/
├── figures/ # Functional profiling visualisations
├── tables/ # Abundance tables, statistics, and exports
└── README.md # Master documentation


---

## 📊 Tables (`tables/`)

### Processed Outputs
- `gf_ko_cpm.tsv` → Normalised KEGG ortholog counts (CPM).  
- `gf_ko_cpm_log2fc.tsv` → Log2 fold-change values for KEGG orthologs.  
- `pathways_cpm_clean.tsv` → Cleaned CPM pathway abundance table.  
- `pathways_cpm_clean_log2fc.tsv` → Log2 fold-change of pathway abundances.  
- `uniref_cpm_clean.tsv` → Cleaned UniRef CPM table.  
- `final_curated_gene_list.tsv` → Custom curated panel of functional genes (kvass/sourdough relevant).  

### Raw Exports
- `raw/filled_merged_genefamilies.tsv`  
- `raw/filled_merged_pathabundance.tsv`  

### Statistical Hits (`output_hits/`)
- `ko_hits.tsv` / `ko_hits_log2FC.tsv` → KEGG ortholog differential results.  
- `pathway_hits.tsv` / `pathway_hits_log2FC.tsv` → Pathway-level differential results.  
- `curated_pathway_hits.tsv` → Subset for curated kvass/sourdough pathways.  
- `uniref_hits.tsv` → UniRef-based hits.  
- Multi-condition comparisons also available (`*_log2FC_multi.tsv`).  
- `log2_fold_change.py` → Script for log2FC calculations.

### QIIME2 Diversity Wrappers
- `qiime_alpha/` → Alpha diversity (`observed features`, `Shannon`) on gene families & pathways.  
- `qiime_beta/` → Beta diversity (Bray–Curtis, PCoA, Emperor) on gene families & pathways.  

---

## 📈 Figures (`figures/`)

- Placeholder for HUMAnN plots (barplots, heatmaps, PCoAs).  
- Scripts will be added alongside PNG/TIFF outputs.  

---

## 📝 Notes

- HUMAnN3 was run with **stat_q values 0.02 and 0.05** on host-filtered and yeast-filtered reads.  
- CPM-normalised outputs used for comparisons.  
- Log2 fold-change analysis performed with in-house Python scripts.  
- Curated gene panel created for kvass/sourdough-relevant functions (e.g., phosphoketolase).  
- QIIME2 wrappers enabled diversity metrics on functional tables for consistency with 16S/shotgun taxonomy.  

