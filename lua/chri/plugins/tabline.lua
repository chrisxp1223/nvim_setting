return {
    "kdheepak/tabline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("tabline").setup({
            enable = true, -- 啟用 tabline
            options = {
                show_filename_only = false,
                show_tabs_always = true,
                separator = "▌",
            },
        })
        vim.cmd("set guioptions-=e") -- 隱藏默認 tabline
        vim.cmd("set showtabline=2") -- 強制顯示 tabline
    end,
}
