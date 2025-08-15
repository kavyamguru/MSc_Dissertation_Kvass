# 16S rRNA Amplicon Sequencing — QIIME2 GTDB-R226 Workflow

This directory contains all scripts, documentation, and environment requirements for processing **16S rRNA amplicon sequencing data** using **QIIME2** with the **GTDB Release 226** taxonomy classifier.

---

## 📜 Files in this Directory

### `qiime2_16s_gtdb_r226_pipeline.sh`
Main shell script to run the complete 16S amplicon processing workflow.

**Steps include:**
1. Import raw paired-end reads using QIIME2.
2. Trim primers (V3–V4 region) with Cutadapt.
3. Denoise reads using DADA2 to obtain ASVs.
4. Assign taxonomy using GTDB R226 Naive Bayes classifier.
5. Generate taxa barplots for visualization.
6. Export results for downstream analysis.
7. Collapse ASV table to genus and phylum levels.
8. Build a phylogenetic tree with MAFFT + FastTree.
9. Perform alpha rarefaction analysis.

---

### `qiime2_16s_core_metrics.sh`
Runs **QIIME2 core diversity metrics** (alpha and beta diversity) using the phylogenetic tree and ASV table from the main pipeline.

---

### `qiime2_16s_coremetrics_permanova.sh`
Runs **PERMANOVA** on multiple metadata columns and distance metrics to assess statistical significance of beta diversity differences.

---

### `requirements_environment.md`
Lists the **software tools**, **versions**, and **conda environment** required to run the pipeline.  
Includes:
- QIIME2 version
- Cutadapt
- BIOM-format
- QIIME2 plugin list

---

## 📂 Input Files (relative to project root)
- `metadata/16s/manifest_16S_raw.tsv` → Manifest mapping sample IDs to raw FASTQ files.
- `metadata/16s/16s_metadata.tsv` → Sample metadata including experimental variables.
- `data/reference/gtdb/gtdb-r226-16S-nb-classifier.qza` → GTDB Release 226 Naive Bayes classifier.

---

## 📂 Output Structure

The pipeline generates results under `results/16s/qiime2_gtdb/`:

<pre> ``` results/ └── 16s/ └── qiime2_gtdb/ ├── demux.qza / demux-summary.qzv ├── trimmed.qza / trimmed-summary.qzv ├── table.qza / table-summary.qzv ├── taxonomy.qza / taxonomy.qzv ├── table_genus.qza / table_phylum.qza ├── phylo_tree/ ├── alpha_rarefaction.qzv ├── exports/ └── core_metrics/ ├── alpha_diversity_results ├── beta_diversity_results └── permanova_* ``` </pre>


---

## 🛠 Requirements

### **Software**
- QIIME2 (tested on 2024.2)
- cutadapt
- biom-format

### **Environment Setup**
```bash
# Create environment
conda env create -n qiime2-2024.2 python=3.8

# Activate environment
conda activate qiime2-2024.2

# Install QIIME2 (Linux example)
wget https://data.qiime2.org/distro/core/qiime2-2024.2-py38-linux-conda.yml
conda env create -n qiime2-2024.2 --file qiime2-2024.2-py38-linux-conda.yml

# Install additional tools if needed
conda install -c bioconda cutadapt biom-format

