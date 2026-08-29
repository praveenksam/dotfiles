return {
  "PedramNavid/dbtpal",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  ft = { "sql", "yaml", "markdown" },
  keys = {
    { "<leader>dr", "<cmd>DbtRun<cr>", desc = "dbt run (current model)" },
    { "<leader>dR", "<cmd>DbtRunAll<cr>", desc = "dbt run (all models)" },
    { "<leader>dt", "<cmd>DbtTest<cr>", desc = "dbt test (current model)" },
    { "<leader>dc", "<cmd>DbtCompile<cr>", desc = "dbt compile" },
    { "<leader>db", "<cmd>DbtBuild<cr>", desc = "dbt build" },
    {
      "<leader>dm",
      function()
        require("dbtpal.telescope").dbt_picker()
      end,
      desc = "dbt model picker",
    },
  },
  config = function()
    require("dbtpal").setup({
      path_to_dbt = "dbt",
      path_to_dbt_project = "",
      path_to_dbt_profiles_dir = vim.fn.expand("~/.dbt"),
      include_profiles_dir = true,
      include_project_dir = true,
      include_log_level = true,
      extended_path_search = true,
      protect_compiled_files = true,
    })
    require("telescope").load_extension("dbtpal")
  end,
}
