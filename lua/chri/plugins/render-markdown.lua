return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
        -- 標題階層顏色
        heading = {
            enabled = true,
            sign = true,
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        -- code block 渲染
        code = {
            enabled = true,
            sign = true,
            style = "full", -- "full" | "normal" | "language" | "none"
            border = "thin",
        },
        -- checkbox 渲染
        checkbox = {
            enabled = true,
            unchecked = { icon = "󰄱 " },
            checked   = { icon = "󰱒 " },
        },
        -- bullet list
        bullet = {
            enabled = true,
            icons = { "●", "○", "◆", "◇" },
        },
    },
}
