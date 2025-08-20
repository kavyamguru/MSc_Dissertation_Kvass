

# ------------------------------
# 📦 Load required libraries
# ------------------------------
suppressPackageStartupMessages({
  library(tidyverse)
  library(pheatmap)
  library(RColorBrewer)
})

# ------------------------------
# 📂 Load genus table (percent or fraction OK)
# ------------------------------
infile <- "exports_genus_relfreq/genus_relabund_percent.tsv"
genus_df <- read.delim(infile, skip = 1, row.names = 1, check.names = FALSE)

# ------------------------------
# 📊 Ensure columns sum to 1 (convert to fractions)
#     Works whether input is % or already fractions
# ------------------------------
rel_abund <- sweep(genus_df, 2, colSums(genus_df), FUN = "/")

# ------------------------------
# 🧹 Extract clean genus names (handles strings with or without 'g__')
#     Then collapse duplicate genera by summing
# ------------------------------
clean_genus <- function(x) {
  parts <- unlist(strsplit(x, ";"))
  g <- parts[grep("g__", parts)]
  if (length(g) == 0 || grepl("^g__\\s*$|^g__$", g)) {
    nm <- tail(parts, 1)
  } else {
    nm <- sub("^g__","", g)
  }
  nm <- sub("^g__","", nm)      # strip any lingering prefix
  nm <- ifelse(nm == "" | nm == "__", "Unassigned", nm)
  nm
}
cg <- vapply(rownames(rel_abund), clean_genus, character(1))
rel_abund <- as.data.frame(rel_abund) %>%
  rownames_to_column("GenusRaw") %>%
  mutate(Genus = cg) %>%
  select(-GenusRaw) %>%
  group_by(Genus) %>%
  summarise(across(everything(), sum), .groups = "drop") %>%
  column_to_rownames("Genus")

# ------------------------------
# 🔝 Select top 15 genera by mean abundance
# ------------------------------
topN <- 15
if (nrow(rel_abund) < topN) topN <- nrow(rel_abund)
top_idx <- order(rowMeans(rel_abund), decreasing = TRUE)[seq_len(topN)]
rel_abund_top <- rel_abund[top_idx, , drop = FALSE]

# ------------------------------
# 📐 Reorder samples (use only those present)
# ------------------------------
desired_order <- c("SDX", "SDY", "STDkvassX", "LSFkvassX", "LSFkvassY", "LSGFkvassX")
ordered_samples <- intersect(desired_order, colnames(rel_abund_top))
rel_abund_top <- rel_abund_top[, ordered_samples, drop = FALSE]

# ------------------------------
# 🔬 Log10 transform for heatmap (add small offset)
# ------------------------------
log_abund_top <- log10(rel_abund_top + 1e-5)


# Journal-style TIFF (often requested)
tiff("figure2_genus_heatmap_top15_600dpi.tiff",
     width = 2400, height = 2000, res = 600, compression = "lzw")
pheatmap(log_abund_top,
         cluster_cols = FALSE, cluster_rows = TRUE,
         color = colorRampPalette(RColorBrewer::brewer.pal(9, "YlGnBu"))(100),
         breaks = seq(min(log_abund_top), max(log_abund_top), length.out = 101),
         fontsize_row = 7, fontsize_col = 7,
         border_color = NA,
         main = "16S Genera composition")
dev.off()


# build plot





# ---- Start from the objects you already have ----
# rel_abund  : genus x sample matrix of fractions (0–1)
# desired_order <- c("SDX","SDY","STDkvassX","LSFkvassX","LSFkvassY","LSGFkvassX")

library(tidyverse)
library(ggplot2)

# Top 15 genera by mean abundance across samples
topN <- 15
top_genera <- names(sort(rowMeans(rel_abund), decreasing = TRUE))[seq_len(min(topN, nrow(rel_abund)))]

# Long table for plotting; collapse non-top to "Other"
plot_df <- rel_abund %>%
  rownames_to_column("genus") %>%
  pivot_longer(-genus, names_to = "sample", values_to = "rel_abund") %>%
  mutate(genus = if_else(genus %in% top_genera, genus, "Other")) %>%
  group_by(sample, genus) %>%
  summarise(rel_abund = sum(rel_abund), .groups = "drop")

# Order samples and put "Other" last in legend
plot_df$sample <- factor(plot_df$sample, levels = intersect(desired_order, unique(plot_df$sample)))
plot_df$genus  <- factor(plot_df$genus, levels = c(setdiff(top_genera, "Other"), "Other"))
# ---- Custom colors for genera (insert BEFORE ggplot) ----
# Known colors you want to fix (add/remove as you like)
known_cols <- c(
  "Levilactobacillus"   = "#a6cee3",
  "Lactiplantibacillus" = "#1f78b4",
  "Faecalibacterium"    = "#b2df8a",
  "Aquabacterium"       = "#ccebc5",
  "Duodenibacillus"     = "#80b1d3",
  "JBAIYU01"            = "#fdb462",
  "Unassigned"          = "#bdbdbd",
  "Allorhizobium"       = "#00bcd4",
  "Pantoea"             = "#fb9a99",
  "Acetobacter"         = "#33a02c",
  "Hylemonella"         = "#fccde5",
  "Novosphingobium"     = "#ff7f00",
  "Comamonas"           = "#6a3d9a",
  "CALKXV01"            = "#8dd3c7",
  "UBA1258"             = "#bc80bd",
  "Other"               = "#ff8c00"
)

# If any plotted genera aren't in known_cols, assign extra distinct colors
lvl <- levels(plot_df$genus)
missing <- setdiff(lvl, names(known_cols))
if (length(missing)) {
  # use Set3 (or hue_pal()) for the extras
  n <- length(missing)
  extra <- setNames(RColorBrewer::brewer.pal(max(3, min(12, n)), "Set3")[seq_len(n)], missing)
  genus_cols <- c(known_cols, extra)
} else {
  genus_cols <- known_cols
}
# keep only those in the plot, in legend order
genus_cols <- genus_cols[lvl]

# Build the stacked bar plot
p <- ggplot(plot_df, aes(sample, rel_abund, fill = genus)) +
  geom_col(width = 0.85) +
  scale_fill_manual(
    values = genus_cols,
    limits = levels(plot_df$genus),  # keeps legend order
    drop   = FALSE                    # keep "Other" even if absent
  ) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(title = "16S Genus composition", x = NULL, y = "Relative abundance") +
  guides(fill = guide_legend(ncol = 1)) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "right")


# One-time install
# install.packages("ragg")
# install.packages("Cairo")  # optional alternative

# PNG 600 dpi
ragg::agg_png("genus_barplot_top15_600dpi.png",
              width = 8, height = 5, units = "in", res = 600, background = "white")
print(p); dev.off()

# TIFF 600 dpi with LZW compression
ragg::agg_tiff("genus_barplot_top15_600dpi.tiff",
               width = 8, height = 5, units = "in", res = 600,
               compression = "lzw", background = "white")
print(p); dev.off()

# Vector PDF (best for journals)
ggsave("genus_barplot_top15.pdf", plot = p,
       width = 8, height = 5, units = "in",
       device = grDevices::cairo_pdf, bg = "white")


