# Metadata Directory

This directory contains all **metadata** and **manifest** files used to describe the samples and locate sequencing data for this project.  
It is organized into two subdirectories: **16s/** for 16S rRNA amplicon sequencing and **shotgun/** for shotgun metagenomic sequencing.

---
## 📂 Structure

```
metadata/
├── 16s/               → Metadata and manifests for 16S rRNA sequencing
│   ├── 16s_metadata.tsv
│   ├── manifest_16S_raw.tsv
│   ├── manifest_16S_trimmed.tsv
│   └── README.md
├── shotgun/           → Metadata and manifests for shotgun metagenomic sequencing
│   ├── shotgun_metadata.tsv
│   ├── manifest_shotgun_raw.tsv
│   ├── manifest_shotgun_trimmed.tsv
│   ├── manifest_shotgun_host_filtered.tsv
│   └── README.md
└── README.md          → This file
```

---

## 🧾 File Types

### **Metadata Files**
- Contain descriptive sample information (e.g., starter identity, sample type, sugar content, ginger/inulin presence).
- Used for grouping, statistical testing, and visualization in downstream analyses.

### **Manifest Files**
- Map sample IDs to sequencing file paths for import into bioinformatics tools like **QIIME2**.
- Provided separately for:
  - **Raw data**  
  - **Trimmed data** (post-quality control)  
  - **Host-filtered data** (shotgun only)  
- All manifests are in **tab-delimited (.tsv)** format.

---

## 🛠 Usage Instructions
1. Ensure that file paths in manifests match your local or server data storage.
2. If publishing this repository:
   - Replace any local file paths with **public URLs** (e.g., NCBI SRA, Zenodo, or OneDrive links).
   - Remove any private or sensitive data.
3. Use matching metadata and manifest files for each dataset type:
   - **16s/** for amplicon sequencing analyses.
   - **shotgun/** for shotgun metagenomics.

---

## 🔔 Reproducibility Notes
- File paths in manifests are **relative** to the project root to maintain portability.
- Metadata format is compatible with standard bioinformatics workflows.
- Sample IDs in metadata must **exactly match** the sample IDs in manifests.

