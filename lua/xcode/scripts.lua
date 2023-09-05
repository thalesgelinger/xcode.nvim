require 'xcode.utils'
local Job = require 'plenary.job'

local M = {}

-- local scripts_path = vim.fn.stdpath('data') .. "/lazy/xcode.nvim/lua/xcode/scripts/"
local scripts_path = "/Users/tgelin01/Projects/xcode.nvim/lua/xcode/scripts/"

M.addFile = function(file_name)
    local ruby_script = scripts_path .. "add_file.rb"

    Job:new({
        command = 'ruby',
        args = {
            ruby_script,
            file_name
        },
        on_exit = function(_, return_val)
            if return_val == 0 then
                print('File added to xcodeproj')
            else
                print('Error adding file to xcodeproj', return_val)
            end
        end
    }):start()
end

-- Define a Lua function to find the Xcode workspace folder
local find_xcode_workspace = function()
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

Logs = {}

M.addAsset = function(asset_name)
    local parent_dir = vim.fn.expand('%')
    table.insert(Logs, parent_dir)
    local ruby_script = scripts_path .. "add_asset.rb"

    local xcode_workspace = find_xcode_workspace()
    if xcode_workspace ~= "Xcode workspace not found" then
        print("Xcode workspace folder: " .. xcode_workspace)
    else
        print("Xcode workspace not found.")
        return
    end


    Job:new({
        command = 'ruby',
        args = {
            ruby_script,
            parent_dir .. "/" .. asset_name,
        },
        cwd = xcode_workspace,
        on_stdout = function(_, data)
            table.insert(Logs, data)
            print("standard output:", data)
        end,
        on_stderr = function(_, data)
            table.insert(Logs, data)
            print("standard error:", data)
        end,
        on_exit = function(_, return_val)
            if return_val == 0 then
                print('Asset added to project')
                P(Logs)
            else
                print('Error adding asset to project', return_val)
            end
        end
    }):start()
end


return M
