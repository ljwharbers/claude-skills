# House style helpers for ggplot2 plots.
# Source this after loading ggplot2/cowplot/ggsci/viridis, e.g.:
#   source("scripts/plot_theme.R")

require(ggplot2)
require(cowplot)
require(ggsci)
require(viridis)

# Base theme: cowplot with a larger base font, set as the default for every
# plot so individual scripts don't need to repeat theme() calls.
theme_custom = function(font_size = 14, font_family = "Helvetica") {
  theme_cowplot(font_size = font_size, font_family = font_family)
}
theme_set(theme_custom())

# Default color scales.
# Discrete: ggsci "npg" palette (swap for another ggsci palette, e.g.
# scale_color_lancet()/scale_fill_lancet(), if npg's colors clash with the data).
scale_color_discrete = scale_color_npg
scale_fill_discrete  = scale_fill_npg

# Continuous: viridis, for anything mapped to a numeric gradient (expression,
# score, p-value, etc).
scale_color_continuous = scale_color_viridis_c
scale_fill_continuous  = scale_fill_viridis_c

# Bar plots should sit flush on the x-axis (no gap under the bars) but keep a
# little headroom above the tallest bar. Add this scale to every bar plot:
#   ggplot(...) + geom_col(...) + expand_bars
expand_bars = scale_y_continuous(expand = expansion(mult = c(0, 0.05)))

# Distribution plots (box/violin): which geoms to use depends on how many
# points are being summarized per group.
# - Few points per group: a boxplot with the raw points jittered on top, using
#   a narrow jitter width so points don't spill outside the box.
# - Many points per group: the boxplot gets hidden inside a violin (a
#   full-width boxplot on top of a violin is visually redundant/cluttered), so
#   plot a violin with a small boxplot nested inside it instead.
# `n` is the number of points in the group being plotted (use the
# smallest/most-relevant group when group sizes differ). Adjust `threshold` if
# 50 doesn't suit the data at hand.
distribution_geoms = function(n, threshold = 50) {
  if (n >= threshold) {
    list(
      geom_violin(trim = FALSE),
      geom_boxplot(width = 0.1, outlier.shape = NA)
    )
  } else {
    list(
      geom_boxplot(outlier.shape = NA),
      geom_jitter(width = 0.1, size = 1, alpha = 0.6)
    )
  }
}
