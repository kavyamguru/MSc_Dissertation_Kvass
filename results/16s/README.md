# 📊 QIIME2 GTDB-R226 16S Amplicon Analysis Results

This directory contains the outputs of the **QIIME2** 16S rRNA amplicon sequencing pipeline, processed using the **GTDB Release 226** taxonomy classifier.

---

## 📂 Directory Structure

```text
qiime2_gtdb/
├── alpha_rarefaction.qzv
├── core_metrics/
│   ├── bray_curtis_distance_matrix.qza
│   ├── bray_curtis_emperor.qzv
│   ├── bray_curtis_pcoa_results.qza
│   ├── evenness_vector.qza
│   ├── faith_pd_vector.qza
│   ├── jaccard_distance_matrix.qza
│   ├── jaccard_emperor.qzv
│   ├── jaccard_pcoa_results.qza
│   ├── observed_features_vector.qza
│   ├── permanova_Ginger/
│   │   ├── bray_curtis_permanova.qzv
│   │   ├── jaccard_permanova.qzv
│   │   ├── unweighted_unifrac_permanova.qzv
│   │   └── weighted_unifrac_permanova.qzv
│   ├── permanova_Inulin/
│   │   ├── bray_curtis_permanova.qzv
│   │   ├── jaccard_permanova.qzv
│   │   ├── unweighted_unifrac_permanova.qzv
│   │   └── weighted_unifrac_permanova.qzv
│   ├── permanova_Sample_Type/
│   │   ├── bray_curtis_permanova.qzv
│   │   ├── jaccard_permanova.qzv
│   │   ├── unweighted_unifrac_permanova.qzv
│   │   └── weighted_unifrac_permanova.qzv
│   ├── permanova_Starter_Identity/
│   │   ├── bray_curtis_permanova.qzv
│   │   ├── jaccard_permanova.qzv
│   │   ├── unweighted_unifrac_permanova.qzv
│   │   └── weighted_unifrac_permanova.qzv
│   ├── permanova_Sugar_Content/
│   │   ├── bray_curtis_permanova.qzv
│   │   ├── jaccard_permanova.qzv
│   │   ├── unweighted_unifrac_permanova.qzv
│   │   └── weighted_unifrac_permanova.qzv
│   ├── rarefied_table.qza
│   ├── shannon_vector.qza
│   ├── unweighted_unifrac_distance_matrix.qza
│   ├── unweighted_unifrac_emperor.qzv
│   ├── unweighted_unifrac_pcoa_results.qza
│   ├── weighted_unifrac_distance_matrix.qza
│   ├── weighted_unifrac_emperor.qzv
│   └── weighted_unifrac_pcoa_results.qza
├── dada2-stats.qza
├── dada2-stats.qzv
├── demux.qza
├── demux-summary.qzv
├── exported_table_genus/
│   ├── feature-table.biom
│   └── feature-table.tsv
├── exports/
│   ├── dna-sequences.fasta
│   ├── feature-table.biom
│   ├── feature-table.tsv
│   ├── genus_table/
│   │   ├── feature-table.biom
│   │   └── genus_table.tsv
│   └── taxonomy.tsv
├── phylo_tree/
│   ├── aligned-rep-seqs.qza
│   ├── aligned-rep-seqs.qzv
│   ├── exported_tree/
│   │   └── tree.nwk
│   ├── masked-aligned-rep-seqs.qza
│   ├── rooted-tree.qza
│   └── unrooted-tree.qza
├── rep-seqs.qza
├── table_genus.qza
├── table_genus.qzv
├── table_phylum.qza
├── table_phylum.qzv
├── table.qza
├── table-summary.qzv
├── taxa-barplot.qzv
├── taxonomy.qza
├── taxonomy.qzv
├── trimmed.qza
└── trimmed-summary.qzv

---

## 🗂 Contents Summary

### **1. Quality Control**
- **`demux-summary.qzv`** — Interactive quality score plots.
- **`trimmed-summary.qzv`** — Post-primer trimming quality plots.
- **`dada2-stats.qzv`** — DADA2 denoising stats.

### **2. Taxonomic Profiles**
- **`taxonomy.qzv`** — Taxonomic assignments at multiple levels.
- **`taxa-barplot.qzv`** — Interactive genus/species composition visualization.
- **`table_genus.qzv`**, **`table_phylum.qzv`** — Collapsed abundance tables.

### **3. Diversity Analyses**
- **`core_metrics/`** — Includes:
  - Alpha diversity results (Shannon, Faith PD, Evenness, Observed Features).
  - Beta diversity distance matrices and PCoA plots (Bray-Curtis, Jaccard, Weighted & Unweighted UniFrac).
  - PERMANOVA statistical tests grouped by metadata variables.

### **4. Phylogenetics**
- **`phylo_tree/`** — Alignment and rooted/unrooted phylogenetic trees.
- **`exported_tree/tree.nwk`** — Tree in Newick format for external tools.

### **5. Exported Data**
- **`exports/`** — Ready-to-use TSV/FASTA/BIOM files for analysis outside QIIME2.
- **`exported_table_genus/`** — Genus-level table in TSV/BIOM formats.

---

## 📌 Notes
- All `.qza` and `.qzv` files can be viewed using [QIIME2 View](https://view.qiime2.org/).
- PERMANOVA results test whether community composition differs significantly between groups.
- Sampling depth for diversity analyses was set to match the lowest sequencing depth without excluding samples.

---

