# 📄 16S Metadata & Manifests

This directory contains metadata and manifest files for **16S rRNA amplicon sequencing** data used in the project.

---

## 📂 Files

### **Metadata**
- `16s_metadata.tsv` → Contains sample information such as:
  - Starter identity (X or Y)
  - Sample type (starter or kvass)
  - Inulin presence (yes/no)
  - Ginger presence (yes/no)
  - Sugar content (none / low / standard)
- Used for grouping samples, statistical analysis, and visualizations in QIIME2 and R.

### **Manifests**
- `manifest_16S_raw.tsv` → Links raw paired-end FASTQ files to sample IDs.
- `manifest_16S_trimmed.tsv` → Links quality-trimmed paired-end FASTQ files to sample IDs (post-Trimmomatic/QIIME2 processing).

---

## 🛠 Usage
- These files are used for importing data into **QIIME2**:
  ```bash
  qiime tools import \
    --type 'SampleData[PairedEndSequencesWithQuality]' \
    --input-path manifest_16S_raw.tsv \
    --output-path demux.qza \
    --input-format PairedEndFastqManifestPhred33V2
  ```
- Ensure that **sample IDs** in the manifest match exactly with those in `16s_metadata.tsv`.

---

## 🔔 Notes
- File paths in the manifests are **relative** to the project directory to maintain portability.
- Replace any private/local paths with public links before making the repository public.
- This metadata follows QIIME2 formatting requirements and can be adapted for other tools.
# Metadata for 16S data
