require("chri.core")
require("chri.lazy")
require("cscope_wrap").setup()
require("tags_autogen").setup()

require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            "Build/",
            "Conf/",
            "%.map$",
            "%.obj$",
            "%.dep$",
            "%.pdb$",
            "AutoGen%.h$",
            "AutoGen%.c$",
            "%.git/",
            "^tags$", -- ctags 資料庫
            "^cscope%.out$", -- cscope 資料庫本體
            "^cscope%.files$", -- cscope 檔案清單
            "^cscope%.po%.out$", -- cscope 反查索引（若有產生）
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--glob=!Build/**",
            "--glob=!Conf/**",
            "--glob=!**/*.map",
            "--glob=!**/AutoGen.*",
            "--glob=!tags",
            "--glob=!cscope.out",
            "--glob=!cscope.files",
            "--glob=!cscope.po.out",
        },
    },
})

vim.o.splitbelow = true
vim.o.splitright = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(ev)
        vim.keymap.set("n", "q", "<cmd>cclose<CR>", { buffer = ev.buf, silent = true })
    end,
})
