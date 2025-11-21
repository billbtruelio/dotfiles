-- lua/plugins/mssql.lua
return {
  {
    "Kurren123/mssql.nvim",
    event = "VeryLazy",
    opts = { keymap_prefix = "<leader>m" }, -- optional
    config = function(_, opts)
      pcall(function()
        require("mssql").setup(opts)
      end)

      local function set_sql_maps(buf)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        -- Normal: F5 executes selection or whole buffer (plugin auto-detects)
        map("n", "<F5>", "<cmd>MSSQL ExecuteQuery<CR>", "MSSQL: Execute (buffer/selection)")

        -- Insert: F5 pop to normal, execute, then hop back to insert
        map("i", "<F5>", function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
          vim.cmd("MSSQL ExecuteQuery")
          vim.api.nvim_feedkeys("a", "n", false)
        end, "MSSQL: Execute (stay in insert)")

        -- Visual: F5 execute current selection (NO range prefix!)
        map("v", "<F5>", "<cmd>MSSQL ExecuteQuery<CR>", "MSSQL: Execute selection")

        -- Normal: F6 = execute current line
        map("n", "<F6>", function()
          local save = vim.fn.winsaveview()
          vim.cmd("normal! V") -- select current line
          vim.cmd("MSSQL ExecuteQuery") -- plugin runs the selection
          vim.fn.winrestview(save)
          vim.cmd("normal! gv") -- clear selection highlight
        end, "MSSQL: Execute current line")
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "tsql" },
        callback = function(args)
          set_sql_maps(args.buf)
        end,
      })
    end,
  },

  -- Lualine component (per README)
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    dependencies = { "Kurren123/mssql.nvim" },
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}
      table.insert(opts.sections.lualine_c, require("mssql").lualine_component)
      return opts
    end,
  },
}
