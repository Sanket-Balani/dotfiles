vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

local py3_host = vim.fn.expand("~/.local/share/nvim/python3/bin/python3")
if vim.fn.executable(py3_host) == 1 then
  vim.g.python3_host_prog = py3_host
end

-- Use markdown parser as fallback for norg-related docs/image parsing checks.
pcall(vim.treesitter.language.register, "markdown", "norg")

vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

if vim.fn.has("wsl") == 1 then
  local clip = "/mnt/c/Windows/System32/clip.exe"
  local powershell = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
  if vim.fn.executable(clip) == 1 and vim.fn.executable(powershell) == 1 then
    vim.g.clipboard = {
      name = "WSL Clipboard",
      copy = {
        ["+"] = clip,
        ["*"] = clip,
      },
      paste = {
        ["+"] = { powershell, "-NoProfile", "-Command", "Get-Clipboard -Raw" },
        ["*"] = { powershell, "-NoProfile", "-Command", "Get-Clipboard -Raw" },
      },
      cache_enabled = 0,
    }
  end
end
