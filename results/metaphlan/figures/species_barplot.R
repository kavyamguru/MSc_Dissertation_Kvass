# 📍 Set working directory
setwd("~/B269797/results/metaphlan/figures")

# 📦 Load libraries
library(tidyverse)
library(reshape2)

# 📂 Define input/output
input_file <- "../tables/species_table_metaphlan_0.2.tsv"
output_file <- "figure4_species_barplot_metaphlan_cleaned.png"

# 📥 Load table
species_df <- read.delim(input_file, row.names = 1, check.names = FALSE)

# 🧼 Filter species-level taxa
species_only <- species_df[grepl("s__", rownames(species_df)) & !grepl("\\|t__", rownames(species_df)), ]

# 📋 Rename columns
species_only <- species_only[, c("AA", "B1", "D1", "E1", "F1", "C1")]
colnames(species_only) <- c("SDX", "SDY", "STDkvassX", "LSFkvassX", "LSFkvassY", "LSGFkvassX")

# 📊 Convert to % relative abundance
species_pct <- apply(species_only, 2, function(x) 100 * x / sum(x))

# 🔁 Reshape for ggplot
df_long <- melt(species_pct)
colnames(df_long) <- c("Species", "Sample", "Abundance")

# 🧼 Clean species names (remove s__)
df_long$Species <- gsub("s__", "", df_long$Species)

# 📏 Order samples
df_long$Sample <- factor(df_long$Sample, levels = c("SDX", "SDY", "STDkvassX", "LSFkvassX", "LSFkvassY", "LSGFkvassX"))

# 🎨 Matching color palette (same order, s__ removed)
color_palette <- c(
  "Levilactobacillus_brevis"        = "#a6cee3",
  "Lactiplantibacillus_plantarum"   = "#1f78b4",
  "Saccharomyces_cerevisiae"        = "#b2df8a",
  "Acetobacter_tropicalis"          = "#33a02c",
  "Pantoea_agglomerans"             = "#fb9a99",
  "Loigolactobacillus_coryniformis" = "#e31a1c",
  "Pseudomonas_coleopterorum"       = "#fdbf6f",
  "Sphingomonas_aerolata"           = "#ff7f00",
  "Frigoribacterium_sp_CFBP_8751"   = "#cab2d6",
  "Pantoea_ananatis"                = "#6a3d9a",
  "Pseudomonas_graminis"            = "#ffff99",
  "Frigoribacterium_sp_PhB160"      = "#b15928",
  "Frigoribacterium_sp_CFBP_13729"  = "#8dd3c7"
)

# 🖼️ Plot barplot
p <- ggplot(df_long, aes(x = Sample, y = Abundance, fill = Species)) +
  geom_bar(stat = "identity", width = 0.8) +
  scale_fill_manual(values = color_palette) +
  labs(
    title = "All Samples: Species-Level Relative Abundance (MetaPhlAn4, stat_q = 0.2)",
    x = "Sample",
    y = "Relative Abundance (%)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

# 💾 Save plot
ggsave(output_file, plot = p, width = 10, height = 7, dpi = 300)

