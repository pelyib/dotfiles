local success, alpha = pcall(require, "alpha")
if success == false then
    return
end

local success, dashboard = pcall(require, "alpha.themes.dashboard")
if success == false then
  return
end

local headers = {
    {
"      ╔═══════════════════════════════════════════════════════════════════════════════╗",
"    ╔═╣                                       ,pm        mq.                          ╠═╗",
"   ╔╩═╣  `7MM\"\"\"Yp,   .g8\"\"8q.  MMP\"\"MM\"\"YMM 6M            Mb `7MMF'`7MMM.     ,MMF'  ╠═╩╗",
"  ╔╩══╣    MM    Yb .dP'    `YM.P'   MM   `7 MM            MM   MM    MMMb    dPMM    ╠══╩╗",
" ╔╩═══╣    MM    dP dM'      `MM     MM      M9 `7M'   `MF'YM   MM    M YM   ,M MM    ╠═══╩╗",
"╔╩════╣    MM\"\"\"bg. MM        MM     MM   _.d\"'   VA   ,V  `\"b._MM    M  Mb  M' MM    ╠════╩╗",
"╚╦════╣    MM    `Y MM.      ,MP     MM   `\"bp.    VA ,V   ,qd\"'MM    M  YM.P'  MM    ╠════╦╝",
" ╚╦═══╣    MM    ,9 `Mb.    ,dP'     MM      Mb     VVV    6M   MM    M  `YM'   MM    ╠═══╦╝",
"  ╚╦══╣   .JMMmmmd9    `\"bmmd\"'     .JMML.    MM     W     MM .JMML..JML. `'  .JMML.  ╠══╦╝",
"   ╚╦═╣                                       YM           M9                         ╠═╦╝",
"    ╚═╣                                        `bm        md'                         ╠═╝",
"      ╚═══════════════════════════════════════════════════════════════════════════════╝"
    },
    {
"",
"                              ███╗       ███╗",
"                             ██╔═╝       ╚═██╗",
" ██████╗  ██████╗ ████████╗  █╔╝ ██╗   ██╗ ╚█║  ██╗███╗   ███╗",
" ██╔══██╗██╔═══██╗╚══██╔══╝  █║  ██║   ██║  █║  ██║████╗ ████║",
" ██████╔╝██║   ██║   ██║    ██║  ██║   ██║  ██╗ ██║██╔████╔██║",
" ██╔══██╗██║   ██║   ██║    ██║  ██║   ██║  ██║ ██║██║╚██╔╝██║",
" ██████╔╝╚██████╔╝   ██║    ╚█║  ╚██╗ ██╔╝  █╔╝ ██║██║ ╚═╝ ██║",
" ╚═════╝  ╚═════╝    ╚═╝     █║   ╚████╔╝   █║  ╚═╝╚═╝     ╚═╝",
"                             ██╗   ╚═══╝   ██║",
"                             ╚███╗       ███╔╝",
"                              ╚══╝       ╚══╝",
"",
    },
    {
"",
" dP                  dP     .d88P          d88b.   oo            ",
" 88                  88     8:                :8                 ",
" 88d888b. .d8888b. d8888P .oY8.   dP   .dP   .8Yo. dP 88d8b.d8b. ",
" 88'  `88 88'  `88   88     d8    88   d8'    8b   88 88'`88'`88 ",
" 88.  .88 88.  .88   88     8:    88 .88'     :8   88 88  88  88 ",
" 88Y8888' `88888P'   dP     `Y88b 8888P'   Y88P'   dP dP  dP  dP ",
"",
    }
-- TODO: add more headers
--[[
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗ | ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║ | ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║ | ██║██║ | ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║ | ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}
--]]

--[[
========
          )                      (       *
   (   ( /(   *   )              )\ )  (  `
 ( )\  )\())` )  /(     )       (()/(  )\))(
 )((_)((_)\  ( )(_))   /((       /(_))((_)()\
((_)_   ((_)(_(_()) __(_))\ __  (_))  (_()((_)
 | _ ) / _ \|_   _|/ /_)((_)\ \ |_ _| |  \/  |
 | _ \| (_) | | |_| | \ V /  | |_| |  | |\/| |
 |___/ \___/  |_| | |  \_/   | ||___| |_|  |_|
                   \_\      /_/

=========

                                     ,pm        mq.                        
`7MM"""Yp,   .g8""8q.  MMP""MM""YMM 6M            Mb `7MMF'`7MMM.     ,MMF'
  MM    Yb .dP'    `YM.P'   MM   `7 MM            MM   MM    MMMb    dPMM  
  MM    dP dM'      `MM     MM      M9 `7M'   `MF'YM   MM    M YM   ,M MM  
  MM"""bg. MM        MM     MM   _.d"'   VA   ,V  `"b._MM    M  Mb  M' MM  
  MM    `Y MM.      ,MP     MM   `"bp.    VA ,V   ,qd"'MM    M  YM.P'  MM  
  MM    ,9 `Mb.    ,dP'     MM      Mb     VVV    6M   MM    M  `YM'   MM  
.JMMmmmd9    `"bmmd"'     .JMML.    MM      W     MM .JMML..JML. `'  .JMML.
                                    YM            M9                       
                                     `bm        md'                        

=======

  ____   ___ _____ __     __  ___ __  __ 
 | __ ) / _ \_   _/ /_   _\ \|_ _|  \/  |
 |  _ \| | | || || |\ \ / /| || || |\/| |
 | |_) | |_| || < <  \ V /  > > || |  | |
 |____/ \___/ |_|| |  \_/  | |___|_|  |_|
                  \_\     /_/            

=======

______  _____ _____ __   __  ________  ___
| ___ \|  _  |_   _/ /   \ \|_   _|  \/  |
| |_/ /| | | | | || |_   _| | | | | .  . |
| ___ \| | | | | / /\ \ / /\ \| | | |\/| |
| |_/ /\ \_/ / | \ \ \ V / / /| |_| |  | |
\____/  \___/  \_/| | \_/ | |\___/\_|  |_/
                   \_\   /_/              

==========


██████╗  ██████╗ ████████╗██╗   ██╗██╗███╗   ███╗
██╔══██╗██╔═══██╗╚══██╔══╝██║   ██║██║████╗ ████║
██████╔╝██║   ██║   ██║   ██║   ██║██║██╔████╔██║
██╔══██╗██║   ██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║
██████╔╝╚██████╔╝   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚═════╝  ╚═════╝    ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝


========

dP                  dP     .d88P          d88b.   oo            
88                  88     8:                :8                 
88d888b. .d8888b. d8888P .oY8.   dP   .dP   .8Yo. dP 88d8b.d8b. 
88'  `88 88'  `88   88     d8    88   d8'    8b   88 88'`88'`88 
88.  .88 88.  .88   88     8:    88 .88'     :8   88 88  88  88 
88Y8888' `88888P'   dP     `Y88b 8888P'   Y88P'   dP dP  dP  dP


--]]
}

-- https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1924014
function col(strlist, opts)
  -- strlist is a TABLE of TABLES, representing columns of text
  -- opts is a text display option

  -- column spacing
  local padding = 3
  -- fill lines up to the maximim length with 'fillchar'
  local fillchar = ' '
  -- columns padding char (for testing)
  local padchar = ' '
  local column_delimiter = '|'
  local bottom_delimiter = '-'

  -- define maximum string length in a table
  local maxlen = function(str)
    local max = 0
    for i in pairs(str) do
      if #str[i] > max then
        max = #str[i]
      end
    end
    return max
  end

  -- add as much right-padding to align the text block
  local pad = function(str, max)
    local strlist = {}
    for i in pairs(str) do
      if #str[i] < max then
        local newstr = str[i] .. string.rep(fillchar, max-#str[i])
        table.insert(strlist, newstr .. string.rep(padchar, padding) .. column_delimiter)
      else
        table.insert(strlist, str[i] .. string.rep(padchar, padding) .. column_delimiter)
      end
    end
    return strlist
  end

  -- this is a table for text strings
  local values = {}
  -- process all the lines
  for i=1,maxlen(strlist) do
    local str = ''
    -- process all the columns but last, because we dont wand extra padding
    -- after last column
    for column=1,#strlist-1 do
      local maxstr = maxlen(strlist[column])
      local padded = pad(strlist[column], maxstr)
      if strlist[column][i] == nil then
        str = str .. string.rep(fillchar, maxstr) .. string.rep(padchar, padding)
      else
        str = str .. padded[i] .. string.rep(padchar, padding)
      end
    end

    -- lets process the last column, no extra padding
    do
      local maxstr = maxlen(strlist[#strlist])
      local padded = pad(strlist[#strlist], maxstr)
      if strlist[#strlist][i] == nil then
        str = str .. string.rep(fillchar, maxlen(strlist[#strlist]))
      else
        str = str .. padded[i]
      end
    end

    -- insert result into output table
    table.insert(values, { type = "text", val = str, opts = opts })
  end

  table.insert(values, { type = "text", val ={string.rep(bottom_delimiter, vim.api.nvim_win_get_width(0))}, opts = opts})
  return values
end

local cheat_sheet = {
    layout = {
        {
            type = "text",
            val = headers[math.random(#headers)],
            opts = {
                position = "center",
            }
        },
        {
            type = "group",
            val = col({}),
            opts = {}
        },
        {
            type = "group",
            val = col({
                {
                    "[n] - Normal mode | [v] - Visual mode"
                }
            }),
            opts = {}
        },
        {
            type = "group",
            val = col({
                {
                    "                   << toggleterm.nvim  >>",
                    "[n]<leader>t       Open default shell in floating terminal",
                    "[n]<leader>git     Open gitui in floating terminal",
                    "   q               Close gitui window",
                },
                {
                    "       << VIM >>",
                    "[n]i  Switch to insert mode",
                    "",
                    ""
                },
                {
                    " << LSP >>",
                    "[n]gr  ",
                    "[n]gi  ",
                    "[n]gd  ",
                }
            }),
            opts = {}
        },
        {
            type = "group",
            val = col({
                {
                    "                       << // Comment.nvim >> ",
                    "[n]gcc                 Toggles the current line using linewise comment",
                    "[n]gbc                 Toggles the current line using blockwise comment",
                    "[n][count]gcc          Toggles the number of line given as a prefix-count using linewisei",
                    "[n][count]gbc          Toggles the number of line given as a prefix-count using blockwisei",
                    "[n]gc[count]{motion}   (Op-pending) Toggles the region using linewise comment",
                    "[n]gb[count]{motion}   (Op-pending) Toggles the region using blockwise comment",
                    "[v]gc                  Toggles the region using linewise comment",
                    "[v]gb                  Toggles the region using blockwise comment",
                },
                {
                    "               << Telescope >>",
                    "[n]<leader>ff  Open file finder",
                    "[n]<leader>fg  Open live grep",
                    "[n]<leader>fG  Open live grep with args support",
                    "[n]gfh         Show GIT history of the file",
                    "[n]gh          Show GIT history of the repo",
                },
            }),
            opts = {}
        },
        {
            type = "group",
            val = col({
                {
                    "       << Neo-tree >>",
                    "[n]fb  Show neo-tree window",
                    "q      Close neo-tree window"
                },
                {
                    "       << Arial >>",
                    "[n]ar  Toggle Arial window"
                },
                {
                    "       << git-blame >> ",
                    "[n]gb  Toggle inline blame info"
                }
            }),
            opts = {}
        },
        {
            type = "group",
            val = col({
                {
                    "       << nvim-neoclip >>",
                    "[n]cp  Open clipboard list",
                    ""
                },
                {
                    "    << nvim-ufo >>   ",
                    "[n]zc  Close block",
                    "[n]zo  Open block"
                },
                {
                    " << ??? >> "
                }
            }),
            opts = {}
        }
    },
    opts = {
        keymap = {
            press = nil
        }
    }
}

vim.keymap.set('n', '<c-h>', function () alpha.start(false, cheat_sheet) end)
dashboard.section.header.val = headers[math.random(#headers)]
alpha.setup(dashboard.opts)
