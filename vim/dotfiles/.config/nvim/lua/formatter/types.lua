--[[
Formatter Plugin Type Definitions

This file contains only type definitions for the formatter plugin.
It can be imported without loading the actual plugin code.
--]]

---@class FileContext
---@field filepath string Full file path
---@field filename string Filename with extension
---@field basename string Filename without extension
---@field dirname string Directory path

---@alias PostAction "reload" | "none" | fun(output: string, context: FileContext)

---@class FormatterConfig
---@field command string[] | string | fun(context: FileContext): string? Command to execute or function for built-in formatters
---@field filetypes string[] List of filetypes this formatter supports
---@field success_message string? Custom success message
---@field post_action PostAction? Action to take after formatting (default: "reload")
---@field format_on_save boolean? Enable format on save for this formatter (default: false)

---@class FormatterPluginConfig
---@field keybinding string? Keybinding for manual formatting
---@field formatters table<string, FormatterConfig> Available formatters

-- This file only contains type definitions, no runtime code
return {}
