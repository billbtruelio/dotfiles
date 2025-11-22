-- lua/plugins/dap-coreclr-logging.lua
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function(_, _)
      local dap = require("dap")

      -- Crank up nvim-dap logging too
      dap.set_log_level("TRACE")

      -- Override the coreclr adapter to add netcoredbg logging
      dap.adapters.coreclr = {
        type = "executable",
        -- use the Mason path you already confirmed:
        command = "/Users/billb/.local/share/nvim/mason/bin/netcoredbg",
        args = {
          "--interpreter=vscode",
          "--engineLogging=/tmp/netcoredbg-engine.log", -- VSCode-style log
          "--log", -- netcoredbg internal log (cwd)
        },
      }
    end,
  },
}
