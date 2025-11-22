-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { silent = true, desc = "Save and leave insert mode" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>be", function()
  require("telescope.builtin").buffers({
    sort_mru = true, -- sort by most recently used
    ignore_current_buffer = false,
    only_cwd = false,
    show_all_buffers = false, -- hides unlisted/hidden buffers
  })
end, { desc = "List recent buffers" })

-- Visual mode: move selection up/down
vim.keymap.set("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Normal mode: move current line up/down
vim.keymap.set("n", "K", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "J", ":m .+1<CR>==", { desc = "Move line down" })

-- use functions so require() triggers lazy-load
map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "DAP Continue/Start" })

map("n", "<S-F5>", function()
  require("dap").terminate()
  require("dapui").close()
end, { desc = "DAP Stop" })

map("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })

map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "DAP Step Over" })

map("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "DAP Step Into" })

map("n", "<S-F11>", function()
  require("dap").step_out()
end, { desc = "DAP Step Out" })

map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "DAP REPL" })

map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "DAP UI Toggle" })

-- Operator: replace {motion} with system clipboard
local function ReplaceWithClipboard(type)
  local s = vim.api.nvim_buf_get_mark(0, "[") -- start of last op
  local e = vim.api.nvim_buf_get_mark(0, "]") -- end of last op

  -- normalize
  if s[1] > e[1] or (s[1] == e[1] and s[2] > e[2]) then
    s, e = e, s
  end

  local srow, scol = s[1] - 1, s[2]
  local erow, ecol = e[1] - 1, e[2]

  if type == "line" then
    -- cover full lines
    scol = 0
    local last = vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1] or ""
    ecol = #last
  else
    -- charwise: make end **exclusive**
    ecol = ecol + 1
  end

  local clip = vim.fn.getreg("+")
  local lines = vim.split(clip, "\n", { plain = true })
  -- trim trailing empty if clipboard ends with newline
  if clip:sub(-1) == "\n" and lines[#lines] == "" then
    table.remove(lines)
  end

  vim.api.nvim_buf_set_text(0, srow, scol, erow, ecol, lines)
end

_G.ReplaceWithClipboard = ReplaceWithClipboard

vim.keymap.set("n", "<leader>P", function()
  vim.o.operatorfunc = "v:lua.ReplaceWithClipboard"
  return "g@"
end, { expr = true, desc = "Replace {motion} with clipboard (+)" })

-- Visual mode version (handles char/line visual)
vim.keymap.set("x", "<leader>P", function()
  local s = vim.api.nvim_buf_get_mark(0, "<")
  local e = vim.api.nvim_buf_get_mark(0, ">")
  if s[1] > e[1] or (s[1] == e[1] and s[2] > e[2]) then
    s, e = e, s
  end

  local vm = vim.fn.visualmode() -- 'v' char, 'V' line, etc.
  local srow, scol = s[1] - 1, s[2]
  local erow, ecol = e[1] - 1, e[2]

  if vm == "V" then
    scol = 0
    local last = vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1] or ""
    ecol = #last
  else
    ecol = ecol + 1
  end

  local clip = vim.fn.getreg("+")
  local lines = vim.split(clip, "\n", { plain = true })
  if clip:sub(-1) == "\n" and lines[#lines] == "" then
    table.remove(lines)
  end

  vim.api.nvim_buf_set_text(0, srow, scol, erow, ecol, lines)
end, { desc = "Replace selection with clipboard (+)" })

-- Close completion/docs/signature help; do NOTHING else.
vim.keymap.set("i", "<C-]>", function()
  -- 1) blink.cmp
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink and blink and blink.is_visible and blink.hide then
    local ok_vis, vis = pcall(blink.is_visible)
    if ok_vis and vis then
      blink.hide()
      return "" -- stay in insert
    end
  end

  -- 2) nvim-cmp (if you ever use it)
  local ok_cmp, cmp = pcall(require, "cmp")
  if ok_cmp and cmp and cmp.visible and cmp.visible() then
    cmp.abort()
    return ""
  end

  -- 3) Native popup menu
  if vim.fn.pumvisible() == 1 then
    -- <C-e> (native meaning) closes pum but we return it as keys
    return vim.api.nvim_replace_termcodes("<C-e>", true, false, true)
  end

  -- 4) Noice (signature/hover)
  local ok_noice, noice = pcall(require, "noice")
  if ok_noice and noice and noice.cmd then
    noice.cmd("dismiss")
    return ""
  end

  return "" -- nothing to close; do nothing, stay in insert
end, { expr = true, silent = true, desc = "Dismiss completion/docs/signature" })
