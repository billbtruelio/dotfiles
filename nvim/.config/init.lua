-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 1) Keep build output plain (no colors/align) so parsing is easy
vim.o.makeprg = [[env TERM=dumb dotnet build --nologo]]

-- 2) Errorformat tuned to your output
-- Matches:
--   /path/File.cs(80,73): error CS0103: message
--   /path/File.cs(80,73): warning CS8604: message
vim.o.errorformat = table.concat({
  [[%E%f(%l\\,%c): error %\\w%\\+:%m]],
  [[%W%f(%l\\,%c): warning %\\w%\\+:%m]],
  [[%E%f(%l): error %\\w%\\+:%m]], -- fallback: no column
  [[%W%f(%l): warning %\\w%\\+:%m]], -- fallback: no column
  [[%-G%.%#]], -- ignore the rest (summaries, etc.)
}, ",")

-- 3) :Make that opens quickfix on completion
vim.api.nvim_create_user_command("Make", function()
  -- register the autocmd *before* running make
  vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    once = true,
    pattern = { "make", "make!" },
    callback = function()
      if #vim.fn.getqflist() > 0 then
        vim.cmd("copen")
      else
        vim.cmd("cclose")
        vim.notify("Build succeeded ✅ (no quickfix entries)", vim.log.levels.INFO)
      end
    end,
  })
  vim.cmd("make!") -- async; use :copen to peek early if you want
end, { desc = "dotnet build -> quickfix" })

-- (nice-to-have) quickfix navigation
vim.keymap.set("n", "]q", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "[q", ":cprev<CR>", { silent = true })
