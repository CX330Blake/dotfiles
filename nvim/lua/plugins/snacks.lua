return {
    {
        "snacks.nvim",
        opts = {
            notifier = { enabled = false },
            image = {
                ---@class snacks.image.Config
                ---@field enabled? boolean enable image viewer
                ---@field wo? vim.wo|{} options for windows showing the image
                ---@field bo? vim.bo|{} options for the image buffer
                ---@field formats? string[]
                --- Resolves a reference to an image with src in a file (currently markdown only).
                --- Return the absolute path or url to the image.
                --- When `nil`, the path is resolved relative to the file.
                ---@field resolve? fun(file: string, src: string): string?
                ---@field magick? table<string, (string|number)[]>
                {
                    formats = {
                        "png",
                        "jpg",
                        "jpeg",
                        "gif",
                        "bmp",
                        "webp",
                        "tiff",
                        "heic",
                        "avif",
                        "mp4",
                        "mov",
                        "avi",
                        "mkv",
                        "webm",
                        "pdf",
                    },
                    force = false, -- try displaying the image, even if the terminal does not support it
                    doc = {
                        -- enable image viewer for documents
                        -- a treesitter parser must be available for the enabled languages.
                        -- supported language injections: markdown, html
                        enabled = true,
                        -- render the image inline in the buffer
                        -- if your env doesn't support unicode placeholders, this will be disabled
                        -- takes precedence over `opts.float` on supported terminals
                        inline = true,
                        -- render the image in a floating window
                        -- only used if `opts.inline` is disabled
                        float = true,
                        max_width = 80,
                        max_height = 40,
                    },
                    img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
                    -- window options applied to windows displaying image buffers
                    -- an image buffer is a buffer with `filetype=image`
                    wo = {
                        wrap = false,
                        number = false,
                        relativenumber = false,
                        cursorcolumn = false,
                        signcolumn = "no",
                        foldcolumn = "0",
                        list = false,
                        spell = false,
                        statuscolumn = "",
                    },
                    cache = vim.fn.stdpath("cache") .. "/snacks/image",
                    debug = {
                        request = false,
                        convert = false,
                        placement = false,
                    },
                    env = {},
                    magick = {
                        default = { "{src}[0]", "-scale", "1920x1080>" },
                        math = { "-density", 600, "{src}[0]", "-trim" },
                        pdf = { "-density", 300, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
                    },
                },
            },
            dashboard = {
                preset = {
                    pick = function(cmd, opts)
                        return LazyVim.pick(cmd, opts)()
                    end,
                    header = [[


                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 

 ]],
                    ---@type snacks.dashboard.Item[]
                    keys = {
                        {
                            icon = " ",
                            key = "f",
                            desc = "Find File",
                            action = ":lua Snacks.dashboard.pick('files')",
                        },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        {
                            icon = " ",
                            key = "g",
                            desc = "Find Text",
                            action = ":lua Snacks.dashboard.pick('live_grep')",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent Files",
                            action = ":lua Snacks.dashboard.pick('oldfiles')",
                        },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                        },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
                -- You can remove this --
                -- sections = {
                --     { section = "header" },
                --     { section = "keys", gap = 1, padding = 1 },
                --     { section = "startup" },
                --     {
                --         pane = 2,
                --         section = "terminal",
                --         cmd = "ascii-image-converter ~/.config/nvim/img/eagle.jpg -C -c -b --dither",
                --         indent = 0,
                --         height = 50,
                --         padding = 1,
                --     },
                -- },
                -- You can remove this --
            },
        },
    },
}
