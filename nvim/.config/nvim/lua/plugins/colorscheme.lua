return {
  {
    "marciomazza/vim-brogrammer-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("brogrammer")
    end,
  },
  -- Tell LazyVim to use brogrammer instead of tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "brogrammer",
    },
  },
}
