---
name: r-ggplot-style
description: Use whenever writing R code that plots or visualizes data with ggplot2 — scatter plots, bar/column charts, box/violin plots, line plots, or any "make a figure/plot/chart in R" request, even if the user doesn't say "ggplot" or "style" explicitly. Applies the user's house plotting style (cowplot theme, ggsci/viridis colors, grounded bar plots, point-count-aware box/violin plots, patchwork panels, save_and_plot export) instead of default ggplot2 styling. Always consult this before writing new ggplot code in R.
---

# R ggplot house style

This user has an established plotting convention used across their R projects
(see `functions/setup.R` / `functions/save_and_plot.R` in existing repos). When
writing or editing ggplot2 code in R, follow it instead of vanilla ggplot2
defaults, so figures look consistent with their other work.

## Check for a project-local copy first

Many of this user's projects already have `functions/setup.R` and
`functions/save_and_plot.R`. Before using the bundled scripts below, check
whether the current project has these (commonly under `functions/` or
`./scripts/`). If they exist, `source()` the project's own copies instead —
that keeps any project-specific palettes (e.g. named color vectors for
conditions/cell types) intact. Only fall back to the bundled versions in
`scripts/` here when the project has none of its own.

```r
source("scripts/plot_theme.R")     # theme_custom(), default scales, helpers
source("scripts/save_and_plot.R")  # save_and_plot() export helper
```

## Core conventions

- **Theme**: `theme_custom()` (a thin wrapper over `cowplot::theme_cowplot()`
  with a larger base font, `theme_set()` so it applies automatically). Don't
  add `theme_bw()`/`theme_minimal()`/gridlines on top — the clean, gridline-free
  cowplot look is the point.
- **Font**: Helvetica, larger base size (14) — figures are read in talks and
  papers, not just on screen.
- **Discrete colors**: ggsci palettes, default `scale_color_npg()` /
  `scale_fill_npg()`. If a plot has many categories or the npg palette's colors
  are hard to tell apart for the specific data, another ggsci palette (e.g.
  `scale_color_lancet()`, `scale_color_aaas()`) is a fine substitute — just stay
  within ggsci rather than switching to ggplot2 defaults.
- **Continuous colors**: viridis (`scale_color_viridis_c()` /
  `scale_fill_viridis_c()`), for anything mapped to a numeric gradient.
- **Multi-panel figures**: compose with `patchwork` (`p1 + p2`, `plot_layout()`),
  not `cowplot::plot_grid` or `gridExtra`.
- **Assignment**: use `=`, not `<-`, per this user's R convention.

## Bar plots: always ground them on the axis

Bars floating above the x-axis (ggplot2's default `expand` padding) look wrong
for count/magnitude data — the bar should visually start at zero. Add
`expand_bars` (from `plot_theme.R`) to every bar/column plot:

```r
ggplot(dt, aes(x = group, y = count)) +
  geom_col() +
  expand_bars
```

This is `scale_y_continuous(expand = expansion(mult = c(0, 0.05)))` — no gap
below the bars, a little headroom above the tallest one.

## Box/violin plots: choose the geoms by how many points there are

Plotting every raw point on top of a boxplot works when there are a handful of
points per group, but with dozens+ of points the jitter overplots and a
boxplot's shape becomes the more honest summary. Use `distribution_geoms(n)`
from `plot_theme.R` to pick the right combination:

- **Few points per group** (below the threshold, default 50): boxplot with
  points jittered on top, using a **narrow jitter width** so points stay inside
  the box rather than spilling past its edges.
- **Many points per group**: a violin (captures the full distribution shape)
  with a **small boxplot nested inside it** — not a full-width boxplot, which
  would visually compete with the violin.

```r
n = dt[, .N, by = group][, min(N)]   # or however group sizes are determined
ggplot(dt, aes(x = group, y = value)) +
  distribution_geoms(n)
```

Treat the threshold as a starting point, not a hard rule — if the data looks
cluttered or sparse right at the boundary, use judgment.

## Saving figures

Use `save_and_plot(plot, bname, width, height, dpi = 300)` rather than
`ggsave()` — it's the established export path in this user's projects (writes
PNG at 300dpi by default; can also emit vector formats via the `output=`
argument, and auto-creates the output directory). Don't introduce a parallel
`ggsave()`-based saving convention unless the user asks for one.

## Example putting it together

```r
source("scripts/plot_theme.R")
source("scripts/save_and_plot.R")

plt = ggplot(dt, aes(x = celltype, y = expression, fill = celltype)) +
  distribution_geoms(n = dt[, .N, by = celltype][, min(N)]) +
  scale_fill_discrete() +
  labs(x = NULL, y = "Expression", title = "Gene X")

save_and_plot(plt, "figures/gene_x_expression", width = 6, height = 4)
```
