return {
    "obsidian-nvim/obsidian.nvim",
    lazy = false,
    version = "*", -- use latest release, remove to use latest commit
    ft = "markdown",
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
        legacy_commands = false, -- this will be removed in the next major release
        workspaces = {
            {
                name = "Hacking",
                path = "~/Obsidian/HackingPlaybook/",
            },
        },
    },
}
