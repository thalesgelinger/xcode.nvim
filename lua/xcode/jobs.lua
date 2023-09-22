local Job = require 'plenary.job'
local utils = require 'xcode.utils'

local M = {}

local project_name = utils.project_name()
local project_id = utils.project_id()

M.build = Job:new({
    command = 'xcodebuild',
    args = {
        "-workspace",
        project_name .. ".xcworkspace",
        "-scheme",
        project_name,
        "CODE_SIGN_IDENTITY=\"\"",
        "CODE_SIGNING_REQUIRED=NO",
        "-destination",
        'platform=iOS Simulator,name=iPhone 15 Pro Max',
        "build"
    },
    on_stdout = function(_, data)
        print("standard output:", data)
    end,
    on_stderr = function(_, data)
        print("standard error:", data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print('Scripts executed successfully!')
        else
            print('Scripts encountered an error.', return_val)
        end
    end
})


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
    end,
    on_stderr = function(_, data)
        print("Error killing current simulator: ", data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print('Simulator killed')
        else
            print('Scripts kill_simulator encountered an error.', return_val)
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
    command = 'xcrun',
    args = {
        "simctl",
        "install",
        "booted",
        getAppPath()
    },
    on_stdout = function(_, data)
        print("Installing app on simulator: ", data)
    end,
    on_stderr = function(_, data)
        print("Error Installing app on simulator: ", data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print('App Installed on simulator')
        else
            print('Scripts install_on_simulator encountered an error.', return_val)
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
    end,
    on_stderr = function(_, data)
        print("Error Running app on simulator: ", data)
    end,

    on_exit = function(job_id, return_val)
        if return_val == 0 then
            print('App Launched on simulator')
        else
            print('Scripts run_app encountered an error.', return_val)
        end
    end
})


-- M.lsp_compiler_commands = ;
-- xcodebuild clean build -project IosPokedexOld.xcodeproj -scheme IosPokedexOld -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max' COMPILER_INDEX_STORE_ENABLE=NO | xcpretty -r json-compilation-database --output compile_commands.json


return M
