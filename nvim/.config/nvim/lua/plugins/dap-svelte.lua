return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations.svelte = dap.configurations.javascript
    end,
  },
}
