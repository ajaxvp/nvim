vim.g.mapleader = " "
vim.g.maplocalleader = " "
local user_profile = vim.fn.getenv "USERPROFILE"
if vim.fn.has("win32") == 1 then
    vim.g.python3_host_prog = tostring(user_profile) .. "/AppData/Local/Python/bin/python3.exe"
    vim.opt.shell = "bash.exe"
    vim.opt.shellcmdflag = "-c"
    vim.opt.shellredir = ">%s 2>&1"
    vim.opt.shellpipe = "2>&1| tee"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end

-- tab behavior
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    command = "silent! checktime",
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup("plugins", {
    change_detection = {
        notify = false,
    },
})

vim.keymap.set('n', '<Leader>d', '<C-d>', { desc = 'Half page down' })
vim.keymap.set('n', '<Leader>e', '<C-u>', { desc = 'Half page up' })

vim.keymap.set('n', '<leader>o', 'o<Esc>', { desc = 'Insert line below' })
vim.keymap.set('n', '<leader>O', 'O<Esc>', { desc = 'Insert line above' })
