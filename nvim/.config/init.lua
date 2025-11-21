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
-- ─────────────────────────────────────────────────────────────────────────────
-- Yank / Delete whole buffer helpers
-- yyy → yank entire buffer (uses default register)
-- ddd → delete entire buffer to the black hole (clipboard/registers untouched)
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "yyy", [[:%y<CR>]], {
  silent = true,
  desc = "Yank entire buffer",
})

vim.keymap.set("n", "ddd", [[:%delete _<CR>]], {
  silent = true,
  desc = "Delete entire buffer (black hole)",
})

-- Optional: a friendly heads-up after the big delete (comment out if you hate joy)
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = ":",
  callback = function()
    if vim.v.event and vim.v.event.cmdtype == ":" and vim.fn.getcmdline():match("^%%delete _$") then
      vim.schedule(function()
        vim.notify("Buffer cleared (sent to the void). Clipboard left untouched. 🕳️", vim.log.levels.WARN)
      end)
    end
  end,
})
