local M = {}

function P(v)
    print(vim.inspect(v))
end

M.find_xcode_workspace = function()
    local current_dir = vim.fn.getcwd()

    repeat
        local workspace_file = vim.fn.glob(current_dir .. "/*.xcworkspace")

        if workspace_file ~= "" then
            local workspace_folder = vim.fn.fnamemodify(workspace_file, ":h")
            return workspace_folder
        else
            current_dir = vim.fn.fnamemodify(current_dir, ":h")
        end
    until current_dir == "/"
end

return M
