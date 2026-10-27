# claude-skills

Personal [Claude Code](https://claude.com/claude-code) skills, packaged as a plugin marketplace.

## Skills

| Skill | What it does |
|---|---|
| `r-ggplot-style` | House style for ggplot2 figures in R: cowplot theme, ggsci/viridis colors, grounded bar plots, point-count-aware box/violin plots, patchwork panels, `save_and_plot()` export. |

## Install

```
/plugin marketplace add ljwharbers/claude-skills
/plugin install lharbers@ljwharbers
```

Skills then show up namespaced, e.g. `lharbers:r-ggplot-style`.

To pull in updates later:

```
/plugin marketplace update ljwharbers
```

## Adding a skill

1. Create `skills/<name>/SKILL.md` (plus any `scripts/` or reference files it uses).
2. Bump `version` in both `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`, otherwise installed copies won't update.
3. Add a row to the table above, commit, and push.
