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
            local project_name = vim.fn.fnamemodify(workspace_file, ":t")
            local delimiter = "%."
            local first_item = string.match(project_name, "([^" .. delimiter .. "]+)")

            print(first_item)
            return workspace_folder
        else
            current_dir = vim.fn.fnamemodify(current_dir, ":h")
        end
    until current_dir == "/"
end

M.project_name = function()
    local current_dir = vim.fn.getcwd()

    repeat
        local workspace_file = vim.fn.glob(current_dir .. "/*.xcworkspace")

        if workspace_file ~= "" then
            local project_folder = vim.fn.fnamemodify(workspace_file, ":t")
            local delimiter = "%."
            local project_name = string.match(project_folder, "([^" .. delimiter .. "]+)")

            return project_name
        else
            current_dir = vim.fn.fnamemodify(current_dir, ":h")
        end
    until current_dir == "/"
end

M.project_id = function()
    local pbxproj_list = vim.fn.systemlist("find ./" .. M.project_name() .. ".xcodeproj | grep .pbxproj");
    local pbxproj = pbxproj_list[#pbxproj_list]

    local command = "cat " ..
        pbxproj .. " | grep -m 1 PRODUCT_BUNDLE_IDENTIFIER | grep -o '=.*;' | awk -F= '{print $2}' | tr -d ' ;'"

    local result = vim.fn.systemlist(command)
    local project_id = result[#result]
    print(project_id)
    return project_id
end

return M
