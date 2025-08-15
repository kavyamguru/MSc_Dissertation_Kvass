# 📍 Set working directory
setwd("~/B269797/results/kraken_bracken/figures")

# 📦 Load required libraries
library(tidyverse)

# 📂 Input/output paths
input_file <- "../tables/species_table_bracken_0.2.tsv"  # Pre-filtered top 15 + Other
output_file <- "figure4_species_barplot_kraken.png"

# 📥 Load species table (species in rows, samples in columns)
species_df <- read.delim(input_file, row.names = 1, check.names = FALSE)

# 🧱 Convert to long format
df_long <- species_df %>%
  rownames_to_column(var = "Species") %>%
  pivot_longer(-Species, names_to = "Sample", values_to = "Abundance")

# 🧼 Replace spaces with underscores
df_long$Species <- gsub(" ", "_", df_long$Species)

# 🧼 Remove Homo_sapiens if it exists (optional safety check)
df_long <- df_long[!df_long$Species %in% c("Homo_sapiens"), ]

# 🧱 Reorder samples
sample_order <- c("AA", "B1", "D1", "E1", "F1", "C1")
sample_labels <- c("SDX", "SDY", "STDkvassX", "LSFkvassX", "LSFkvassY", "LSGFkvassX")
df_long$Sample <- factor(df_long$Sample, levels = sample_order, labels = sample_labels)

# 🎨 Custom color palette (same as Bracken for consistency)
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
  "Frigoribacterium_sp_CFBP_13729"  = "#8dd3c7",
  "Vibrio_anguillarum"              = "#ffffb3",
  "Weissella_paramesenteroides"     = "#b15928",
  "Other"                           = "#ff8c00"
)

# ✂️ Filter color palette to present species
present_species <- unique(df_long$Species)
plot_colors <- color_palette[names(color_palette) %in% present_species]

# 📊 Create barplot
p <- ggplot(df_long, aes(x = Sample, y = Abundance, fill = Species)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values = plot_colors) +
  labs(
    x = "",
    y = "Relative Abundance",
    fill = "Species",
    title = "Top Species Composition (Kraken)"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 11),
    plot.title = element_text(size = 14, face = "bold")
  )

# 💾 Save as PNG
ggsave(output_file, p, width = 8, height = 6, dpi = 300)

message("✅ Kraken top species barplot saved as: ", output_file)
