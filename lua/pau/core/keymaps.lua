-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<A-.>", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<A-,>", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
-- keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<A-x>", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<A-w>", "<cmd>bd<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<S-tab>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
keymap.set("n", "<A-l>", "<cmd>wincmd l<CR>", { desc = "Move to right split" })
keymap.set("n", "<A-h>", "<cmd>wincmd h<CR>", { desc = "Move to left split" })
keymap.set("n", "<A-j>", "<cmd>wincmd l<CR>", { desc = "Move to up split" })
keymap.set("n", "<A-k>", "<cmd>wincmd h<CR>", { desc = "Move to down split" })

keymap.set("n", "<A-=>", "<cmd>vertical resize +5<CR>", { desc = "Move to left split" })
keymap.set("n", "<A-->", "<cmd>vertical resize -5<CR>", { desc = "Move to left split" })

keymap.set("n", "<A-S-=>", "<cmd>horizontal resize +5<CR>", { desc = "Move to left split" })
keymap.set("n", "<A-S-->", "<cmd>horizontal resize -5<CR>", { desc = "Move to left split" })
