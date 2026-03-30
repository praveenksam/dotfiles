-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Brogrammer colors
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#2a84d2" })
    vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#d6dbe5" })
    vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#2dc55e" })
    vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#1081d6" })
    vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = "#ecba0f" })
    vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#4e5ab7" })
    vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = "#2dc55e" })
  end,
})
