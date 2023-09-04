local Job = require 'plenary.job'

local M = {}


M.ruby = function(file_name)
    local ruby_script = "/Users/tgelin01/Projects/xcode.nvim/lua/xcode/scripts/add_file.rb"

    Job:new({
        command = 'ruby',
        args = {
            ruby_script,
            file_name
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
    }):start()
end

M.build = Job:new({
    command = 'xcodebuild',
    args = {
        "-workspace",
        "IosPokedexOld.xcworkspace",
        "-scheme",
        "IosPokedexOld",
        "CODE_SIGN_IDENTITY=\"\"",
        "CODE_SIGNING_REQUIRED=NO",
        "-destination",
        'platform=iOS Simulator,name=iPhone 14 Pro Max',
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
        "gelinger.IosPokedexOld"
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


M.install_on_simulator = Job:new({
    command = 'xcrun',
    args = {
        "simctl",
        "install",
        "booted",
        "~/Library/Developer/Xcode/DerivedData/IosPokedexOld-apeihcrsmltruvbquztmxtetvvjt/Build/Products/Debug-iphonesimulator/IosPokedexOld.app"
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
        "gelinger.IosPokedexOld"
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

return M
