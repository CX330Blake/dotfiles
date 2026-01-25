return {
    {
        "snacks.nvim",
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            explorer = {},
            indent = { enabled = false },
            notifier = { enabled = false },
            image = {
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
                    -- Set to `true`, to conceal the image text when rendering inline.
                    -- (experimental)
                    conceal = false,
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
                ---@class snacks.image.convert.Config
                convert = {
                    notify = true, -- show a notification on error
                    math = {
                        font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
                        -- for latex documents, the doc packages are included automatically,
                        -- but you can add more packages here. Useful for markdown documents.
                        packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
                    },
                    ---@type snacks.image.args
                    mermaid = function()
                        local theme = vim.o.background == "light" and "neutral" or "dark"
                        return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
                    end,
                    ---@type table<string,snacks.image.args>
                    magick = {
                        default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
                        vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
                        math = { "-density", 192, "{src}[0]", "-trim" },
                        pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
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
