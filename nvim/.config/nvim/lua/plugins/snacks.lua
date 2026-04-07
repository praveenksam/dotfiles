return {
  "snacks.nvim",
  opts = {
    picker = {
      win = {
        list = {
          keys = {
            ["|"] = { "vsplit", mode = { "n" } },
            ["-"] = { "split", mode = { "n" } },
          },
        },
      },
    },
  },
}
