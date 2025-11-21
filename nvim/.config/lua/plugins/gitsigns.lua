-- ~/.config/nvim/lua/plugins/gitsigns.lua
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    -- Inline blame on the current line (aka “hovering blame” vibes)
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300, -- ms before showing blame
      virt_text = true,
      virt_text_pos = "eol", -- show at end of line
      ignore_whitespace = true,
    },
    -- Nice readable blame format
    current_line_blame_formatter = " <author>, <author_time:%R> • <summary>",
  },
  keys = {
    -- Full blame popup for the current line (use when the inline hint isn’t enough)
    {
      "<leader>gb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Git blame (popup)",
    },

    -- Toggle the inline blame if you want to declutter temporarily
    {
      "<leader>gB",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle inline blame",
    },

    -- Handy hunk nav/actions (because you’re absolutely going to use these)
    {
      "]h",
      function()
        require("gitsigns").next_hunk()
      end,
      desc = "Next hunk",
    },
    {
      "[h",
      function()
        require("gitsigns").prev_hunk()
      end,
      desc = "Prev hunk",
    },
    {
      "<leader>hs",
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = "Stage hunk",
    },
    {
      "<leader>hr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset hunk",
    },
    {
      "<leader>hp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview hunk",
    },
  },
}
