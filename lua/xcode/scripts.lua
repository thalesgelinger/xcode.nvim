local Job = require 'plenary.job'
local utils = require 'xcode.utils'

local M = {}

--change this path to project path when changing scripts
local scripts_path = vim.fn.stdpath('data') .. "/lazy/xcode.nvim/lua/xcode/scripts/"
-- local scripts_path = "/Users/tgelin01/Projects/xcode.nvim/lua/xcode/scripts/"

-- Function to append a message to the log file
local function log(message)
    local file = io.open(log_file, 'a')
    if file then
        file:write(message .. '\n')
        file:close()
    end
end


M.addFile = function(file_name)
    local ruby_script = scripts_path .. "add_file.rb"
    local xcode_workspace = utils.find_xcode_workspace()
    print("WOKSPACE: " .. xcode_workspace);

    Job:new({
        command = 'ruby',
        args = {
            ruby_script,
            file_name
        },
        cwd = xcode_workspace,
        on_exit = function(_, return_val)
            if return_val == 0 then
                print('File added to xcodeproj')
            else
                print('Error adding file to xcodeproj', return_val)
            end
        end
    }):start()
end

M.addAsset = function(asset_name)
    local parent_dir = vim.fn.expand('%')
    local ruby_script = scripts_path .. "add_asset.rb"

    local xcode_workspace = utils.find_xcode_workspace()
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
            print("standard output:", data)
        end,
        on_stderr = function(_, data)
            print("standard error:", data)
        end,
        on_exit = function(_, return_val)
            if return_val == 0 then
                print('Asset added to project')
            else
                print('Error adding asset to project', return_val)
            end
        end
    }):start()
end


return M
