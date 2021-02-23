-- ===============================================
-- C/C++/Objective-C LANGUAGE SERVER CONFIGURATION
-- ===============================================
-- Created by datwaft <github.com/datwaft>

local prerequire = require'utils.prerequire'
local lspconfig = prerequire'lspconfig'
if not lspconfig then return end

lspconfig.ccls.setup{}
