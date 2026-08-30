local map = vim.keymap.set

map("t", "<Esc>", [[<C-\\><C-n>]], { desc = "Terminal Normal Mode" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
