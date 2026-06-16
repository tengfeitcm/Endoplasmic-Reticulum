suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(tibble)
  library(ggpubr)
})

root_dir <- "E:/房颤验证集/新增验证_GSE14975_Enet02/GSE14975_only_publication_consistent"
figure_dir <- file.path(root_dir, "figures")

dev_path <- "E:/房颤验证集/房颤205.geoML(1)/205.geoML(1)/06.sva/merge.normalize.txt"
valid_path <- file.path(root_dir, "tables", "GSE14975_sample_predicted_probabilities.csv")
locked_genes <- c("AADAC", "ALOX5AP", "BCHE", "CXCL1", "CXCR4", "HLA-DPB1", "HLA-DQA1", "IER3", "MGAM", "NCF2", "RAC2", "RPS11", "S100A4", "S100A8", "S100A9", "TYROBP", "UTS2", "WT1")

read_matrix <- function(path) read.table(path, header = TRUE, sep = "\t", check.names = FALSE, row.names = 1)
get_y <- function(sample_names) ifelse(grepl("_Treat$", sample_names), 1, 0)

# rebuild development predictions using the same final workflow
dev_mat <- read_matrix(dev_path)
dev_id <- colnames(dev_mat)
dev_y <- get_y(dev_id)
dev_x <- as.data.frame(t(dev_mat[locked_genes, dev_id, drop = FALSE]), check.names = FALSE)
dev_x_sc <- as.data.frame(scale(dev_x, center = TRUE, scale = TRUE), check.names = FALSE)
fit <- suppressWarnings(glm(dev_y ~ ., data = data.frame(dev_y = dev_y, dev_x_sc, check.names = FALSE), family = binomial()))
dev_prob <- pmin(pmax(as.numeric(predict(fit, type = "response")), 1e-6), 1 - 1e-6)

gse14975_tbl <- read_csv(valid_path, show_col_types = FALSE)
plot_df <- bind_rows(
  tibble(Cohort = "Development", Group = ifelse(dev_y == 1, "AF", "Control"), PredictedProbability = dev_prob),
  tibble(Cohort = "GSE14975", Group = gse14975_tbl$Group, PredictedProbability = gse14975_tbl$PredictedProbability)
) %>%
  mutate(
    Cohort = factor(Cohort, levels = c("Development", "GSE14975")),
    Group = factor(Group, levels = c("Control", "AF"))
  )

# pretty p labels
get_p_label <- function(df) {
  p <- tryCatch(wilcox.test(PredictedProbability ~ Group, data = df)$p.value, error = function(e) NA_real_)
  if (is.na(p)) return("p = NA")
  if (p < 0.001) return("p < 0.001")
  paste0("p = ", formatC(p, format = "f", digits = 3))
}

p_annot <- plot_df %>%
  group_by(Cohort) %>%
  summarise(
    p_label = get_p_label(cur_data()),
    y_pos = max(PredictedProbability, na.rm = TRUE) + 0.05,
    .groups = "drop"
  )

fill_cols <- c("Control" = "#8FB3D9", "AF" = "#E8A09A")
line_cols <- c("Control" = "#517CA8", "AF" = "#C96A63")

p <- ggplot(plot_df, aes(x = Group, y = PredictedProbability, fill = Group)) +
  geom_violin(width = 0.9, alpha = 0.45, color = NA, trim = FALSE) +
  geom_boxplot(width = 0.22, outlier.shape = NA, alpha = 0.95, color = "#333333", linewidth = 0.45) +
  geom_jitter(aes(color = Group), width = 0.06, size = 1.8, alpha = 0.9, show.legend = FALSE) +
  facet_wrap(~ Cohort, nrow = 1) +
  scale_fill_manual(values = fill_cols) +
  scale_color_manual(values = line_cols) +
  coord_cartesian(ylim = c(-0.02, 1.10), clip = "off") +
  stat_summary(fun = median, geom = "point", shape = 23, size = 2.2, fill = "white", color = "black") +
  geom_segment(data = p_annot, aes(x = 1, xend = 2, y = y_pos, yend = y_pos), inherit.aes = FALSE, linewidth = 0.5) +
  geom_segment(data = p_annot, aes(x = 1, xend = 1, y = y_pos - 0.025, yend = y_pos), inherit.aes = FALSE, linewidth = 0.5) +
  geom_segment(data = p_annot, aes(x = 2, xend = 2, y = y_pos - 0.025, yend = y_pos), inherit.aes = FALSE, linewidth = 0.5) +
  geom_text(data = p_annot, aes(x = 1.5, y = y_pos + 0.02, label = p_label), inherit.aes = FALSE, size = 3.7, fontface = "italic") +
  labs(
    title = "Predicted probability distribution of the locked signature",
    subtitle = "Development cohort and GSE14975",
    x = NULL,
    y = "Predicted probability"
  ) +
  theme_classic(base_size = 12) +
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(face = "bold", size = 11),
    axis.line = element_line(color = "#333333", linewidth = 0.35),
    axis.ticks = element_line(color = "#333333", linewidth = 0.35),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 13),
    plot.subtitle = element_text(hjust = 0.5, size = 11),
    plot.margin = margin(8, 16, 8, 8)
  )

ggsave(file.path(figure_dir, "GSE14975_predicted_probability_boxplot.pdf"), p, width = 8.6, height = 4.9, device = cairo_pdf)
ggsave(file.path(figure_dir, "GSE14975_predicted_probability_boxplot.png"), p, width = 8.6, height = 4.9, dpi = 320)
message("Redrew S2 using violin + boxplot + jitter with improved styling.")
