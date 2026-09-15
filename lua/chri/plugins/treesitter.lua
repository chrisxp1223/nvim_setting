local parsers = {
    "json",
    "javascript",
    "typescript",
    "yaml",
    "html",
    "markdown",
    "markdown_inline",
    "bash",
    "lua",
    "vim",
    "gitignore",
    "python",
    "dockerfile",
    "vimdoc",
    "c",
    "make",
}

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local treesitter = require("nvim-treesitter")

        treesitter.setup()
        treesitter.install(parsers)

        require("nvim-ts-autotag").setup()

        local group = vim.api.nvim_create_augroup("chri-treesitter", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)

                if not lang or not vim.treesitter.language.add(lang) then
                    return
                end

                vim.treesitter.start(args.buf, lang)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                local opts = { buffer = args.buf, silent = true }
                vim.keymap.set({ "n", "x" }, "<Tab>", function()
                    vim.treesitter.select("parent")
                end, opts)
                vim.keymap.set("x", "<BS>", function()
                    vim.treesitter.select("child")
                end, opts)
            end,
        })
    end,
}
