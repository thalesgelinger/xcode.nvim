local Job = require 'plenary.job'
local utils = require 'xcode.utils'

local M = {}

local project_name = utils.project_name()
local project_id = utils.project_id()

M.build = Job:new({
    command = 'xcodebuild',
    args = {
        "clean",
        "build",
        "-workspace",
        project_name .. ".xcworkspace",
        "-scheme",
        project_name,
        "CODE_SIGN_IDENTITY=\"\"",
        "CODE_SIGNING_REQUIRED=NO",
        "-sdk",
        "iphonesimulator",
        "COMPILER_INDEX_STORE_ENABLE=NO",
    },
    on_stdout = function(_, data)
        print("Xcodebuild log: ", data)
        utils.log("Xcodebuild log: " .. data)
    end,
    on_stderr = function(_, data)
        print("Xcodebuild error:", data)
        utils.log("Xcodebuild error:" .. data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print("Xcodebuild executed successfully!")
            utils.log("Xcodebuild executed successfully!")
        else
            print("Xcodebuild encountered an error: ", return_val)
            utils.log("Xcodebuild encountered an error: " .. return_val)
        end
    end
})

-- M.build_lsp_cmds = Job:new({
--     command = 'xcpretty',
--     args = {
--         "-r",
--         "json-compilation-database",
--         "--output",
--         "compile_commands.json"
--     },
--
--     on_stdout = function(_, data)
--         print("Xcode lsp log: ", data)
--         utils.log("Xcode lsp log: " .. data)
--     end,
--     on_stderr = function(_, data)
--         print("Xcode lsp error:", data)
--         utils.log("Xcode lsp error:" .. data)
--     end,
--
--     on_exit = function(job_id, return_val)
--         if return_val == 0 then
--             print("Xcode lsp executed successfully!")
--             utils.log("Xcode lsp executed successfully!")
--         else
--             print("Xcode lsp encountered an error: ", return_val)
--             utils.log("Xcode lsp encountered an error: " .. return_val)
--         end
--     end
-- })



M.kill_simulator = Job:new({
    command = 'xcrun',
    args = {
        "simctl",
        "terminate",
        "booted",
        project_id
    },
    on_stdout = function(_, data)
        print("Killing current simulator: ", data)
        utils.log("Killing current simulator: " .. data)
    end,
    on_stderr = function(_, data)
        print("Error killing current simulator: ", data)
        utils.log("Error killing current simulator: " .. data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print('Simulator killed')
            utils.log('Simulator killed')
        else
            print('Scripts kill_simulator encountered an error.', return_val)
            utils.log('Scripts kill_simulator encountered an error.' .. return_val)
        end
    end
})

local function getAppPath()
    local command =
        "find ~/Library/Developer/Xcode/DerivedData -name " .. project_name .. ".app | tac | grep -m 1 iphonesimulator"
    local result = vim.fn.systemlist(command)
    local path = result[#result]
    return path
end

M.install_on_simulator = Job:new({
    --xcrun simctl install booted
    command = 'xcrun',
    args = {
        "simctl",
        "install",
        "booted",
        getAppPath()
    },
    on_stdout = function(_, data)
        print("Installing app on simulator: ", data)
        utils.log("Installing app on simulator: " .. data)
    end,
    on_stderr = function(_, data)
        print("Error Installing app on simulator: ", data)
        utils.log("Error Installing app on simulator: " .. data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print('App Installed on simulator')
            utils.log('App Installed on simulator')
        else
            print('Scripts install_on_simulator encountered an error.', return_val)
            utils.log('Scripts install_on_simulator encountered an error.' .. return_val)
        end
    end
})


M.run_app = Job:new({
    command = 'xcrun',
    args = {
        "simctl",
        "launch",
        "booted",
        project_id
    },
    on_stdout = function(_, data)
        print("Running app on simulator: ", data)
        utils.log("Running app on simulator: " .. data)
    end,
    on_stderr = function(_, data)
        print("Error Running app on simulator: ", data)
        utils.log("Error Running app on simulator: " .. data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print('App Launched on simulator')
            utils.log('App Launched on simulator')
        else
            print('Scripts run_app encountered an error.', return_val)
            utils.log('Scripts run_app encountered an error.' .. return_val)
        end
    end
})


return M
