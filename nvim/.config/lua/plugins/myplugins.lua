return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        ignored = true,
      },
    },
  },
  {
    "sitiom/nvim-numbertoggle",
    lazy = false,
    init = function()
      vim.opt.number = true
      vim.opt.relativenumber = true
    end,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Telescope is optional but gives you pickers: solution select, projects, etc.
      "nvim-telescope/telescope.nvim",
    },
    -- Load when you’re in a C# repo or on demand
    ft = { "cs", "sln", "csproj" },
    cmd = { "Dotnet" }, -- so :Dotnet works even outside those filetypes
    config = function()
      require("easy-dotnet").setup({
        lsp = {
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
        -- defaults are fine; tweak if you like:
        -- solution_detection = { files = { "/*.sln", "/**/*.sln" } },
        -- prefer_nvim_root = true,  -- use Neovim root (project) if detected
      })

      -- Handy keymaps (LazyVim uses <leader>; adjust to taste)
      local map = vim.keymap.set
      map("n", "<leader>cb", "<cmd>Dotnet build solution quickfix<CR>", { desc = "Dotnet: Build (quickfix)" })
      map("n", "<leader>co", "<cmd>Dotnet solution select<CR>", { desc = "Dotnet: Select Solution" })
      map("n", "<leader>cd", "<cmd>Dotnet diagnostic errors<CR>", { desc = "Dotnet: Diagnostics (errors)" })
      map("n", "<leader>cx", "<cmd>Dotnet clean<CR>", { desc = "Dotnet: clean" })
      map("n", "]q", ":cnext<CR>", { silent = true, desc = "Next quickfix" })
      map("n", "[q", ":cprev<CR>", { silent = true, desc = "Prev quickfix" })
      -------------------------------------------------------------------
      -- Custom publish command
      -------------------------------------------------------------------
      vim.api.nvim_create_user_command("DotnetPublish", function(opts)
        local args = opts.args ~= "" and (" " .. opts.args) or " -c Release"
        local cmd = "env TERM=dumb dotnet publish --nologo" .. args .. " 2>&1"

        -- Fill quickfix with results
        vim.cmd("cexpr system('" .. cmd:gsub("'", [["]]) .. "')")

        if #vim.fn.getqflist() > 0 then
          vim.cmd("copen")
        else
          vim.cmd("cclose")
          vim.notify(
            "Publish finished ✅ (no quickfix entries). Artifacts in bin/<Config>/<TFM>/publish",
            vim.log.levels.INFO
          )
        end
      end, { desc = "dotnet publish → quickfix", nargs = "*" })

      -- Hotkey for publish
      map("n", "<leader>cp", "<cmd>DotnetPublish<CR>", { desc = "Dotnet: Publish" })
    end,
  },
  -- Custom build keymaps and commands
  {
    "LazyVim/LazyVim",
  },
}
