# 📄 Shotgun Metadata & Manifests

This directory contains metadata and manifest files for **shotgun metagenomic sequencing** data used in the project.

---

## 📂 Files

### **Metadata**
- `shotgun_metadata.tsv` → Contains sample information such as:
  - Starter identity (X or Y)
  - Sample type (starter or kvass)
  - Formulation name
  - Inulin presence (yes/no)
  - Ginger presence (yes/no)
  - Sugar content (none / low / standard)
- Used for grouping samples, statistical analyses, and visualizations in downstream tools.

### **Manifests**
- `manifest_shotgun_raw.tsv` → Links raw paired-end FASTQ files to sample IDs (direct from sequencing provider).
- `manifest_shotgun_trimmed.tsv` → Links quality-trimmed paired-end FASTQ files to sample IDs (processed via Fastp).
- `manifest_shotgun_host_filtered.tsv` → Links host-filtered paired-end FASTQ files to sample IDs (processed via Bowtie2).

---

## 🛠 Usage
- These files are used for importing data into analysis workflows such as MetaPhlAn, Kraken2/Bracken, Kaiju, and HUMAnN:
  ```bash
  humann --input manifest_shotgun_host_filtered.tsv --output humann_results/
  ```
- Ensure **sample IDs** in manifests exactly match those in `shotgun_metadata.tsv`.

---

## 🔔 Notes
- File paths in manifests are **relative** to the project directory for portability.
- Replace any private/local file paths with public links (e.g., NCBI SRA, Zenodo, OneDrive) before making the repository public.
- Metadata format is compatible with standard shotgun metagenomics analysis pipelines.

