local function root()
  return vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1])
end

local config = {
    --[[ cmd = {"C:\\Users\\'Beilong Tang'\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\bin\\jdtls"}, ]]
    cmd = {"C:\\Users\\Beilong Tang\\AppData\\Local\\nvim-data\\mason\\bin\\jdtls"},
    root_dir = root
}


return config
