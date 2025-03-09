return {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
        require("aerial").setup({
            backends = { "lsp", "treesitter", "ctags" }, -- 多種後端，確保 `aerial.nvim` 可用
            layout = {
                max_width = { 50, 0.3 }, -- 最大寬度 40，或視窗 30% 大小
                min_width = 30, -- 最小寬度
                default_direction = "right", -- 預設放右側
            },
            attach_mode = "global", -- 全部 buffer 共用 `aerial`
            filter_kind = { "Class", "Struct", "Function", "Method", "Constructor", "Variable", "Feild", "Enum" },
            highlight_on_hover = true, -- 移動游標時，自動高亮對應符號
            autojump = true, -- 點擊符號時，自動跳轉
            show_guides = false, -- 顯示層級縮排線
            group_kind = true,
            keymaps = {
                ["[a"] = "prev", -- 上一個符號
                ["]a"] = "next", -- 下一個符號
                ["{"] = "prev_up", -- 跳到上一個較高層級
                ["}"] = "next_up", -- 跳到下一個較高層級
            },
            -- 自動開啟 `aerial`
            open_automatic = function(bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 80 -- 只對大於 80 行的文件開啟
            end,
        })

        -- 快捷鍵設定
        vim.api.nvim_set_keymap(
            "n",
            "<F5>",
            ":AerialToggle!<CR>",
            { noremap = true, silent = true, desc = "切換 Aerial" }
        )
        vim.api.nvim_set_keymap(
            "n",
            "[a",
            ":AerialPrev<CR>",
            { noremap = true, silent = true, desc = "上一個符號" }
        )
        vim.api.nvim_set_keymap(
            "n",
            "]a",
            ":AerialNext<CR>",
            { noremap = true, silent = true, desc = "下一個符號" }
        )
    end,
}
