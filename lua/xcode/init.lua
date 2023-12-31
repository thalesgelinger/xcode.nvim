local jobs    = require 'xcode.jobs'
local scripts = require 'xcode.scripts'
local utils   = require 'xcode.utils'

local M       = {}

M.add_class   = function()
    vim.ui.input({ prompt = 'Name for new component' }, function(input)
        local file_name = input;
        local t = require('xcode.template')
        local h = string.format(t.h, file_name)
        local m = string.format(t.m, file_name, file_name, file_name)
        local dir = vim.fn.expand('%:h')
        local m_file_path = dir .. "/" .. file_name .. ".m"
        local h_file_path = dir .. "/" .. file_name .. ".h"

        local m_file = io.open(m_file_path, 'w')
        m_file:write(m)
        m_file:close()

        local h_file = io.open(h_file_path, 'w')
        h_file:write(h)
        h_file:close()

        scripts.addFile(m_file_path)
    end)
end

M.add_assets  = function()
    print("ADD ASSETS")
    if vim.bo.filetype == "netrw" then
        local file = vim.fn.expand("<cfile>");
        scripts.addAsset(file)
    end
end

local run     = function()
    jobs.kill_simulator:after(function()
        jobs.build:after(function()
            jobs.install_on_simulator:after(function()
                jobs.run_app:start()
            end)
            jobs.install_on_simulator:start()
        end)
        jobs.build:start()
    end)
    jobs.kill_simulator:start()
end

local runDev  = false;

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("Xcode", { clear = true }),
    pattern = "*.m",
    callback = function()
        if runDev then
            print("Rebuilding")
            run()
        end
    end
})

vim.api.nvim_create_user_command('XcodeDev', function()
    runDev = not runDev;
    if runDev then
        print("Enable dev reload")
        run()
    else
        print("Disable dev reload")
    end
end, {})

vim.api.nvim_create_user_command('XcodeBuild', function()
    print("Building...")
    jobs.build:start()
end, {})

vim.api.nvim_create_user_command('XcodeAddFile', function()
    local path = vim.fn.expand("%")
    scripts.addFile(path)
end, {})

vim.api.nvim_create_user_command('XcodeLog', function()
    local log_file = vim.fn.stdpath('data') .. '/logs.txt'
    vim.cmd(string.format('tabnew %s', log_file))
end, {})



return M
