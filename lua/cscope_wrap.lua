-- ~/.config/nvim/lua/cscope_wrap.lua
local M = {}

local query_names = {
    [0] = "symbol",
    [1] = "definition",
    [2] = "callers",
    [3] = "callees",
    [4] = "text",
    [6] = "egrep",
    [7] = "file",
    [8] = "includers",
}

function M.find(query_type, symbol)
    symbol = symbol or vim.fn.expand("<cword>")
    if symbol == "" then
        vim.notify("No symbol under cursor", vim.log.levels.WARN)
        return
    end

    local cmd = string.format("cscope -d -L%d '%s'", query_type, symbol)
    local output = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 or #output == 0 then
        vim.notify(
            string.format("cscope: no results for '%s' (%s)", symbol, query_names[query_type]),
            vim.log.levels.INFO
        )
        return
    end

    local items = {}
    for _, line in ipairs(output) do
        local file, func, lnum, text = line:match("^(%S+)%s+(%S+)%s+(%d+)%s+(.*)$")
        if file then
            table.insert(items, {
                filename = file,
                lnum = tonumber(lnum),
                text = string.format("[%s] %s", func, text),
            })
        end
    end

    if #items == 0 then
        vim.notify("cscope: results found but failed to parse", vim.log.levels.WARN)
        return
    end

    vim.fn.setqflist(items)
    vim.cmd("botright copen 15")
end

function M.setup()
    local map = vim.keymap.set
    map("n", "<leader>cs", function()
        M.find(0)
    end, { desc = "cscope: find symbol" })
    map("n", "<leader>cg", function()
        M.find(1)
    end, { desc = "cscope: find definition" })
    map("n", "<leader>cc", function()
        M.find(2)
    end, { desc = "cscope: find callers" })
    map("n", "<leader>cd", function()
        M.find(3)
    end, { desc = "cscope: find callees" })
    map("n", "<leader>ct", function()
        M.find(4)
    end, { desc = "cscope: find text" })
    map("n", "<leader>ce", function()
        M.find(6)
    end, { desc = "cscope: egrep pattern" })
    map("n", "<leader>cf", function()
        M.find(7)
    end, { desc = "cscope: find file" })
    map("n", "<leader>ci", function()
        M.find(8)
    end, { desc = "cscope: find includers" })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(ev)
        vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = ev.buf, silent = true, noremap = true })
        vim.keymap.set("n", "q", "<cmd>cclose<CR>", { buffer = ev.buf, silent = true })
    end,
})

return M
