local M = {}

-- 手動維護您實際在用的專案樹根目錄清單
local known_roots = {
    "/home/dogfood/Firmware_Dev/StxKrkGpt/Gorgon/Gorgon_1002d",
    "/home/dogfood/Firmware_Dev/coreboot_upstream",
    "/home/dogfood/Firmware_Dev/StxKrkGpt/Gorgon/FQJB/FQJB_v011",
}

local function project_root()
    local file = vim.fn.expand("%:p")
    for _, root in ipairs(known_roots) do
        if file:sub(1, #root) == root then
            return root
        end
    end
    return nil
end

function M.refresh()
    local root = project_root()
    if not root then
        vim.notify("File not under any known project root — skipping", vim.log.levels.WARN)
        return
    end
    vim.notify("Refreshing tags/cscope for " .. root, vim.log.levels.INFO)
    vim.system({
        "bash",
        "-c",
        string.format(
            "cd %s && timeout 180 find . -path './Build' -prune -o -path './Conf' -prune -o "
                .. "\\( -name '*.c' -o -name '*.h' \\) -print > cscope.files && "
                .. "cscope -Rb -i cscope.files && "
                .. "ctags -R --exclude=Build --exclude=Conf --exclude=.git .",
            vim.fn.shellescape(root)
        ),
    }, { text = true }, function(obj)
        vim.schedule(function()
            if obj.code == 0 then
                vim.notify("tags/cscope refreshed: " .. root, vim.log.levels.INFO)
            else
                vim.notify("tags refresh failed or timed out: " .. (obj.stderr or ""), vim.log.levels.ERROR)
            end
        end)
    end)
end

local function build_tags_for(root)
    vim.notify("Building tags/cscope for " .. root, vim.log.levels.INFO)
    vim.system({
        "bash",
        "-c",
        string.format(
            "cd %s && find . -path './Build' -prune -o -path './Conf' -prune -o "
                .. "\\( -name '*.c' -o -name '*.h' \\) -print > cscope.files && "
                .. "cscope -Rb -i cscope.files && "
                .. "ctags -R --exclude=Build --exclude=Conf --exclude=.git . && "
                .. "echo done",
            vim.fn.shellescape(root)
        ),
    }, { text = true }, function(obj)
        vim.schedule(function()
            if obj.code == 0 then
                vim.notify("tags/cscope built: " .. root, vim.log.levels.INFO)
            else
                vim.notify("build failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
            end
        end)
    end)
end

function M.build_here()
    local cwd = vim.fn.expand("%:p:h")
    local git_root =
        vim.fn.systemlist("timeout 3 git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --show-toplevel 2>/dev/null")[1]
    local default = (git_root and git_root ~= "") and git_root or cwd
    local root = vim.fn.input("Build tags/cscope for root: ", default, "dir")
    if root ~= "" then
        build_tags_for(root)
    end
end

function M.setup()
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
        callback = function()
            local root = project_root()
            if not root then
                return
            end
            local marker = root .. "/.tags_generated"
            if vim.fn.filereadable(marker) == 0 then
                M.refresh()
                vim.fn.writefile({}, marker)
            end
        end,
    })
    vim.api.nvim_create_user_command("TagsRefresh", M.refresh, {})

    -- 新增：手動熱鍵，隨時可對目前檔案所在的樹重建 tags/cscope
    vim.keymap.set("n", "<leader>tb", function()
        M.build_here()
    end, { desc = "Build tags/cscope for project root" })
    vim.api.nvim_create_user_command("TagsBuild", M.build_here, {})
end

local function build_tags_for(root)
    vim.notify("Building tags/cscope for " .. root, vim.log.levels.INFO)
    vim.system({
        "bash",
        "-c",
        string.format(
            "cd %s && find . -path './Build' -prune -o -path './Conf' -prune -o "
                .. "\\( -name '*.c' -o -name '*.h' \\) -print > cscope.files && "
                .. "cscope -Rb -i cscope.files && "
                .. "ctags -R --exclude=Build --exclude=Conf --exclude=.git . && "
                .. "echo done",
            vim.fn.shellescape(root)
        ),
    }, { text = true }, function(obj)
        vim.schedule(function()
            if obj.code == 0 then
                vim.notify("tags/cscope built: " .. root, vim.log.levels.INFO)
            else
                vim.notify("build failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
            end
        end)
    end)
end

function M.build_here()
    local cwd = vim.fn.expand("%:p:h")
    local git_root =
        vim.fn.systemlist("timeout 3 git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --show-toplevel 2>/dev/null")[1]
    local default = (git_root and git_root ~= "") and git_root or cwd
    local root = vim.fn.input("Build tags/cscope for root: ", default, "dir")
    if root ~= "" then
        build_tags_for(root)
    end
end

return M
