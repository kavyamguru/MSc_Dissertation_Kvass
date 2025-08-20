# 16S rRNA Amplicon Sequencing — QIIME2 GTDB-R226 (V3–V4 Workflow)

This directory contains scripts and documentation for processing **16S rRNA amplicon sequencing data** using **QIIME2** with the **GTDB Release 226 taxonomy classifier**.  
The workflow follows the B269797 project structure and produces outputs in `results/16s/`.

---

## 📜 Scripts in this Directory

### `run_qiime_v3v4.sh`
End-to-end QIIME2 pipeline for V3–V4 paired-end 16S reads.  
**Main steps:**
1. Import raw reads (manifest).
2. Trim primers with Cutadapt.
3. Denoise reads with DADA2 (pseudo-pooling).
4. Train GTDB RS226 V3–V4 classifier (if not cached).
5. Classify features (confidence = 0.2).
6. Generate taxa barplots.
7. Export feature table, taxonomy, representative sequences.
8. Collapse to **genus (L6)** and **phylum (L2)**.
9. Build phylogenetic tree with MAFFT + FastTree.

Outputs → `results/16s/qiime_v3v4_final/`

---

### `qiime2_16s_core_metrics.sh`
Runs **QIIME2 core diversity metrics** on the ASV table + tree.  
- Alpha diversity: Shannon, Observed Features, Faith’s PD, Evenness  
- Beta diversity: weighted/unweighted UniFrac, Bray–Curtis, Jaccard  

Sampling depth: **49,000**  
Results → `results/16s/qiime2_gtdb/core_metrics/`

---

### `qiime2_16s_coremetrics_permanova.sh`
Runs **PERMANOVA** for beta diversity significance across metadata categories.  

- Metadata columns:  
  `Starter_Identity`, `Sample_Type`, `Inulin`, `Ginger`, `Sugar_Content`  
- Distance metrics:  
  `weighted_unifrac`, `unweighted_unifrac`, `bray_curtis`, `jaccard`  

Results → `results/16s/qiime2_gtdb/core_metrics/permanova_<metadata_column>/`

---

### `genus_heatmap_barplot.R`
R script for **visualising genus-level compositions** using QIIME2 export tables.  

**Functions:**
- Cleans genus labels (`g__` prefixes, unassigned taxa).  
- Collapses duplicate genera.  
- Selects **top 15 genera** by mean abundance.  
- Creates:  
  - **Heatmap** (log10-transformed relative abundances, colour: `YlGnBu`)  
  - **Stacked barplot** (relative abundances %, custom genus colours, “Other” grouped)  

**Outputs:**  
- High-resolution **TIFF (600 dpi)**  
- PNG (600 dpi)  
- Vector PDF (publication-ready)  

Example outputs:  
`figure2_genus_heatmap_top15_600dpi.tiff`,  
`genus_barplot_top15_600dpi.tiff`,  
`genus_barplot_top15.pdf`

---

### `requirements_environment.md`
Lists software requirements and environment setup.  
- QIIME2 (tested on v2024.2)  
- Cutadapt (v4.4)  
- BIOM-format (v2.1.12)  

---

## 📂 Input Files (relative to project root)

- `metadata/16s/manifest_16S_all.tsv` → Manifest mapping sample IDs to FASTQ files.  
- `metadata/16s/16s_metadata.tsv` → Sample metadata (experimental variables).  
- `data/reference/gtdb/gtdb-r226-16S-seqs.qza` → GTDB reference sequences.  
- `data/reference/gtdb/gtdb-r226-16S-tax.qza` → GTDB taxonomy reference.  

---

## 📂 Output Structure

results/
└── 16s/
├── qiime_v3v4_final/
│ ├── demux.qza / demux.qzv
│ ├── trimmed.qza / trimmed.qzv
│ ├── table.qza / table.qzv
│ ├── taxonomy.qza / taxonomy.qzv
│ ├── taxa-barplot.qzv
│ ├── exports/
│ │ ├── feature-table.tsv
│ │ ├── taxonomy.tsv
│ │ └── rep-seqs.fasta
│ ├── collapsed/
│ │ ├── genus/table_genus.tsv
│ │ └── phylum/table_phylum.tsv
│ └── phylo_tree/rooted-tree.qza
└── qiime2_gtdb/
└── core_metrics/
├── alpha_diversity_results/
├── beta_diversity_results/
└── permanova_<metadata_column>/


---

## 🛠 Requirements

### **Software**
- QIIME2 (tested on 2024.2)  
- cutadapt (v4.4)  
- biom-format (v2.1.12)  
- R (≥ 4.0) with packages: `tidyverse`, `pheatmap`, `RColorBrewer`, `ggplot2`, `ragg`  

### **Environment Setup**
```bash
# Create environment
conda create -n qiime2-2024.2 python=3.8

# Activate environment
conda activate qiime2-2024.2

# Install QIIME2 (Linux example)
wget https://data.qiime2.org/distro/core/qiime2-2024.2-py38-linux-conda.yml
conda env create -n qiime2-2024.2 --file qiime2-2024.2-py38-linux-conda.yml

# Install additional tools if not bundled
conda install -c bioconda cutadapt biom-format

# R packages (inside R console or script)
install.packages(c("tidyverse", "pheatmap", "RColorBrewer", "ggplot2"))
install.packages("ragg")   # for high-res PNG/TIFF export

