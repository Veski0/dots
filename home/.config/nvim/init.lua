----- Bootstrap lazy.nvim -----------------------------------------------------
--- Bootsrapping lazy should bootstrap all other plugins.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

----- Leader Key Configuration ------------------------------------------------
vim.g.mapleader        = " "
vim.g.maplocalleader   = " "

----- Basic Vim Options -------------------------------------------------------
vim.opt.colorcolumn    = "80"
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.expandtab      = true
vim.opt.shiftwidth     = 2
vim.opt.tabstop        = 2
vim.opt.termguicolors  = true
vim.opt.wrap           = false
vim.opt.undofile       = true
vim.opt.laststatus     = 1 -- one global statusline
vim.opt.cmdheight      = 0 -- hide command line unless needed
vim.opt.clipboard      = "unnamedplus"

----- Register Functionality --------------------------------------------------
require('custom-functionality/bash-runners')
require('custom-functionality/colorscheme-picker')
require('custom-functionality/terminal-helpers')

----- Register Plugins --------------------------------------------------------
require('plugin-configuration')
