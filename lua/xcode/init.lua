-- local Job = require 'plenary.job'
local scripts = require('xcode.scripts')

local M = {}


local function ruby(script)
    local command = "ruby -e " .. vim.fn.shellescape(script)
    local output = vim.fn.system(command)
    print(output)
end

M.add_class = function(file_name)
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

    local s = require('xcode.scripts')
    print(s.addFile)
    print(m_file_path)
    local addFileCmd = string.format(s.addFile, m_file_path)
    ruby(addFileCmd)
end


M.dev = function()
    vim.cmd(scripts.dev)
end

M.run = function()
    vim.cmd(scripts.run)
end

M.build = function()
    vim.cmd(scripts.build)



    -- job:new({
    --     command = "bash",
    --     args = { "/users/tgelin01/projects/xcode.nvim/lua/xcode/scripts/dev.sh" },
    --     cwd = vim.fn.getcwd(),
    --     -- env = { ['a'] = 'b' },
    --     on_stdout = function(_, data)
    --         -- handle standard output data here
    --         print("standard output:", data)
    --     end,
    --     on_exit = function(j, return_val)
    --         print(return_val)
    --         print(j:result())
    --     end,
    -- }):start()
end

return M
