# Xcode neovim

A basic setup for ios development with neovim


Disclaimer: this tool is in progress while i'm learning objective-c, so i'm adding features according to my needs, so this works only for objective-c for now, but in the future, when i start learning swift, i intend to make it works with it as well

PS: this doens't replace xcode at all, it's just for fun and being able to do much of dev stuff only with neovim


## Instalation

Lazy

```
{
    "thalesgelinger/xcode.nvim",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim'
    }
}

```

## Disclaimer

To make the obj libraries be recognized with lsp, we need to run a command, i'm trying to add it automaticaly to this plugin, but for now you need to run this command


```
 xcodebuild clean build -workspace MyProject.xcworkspace -scheme MyProject CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator COMPILER_INDEX_STORE_ENABLE=NO | xcpretty -r json-compilation-database --output compile_commands.json
```

## Features
- Add new file
- Add asset reference
- Build project
- Rebuild on save for dev environment


### Add new file

This one works inside of a file, when you run it, it opens a floating window asking for the new component name and add it to the project with the .m and .h files

```
:lua require("xcode").add_class()

```

### Add asset reference

When in netrw, with files that already exists you can use visual mode in the file, you can hit the keybind to add it the file reference, this is an example that you can remap

```
vim.api.nvim_set_keymap('v', '<leader>xf', [[:lua require("xcode").add_assets()<CR>]], { noremap = true, silent = true })
```

### Build project
Command to build the project

```
:XcodeBuild
```

### Rebuild on save for dev environment
Command to toggle dev funvtion, that will rebuild the project every time a .m file is saved

```
:XcodeDev
```
