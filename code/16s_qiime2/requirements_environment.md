# 🛠 Environment & Tool Requirements for QIIME2 GTDB 16S Workflow

This document lists the required tools, versions, and dependencies to reproduce the `qiime_16s_gtdb.sh` workflow.

---

## 📦 Core Environment

- **Operating System:** Linux (tested on Ubuntu 20.04 LTS)
- **Package Manager:** Conda (Miniconda or Anaconda)
- **Shell:** bash

---

## 🔹 Main Software

| Tool / Plugin                       | Purpose                                           | Version Tested |
|--------------------------------------|---------------------------------------------------|----------------|
| **QIIME 2**                          | Core microbiome bioinformatics platform           | 2024.2         |
| **cutadapt**                         | Trim primers/adapters from sequences               | 4.4            |
| **biom-format** (`biom`)             | Convert BIOM tables to TSV                        | 2.1.12         |

---

## 🔹 QIIME 2 Plugins Used

These plugins are bundled with QIIME2 but must match the QIIME2 version used:

| Plugin                      | Purpose                                         |
|-----------------------------|-------------------------------------------------|
| `qiime tools`               | Core QIIME2 file handling                       |
| `qiime demux`               | Summarize demultiplexed sequences               |
| `qiime cutadapt`            | Primer trimming                                 |
| `qiime dada2`               | Denoising & chimera removal                     |
| `qiime feature-classifier`  | Assign taxonomy (Naive Bayes classifier)        |
| `qiime taxa`                | Taxonomic visualization and collapsing          |
| `qiime phylogeny`           | Tree building                                   |
| `qiime diversity`           | Alpha diversity analysis                        |
| `qiime metadata`            | Metadata formatting & visualization             |

---

## 📥 Reference Data

- **GTDB-R226 16S Naive Bayes Classifier**
  - File: `gtdb-r226-16S-nb-classifier.qza`
  - Location in repo: `data/reference/gtdb/`
  - Source: Generated from GTDB release R226 aligned 16S sequences or downloaded from a trusted public source.

---

## 🔧 Environment Setup

```bash
# Create environment
conda create -n qiime2-2024.2 python=3.8

# Activate environment
conda activate qiime2-2024.2

# Install QIIME2 (Linux example)
wget https://data.qiime2.org/distro/core/qiime2-2024.2-py38-linux-conda.yml
conda env create -n qiime2-2024.2 --file qiime2-2024.2-py38-linux-conda.yml

# Activate QIIME2
conda activate qiime2-2024.2

# Install additional tools if not bundled
conda install -c bioconda cutadapt biom-format

