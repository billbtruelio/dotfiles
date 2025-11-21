return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = false,
        -- omnisharp = {
        --   use_modern_net = true, -- use the .NET build, not Mono
        --   enable_roslyn_analyzers = false,
        --   analyze_open_documents_only = true,
        --   on_attach = function(client, bufnr)
        --     -- optional: disable semantic tokens (helps with freezes)
        --     client.server_capabilities.semanticTokensProvider = nil
        --   end,
        --   handlers = {}, -- leave blank unless you’ve got custom handlers
        -- },
      },
    },
  },
}
