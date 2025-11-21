-- ~/.config/nvim/lua/plugins/neogit.lua
return {
  "NeogitOrg/neogit",
  lazy = false, -- <-- Eager load on startup
  priority = 1000, -- (optional) ensure it loads early
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("neogit").setup({
      disable_commit_confirmation = true,
      integrations = { diffview = true, telescope = true },
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
    })
    -- your keymaps (now that it's loaded for sure)
    vim.keymap.set("n", "<leader>gs", function()
      require("neogit").open({ kind = "replace", cwd = vim.fn.expand("%:p:h") })
    end, { desc = "Neogit status (buffer repo)" })
  end,
}
