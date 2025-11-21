return {
  "stevearc/conform.nvim",
  optional = true, -- LazyVim-style, but not strictly required
  opts = function(_, opts)
    -- Make sure these tables exist so we don't blow away other config
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    -- 1) Tell Conform: for C# use csharpier
    opts.formatters_by_ft.cs = { "csharpier" }

    -- 2) Define/override the csharpier formatter to match the current CLI
    opts.formatters.csharpier = {
      inherit = false, -- don't merge with any built-in defaults
      command = "csharpier", -- mason shim at ~/.local/share/nvim/mason/bin/csharpier
      args = { "format" }, -- REQUIRED: modern CLI is command-based
      stdin = true, -- read unformatted code from stdin, write formatted to stdout
    }

    return opts
  end,
}
