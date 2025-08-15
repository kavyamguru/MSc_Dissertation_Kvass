# Set working directory to where you want to save the figure
setwd("~/B269797/results/metaphlan/figures")

# 📦 Load libraries
library(tidyverse)
library(pheatmap)
library(RColorBrewer)

# 📥 Input file path
input_file <- "../tables/species_table_metaphlan_0.2.tsv"
output_file <- "figure5_species_heatmap_metaphlan.png"

# 📊 Read data
df <- read.delim(input_file, row.names = 1, check.names = FALSE)

# 🎯 Filter to species-level (s__ but not t__)
species_df <- df[grepl("s__", rownames(df)) & !grepl("\\|t__", rownames(df)), ]

# 🔠 Clean species names
rownames(species_df) <- gsub(".*s__", "", rownames(species_df))

# 🔁 Reorder samples for consistent display
species_df <- species_df[, c("AA", "B1", "D1", "E1", "F1", "C1")]
colnames(species_df) <- c("SDX", "SDY", "STDkvassX", "LSFkvassX", "LSFkvassY", "LSGFkvassX")

# 🔢 Log10 transform (add pseudocount to avoid log10(0))
log_species <- log10(species_df + 1e-3)

# 🎨 Define color palette
heat_colors <- colorRampPalette(brewer.pal(9, "YlGnBu"))(100)

# 🖼️ Plot heatmap
pheatmap(log_species,
         color = heat_colors,
         cluster_rows = TRUE,
         cluster_cols = FALSE,
         fontsize_row = 10,
         fontsize_col = 11,
         main = "Species-Level Composition (MetaPhlAn)",
         filename = output_file,
         width = 6,
         height = 6)

