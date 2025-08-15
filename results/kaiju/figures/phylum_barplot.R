# 📍 Set working directory
setwd("~/B269797/results/kaiju/figures")

# 📦 Load necessary libraries
library(tidyverse)

# 📂 Define input/output paths
input_file <- "../tables/phylum_table_kaiju.tsv"
output_file <- "phylum_barplot_kaiju.png"

# 📥 Read phylum-level table
phylum_df <- read.delim(input_file, row.names = 1, check.names = FALSE)

# 🧮 Normalize to relative abundance
phylum_df <- sweep(phylum_df, 2, colSums(phylum_df), FUN = "/")

# ❌ Remove 'cannot be assigned to a (non-viral) phylum'
phylum_df <- phylum_df[!rownames(phylum_df) %in% "cannot be assigned to a (non-viral) phylum", ]

# 🔍 Select top 10 biologically meaningful phyla (excluding "unclassified")
excluded <- c("unclassified")
top_n <- 10
top_phyla <- rownames(
  head(
    phylum_df[!rownames(phylum_df) %in% excluded, ][order(rowSums(phylum_df[!rownames(phylum_df) %in% excluded, ]), decreasing = TRUE), ],
    n = top_n
  )
)

# 🧱 Create final df with Top 10 + "unclassified" + "Other"
selected <- c(top_phyla, "unclassified")
phylum_final_df <- phylum_df[selected, ]
other_phyla <- setdiff(rownames(phylum_df), selected)
phylum_final_df["Other", ] <- colSums(phylum_df[other_phyla, ])

# 🔁 Convert to long format
df_long <- phylum_final_df %>%
  rownames_to_column(var = "Phylum") %>%
  pivot_longer(-Phylum, names_to = "Sample", values_to = "Abundance")

# 🏷️ Rename samples
df_long$Sample <- factor(df_long$Sample,
                         levels = c("AA", "B1", "D1", "E1", "F1", "C1"),
                         labels = c("SDX", "SDY", "STDkvassX", "LSFkvassX", "LSFkvassY", "LSGFkvassX"))

# 🎨 Define color palette (feel free to customize)
color_palette <- c(
  "Bacillota"         = "#cab2d6",
  "Ascomycota"        = "#ffffb3",
  "Pseudomonadota"    = "#8dd3c7",
  "Actinomycetota"    = "#fb9a99",
  "Viruses"           = "#1f78b4",
  "Basidiomycota"     = "#b2df8a",
  "Mucoromycota"      = "#fdbf6f",
  "Blastocladiomycota"= "#e31a1c",
  "Bacteroidota"      = "#a6d854",
  "Chytridiomycota"   = "#ff7f00",
  "unclassified"      = "#984ea3",
  "Other"             = "#b3b3b3"
)

# 🖍️ Filter palette to match data
present_phyla <- unique(df_long$Phylum)
plot_colors <- color_palette[names(color_palette) %in% present_phyla]

# 📊 Generate barplot
p <- ggplot(df_long, aes(x = Sample, y = Abundance, fill = Phylum)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values = plot_colors) +
  ylab("Relative Abundance") +
  xlab("") +
  ggtitle("Kaiju Phylum-level Composition") +
  theme_minimal(base_size = 13) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.title = element_text(size = 13),
    legend.text = element_text(size = 11),
    plot.title = element_text(size = 14, face = "bold")
  )

# 💾 Save plot
ggsave(output_file, plot = p, width = 8, height = 6, dpi = 300)

message("✅ Cleaned phylum barplot saved as ", output_file)
