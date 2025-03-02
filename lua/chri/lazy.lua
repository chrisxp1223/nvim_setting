local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fh.system({
      "git",
      "clone",
      "--filter-blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({ { import = "chri.plugins" }, { import = "chri.plugins.lsp"} }, {
    checker = {
      enable = true,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
  })
