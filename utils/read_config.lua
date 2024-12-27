-- config.lua
local M = {}

-- Function to trim leading and trailing spaces
local function trim(s)
    return s:match("^%s*(.-)%s*$")  -- Remove leading and trailing spaces
end

-- Function to read configuration from a file
function M.read_config(file_path)
    local config = {}
    local file = io.open(file_path, "r")
    if not file then
        error("Could not open file: " .. file_path)
    end

    for line in file:lines() do
        line = trim(line)  -- Trim spaces
        -- Skip empty lines or lines starting with '#'
        if line ~= "" and not line:match("^#") then
            local key, value = line:match("^(%w+)%s*=%s*(.+)$")
            if key and value then
                config[key] = value
            end
        end
    end

    file:close()
    return config
end

-- Return the module table so functions are accessible from outside
return M


