return {
  -- Core DAP
  { "mfussenegger/nvim-dap" },

  -- DAP UI (needs nvim-nio)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },

  -- Mason <-> DAP glue
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "netcoredbg" },
      automatic_setup = true,
    },
  },

  -- Actual .NET adapter + configs + keymaps
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Adapter: netcoredbg from Mason
      local netcoredbg = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg"
      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg,
        args = { "--interpreter=vscode" },
      }

      -- C# launch / attach
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch (Debug DLL)",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            local guess = cwd .. "/bin/Debug/net9.0/" .. vim.fn.fnamemodify(cwd, ":t") .. ".dll"
            return vim.fn.input("Path to program (.dll): ", guess, "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          justMyCode = true,
          env = { ASPNETCORE_ENVIRONMENT = "Development" },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        {
          type = "coreclr",
          name = "Attach (pick process)",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      -- UI wiring
      dapui.setup()
      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
      end

      -- Keys
      local map = vim.keymap.set
      map("n", "<F5>", dap.continue, { desc = "DAP Continue/Start" })
      map("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
      map("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
      map("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
      map("n", "<S-F11>", dap.step_out, { desc = "DAP Step Out" })
      map("n", "<leader>db", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "DAP Conditional BP" })
      map("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log: "))
      end, { desc = "DAP Logpoint" })
      map("n", "<S-F5>", function()
        require("dap").terminate()
        require("dapui").close()
      end, { desc = "Stop Debugging" })
      map("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL" })
      map("n", "<leader>du", dapui.toggle, { desc = "DAP UI Toggle" })
    end,
  },
}
