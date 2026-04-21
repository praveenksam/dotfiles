return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "dawn", -- "main" (dark) | "moon" (dark alt) | "dawn" (light)
      dark_variant = "main", -- used when variant = "auto"

      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },

      -- Override specific highlight groups if needed
      highlight_groups = {
        -- Make comments a bit more visible on the light bg
        Comment = { fg = "muted", italic = true },
        -- Nicer vertical split border
        VertSplit = { fg = "subtle" },
        -- Match your Starship/Sketchybar pine colour for LineNr
        LineNr = { fg = "subtle" },
        CursorLineNr = { fg = "iris", bold = true },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  -- Tell LazyVim to use rose-pine instead of tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
