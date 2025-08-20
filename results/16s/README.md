# 16S rRNA Sequencing Results (Kvass Dissertation 2025)

This directory contains the complete results of the **16S rRNA analysis** for the MSc dissertation project:  
*Metagenomic insights into sourdough-based kvass fermentation and dietary fibre addition*.  

All outputs are organised into logical sections: quality control, QIIME2 outputs, publication-ready figures, final tables, and archived runs.

---

## 📂 Directory Overview

results/16s/
├── archives/ # Archived/alternative GTDB-based runs
├── figures/ # Final plots for publication/dissertation
├── qc/ # Quality control reports (FastQC + MultiQC)
├── qiime2/ # Main QIIME2 pipeline outputs
├── tables/ # Final abundance and metadata tables
├── cleanup.sh # Helper script for organising results
└── README.md # This file (master documentation)


---

## 🧪 Quality Control (`qc/`)

### Raw reads (`qc/raw/`)
- `multiqc_report.html` → aggregated QC for untrimmed reads.
- `multiqc_data/` → text exports: adapter content, GC content, per-base quality, duplication, sequence counts.

### Trimmed reads (`qc/trimmed/`)
- `multiqc_report.html` → QC after trimming.
- `multiqc_data/` → same metrics post-trimming (improved quality, reduced adapters).

---

## 🔬 QIIME2 Outputs (`qiime2/`)

### 1. Demultiplexing (`qiime2/demux/`)
- `demux.qza`, `demux.qzv` → sequence quality visualisation.

### 2. Denoising with DADA2 (`qiime2/dada2/`)
- `dada2_stats.qza/.qzv` → read retention and error models.

### 3. Taxonomy (`qiime2/taxonomy/`)
- `taxonomy.qza/.qzv` → SILVA-based taxonomic assignments.

### 4. Diversity Analyses (`qiime2/diversity/`)
- `alpha/` → alpha diversity metrics.
- `beta/` → beta diversity metrics.
- `permanova/` → statistical testing for group differences  
  (Bray–Curtis, Jaccard, weighted & unweighted UniFrac).

### 5. Phylogenetic Tree (`qiime2/phylo_tree/`)
- `aligned-rep-seqs.qza`, `rooted-tree.qza`, `unrooted-tree.qza`.
- `exported_tree/tree.nwk` for downstream visualisation.

### 6. Exports (`qiime2/exports/`)
- `feature-table.biom`, `feature-table.tsv` → ASV counts.
- `genus/`, `phylum/` → collapsed feature tables at higher taxonomic levels.
- `taxonomy.tsv` → taxonomy assignments.
- `sequences/dna-sequences.fasta` → ASV sequences.

### 7. Trimmed summary (`qiime2/trimmed/`)
- `trimmed.qza/.qzv` → read length & quality post-trimming.

---

## 📊 Figures (`figures/`)

### Alpha Diversity (`figures/alpha_diversity/`)
- `alpha_diversity_by_Ginger.png`
- `alpha_diversity_by_Inulin.png`
- `alpha_diversity_by_Starter_Identity.png`
- `alpha_diversity_by_Sugar_Content.png`  
➡ Boxplots showing richness/evenness grouped by metadata categories.

### Beta Diversity (`figures/beta_diversity/`)
- `pcoa_bray_by_sample.{png,tiff}`
- `pcoa_jaccard_by_sample.{png,tiff}`
- `pcoa_unweighted_by_sample.{png,tiff}`
- `pcoa_weighted_by_sample.{png,tiff}`
- `ordination_unweighted.txt`  
➡ PCoA plots (Bray–Curtis, Jaccard, UniFrac) illustrating sample clustering.

### Taxonomy Barplots (`figures/taxonomy/`)
- `taxa-barplot.qzv` → interactive taxa barplot (QIIME2 viewer).

### Genus Barplot (`figures/barplots/`)
- `genus_barplot_top15_600dpi.tiff` → stacked barplot of top 15 genera.

### Heatmaps (`figures/heatmaps/`)
- `figure2_genus_heatmap_ordered.png` → genus-level heatmap (row-scaled).

---

## 📑 Tables (`tables/`)

### Genus-level (`tables/genus/`)
- `genus_counts.tsv`, `genus_counts_no_prefix.tsv` → raw counts.
- `genus_relabund.tsv`, `genus_relabund_percent.tsv` → relative abundances.
- `table_genus.tsv` → main collapsed genus table.

### Phylum-level (`tables/phylum/`)
- `table_phylum.tsv` → phylum-level abundances.

### Metadata (`tables/metadata/`)
- Sample metadata file used for grouping analyses.

---

## 🗄️ Archives (`archives/`)

### `archives/qiime2_gtdb/`
- Alternative taxonomic assignment with **GTDB r226 classifier**.
- Contains:
  - Classifier and extracted reference database.
  - Genus/Phylum collapsed tables.
  - Core metrics (alpha, beta diversity, distance matrices, ordinations).
  - Rep-seqs, rarefied tables, and PCoA scripts.
  - `genus_counts_no_prefix.tsv` (parallel to SILVA-based results).

This ensures reproducibility and comparison between **SILVA vs GTDB taxonomy**.

---

## 📝 Notes

- **Final figures** for dissertation are under `figures/`.  
- **Publication-ready tables** are under `tables/`.  
- QIIME2 `.qza/.qzv` files are preserved for reproducibility.  
- GTDB-based alternative analysis is archived under `archives/`.  
- `cleanup.sh` is a helper script to keep the structure tidy.

---

