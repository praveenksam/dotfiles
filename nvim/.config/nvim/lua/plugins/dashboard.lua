return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        width = 100,
        sections = {
          {
            section = "terminal",
            cmd = "fastfetch -c ~/.config/fastfetch/logo-only.jsonc --pipe false",
            height = 20,
            padding = 1,
            indent = 30,
          },
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          {
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git --no-pager log --oneline --decorate -5",
            icon = " ",
            title = "Recent Commits",
            height = 7,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
        },
        preset = {
          header = [[
      ___           ___           ___                                     ___     
     /\  \         /\__\         /\  \          ___                      /\  \    
     \:\  \       /:/ _/_       /::\  \        /\  \        ___         |::\  \   
      \:\  \     /:/ /\__\     /:/\:\  \       \:\  \      /\__\        |:|:\  \  
  _____\:\  \   /:/ /:/ _/_   /:/  \:\  \       \:\  \    /:/__/      __|:|\:\  \ 
 /::::::::\__\ /:/_/:/ /\__\ /:/__/ \:\__\  ___  \:\__\  /::\  \     /::::|_\:\__\
 \:\~~\~~\/__/ \:\/:/ /:/  / \:\  \ /:/  / /\  \ |:|  |  \/\:\  \__  \:\~~\  \/__/
  \:\  \        \::/_/:/  /   \:\  /:/  /  \:\  \|:|  |   ~~\:\/\__\  \:\  \      
   \:\  \        \:\/:/  /     \:\/:/  /    \:\__|:|__|      \::/  /   \:\  \     
    \:\__\        \::/  /       \::/  /      \::::/__/       /:/  /     \:\__\    
     \/__/         \/__/         \/__/        ~~~~           \/__/       \/__/    
        
        
    T H E   F O R C E  I S   S T R O N G
         
      W I T H   T H I S  E D I T O R

          ]],
        },
      },
    },
  },
}
