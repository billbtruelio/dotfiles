-- CodeCompanion with Codex (Agent Client Protocol)
return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim", -- nicer prompts
  },
  opts = {
    adapters = {
      -- Keep ACP adapters visible (includes Codex)
      acp = {
        opts = { show_defaults = true },
      },
      codex = {
        opts = {
          commands = { default = { vim.fn.expand("~/.local/bin/codex-acp") } },
        },
      },
    },
    strategies = {
      -- Default everything to Codex ACP
      chat = { adapter = "codex" },
      inline = { adapter = "codex" },
      agent = { adapter = "codex" },
    },
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion Chat Toggle" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion Inline" },
  },
}
