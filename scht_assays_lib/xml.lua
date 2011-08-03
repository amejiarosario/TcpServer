-----------------------------------------------------------------------------
--  COPYRIGHT ORTHO CLINICAL DIAGNOSTICS 2011
--              ALL RIGHTS RESERVED
-----------------------------------------------------------------------------
-- xml.lua
-- A simple pure Lua xml reader/writer.
-- Also see www.lua.org/pil/12.1.1.html
-----------------------------------------------------------------------------


-- Create the namespace/module.
local M = {}

-----------------------------------------------------------------------------
-- FUNCTION NAME: table2xml
--    Adapted from http://www.hpelbers.org/lua/print_r by Adrian Mejia (amejia3)
-- Usage example:
--    local xml = require ('xml')
--    print(xml.table2xml(SCH_SAMP_WL_MSG,"SCH_SAMP_WL_MSG"))
-- PURPOSE:
--   Convert an Lua table into XML.
-- PARAMETER LIST:
--   t - lua table.
--   name  - lua table's name.
--   indent - initial identation (don't use it)
-- RETURN VALUES:
--   table - XML.
-----------------------------------------------------------------------------
function M.table2xml (t, name, indent) -- TODO add to namespace/module
  local tableList = {}

  function table_recursion (t, name, indent, full)

  local id = '<'..name..'>'
  local open_tag = indent .. id
  local close_tag = '</'..name..'>'

  local out = {}  -- xml result

  if type(t) == "table" then
    if tableList[t] ~= nil then
      table.insert(out, open_tag .. tableList[t])
    else
        tableList[t]= full and (full .. '.' .. id) or id
        if next(t) then -- Table not empty
          table.insert(out, open_tag .. '')
          for key,value in pairs(t) do
            table.insert(out,table_recursion(value,key,indent .. '  ',tableList[t]))
          end
          table.insert(out,indent .. close_tag)
        else table.insert(out,open_tag .. '') end
      end
  else -- non-table types
      local val = tostring(t)
      table.insert(out, open_tag .. val .. close_tag) -- insert value with its xml open_tags
    end
    return table.concat(out, '\n')
  end

  return table_recursion(t,name or 'Value',indent or '')
end


-----------------------------------------------------------------------------
-- FUNCTION NAME: xml2table
--   From http://lua-users.org/wiki/LuaXml
-- PURPOSE:
--   Convert an XML into Lua table.
-- PARAMETER LIST:
--   s - string xml
-- RETURN VALUES:
--   table - lua table with XML data.
-----------------------------------------------------------------------------
function M.xml2table(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do

  -- patterns http://www.lua.org/pil/20.2.html
  
  ni,j,c,label,xarg, empty = string.find(s, "<(%/?)(%w+)(.-)(%/?)>", i)

  if not ni then break end

  local text = string.sub(s, i, ni-1)
  if not string.find(text, "^%s*$") then
    table.insert(top, text)
  end

  if empty == "/" then  -- empty element tag
    table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
  elseif c == "" then   -- start tag
    top = {label=label, xarg=parseargs(xarg)}
    table.insert(stack, top)   -- new level
  else  -- end tag
    local toclose = table.remove(stack)  -- remove top
    top = stack[#stack]
    if #stack < 1 then
    error("nothing to close with "..label)
    end
    if toclose.label ~= label then
    error("trying to close "..toclose.label.." with "..label)
    end
    table.insert(top, toclose)
  end
  i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
  table.insert(stack[#stack], text)
  end
  if #stack > 1 then
  error("unclosed "..stack[stack.n].label)
  end
  return stack[1]
end

function parseargs(s)
      local arg = {}
      string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
        arg[w] = a
      end)
      return arg
    end

-- return module
return M;

-----------------------------------------------------------------------------
--  REVISION HISTORY
--  $LastChangedDate: 2011-07-07 14:36:15 -0400 (Thu, 07 Jul 2011) $
--  $Revision: 1133 $
--  $LastChangedBy: cthoma54 $
--  $Id: xml.lua 1133 2011-07-07 18:36:15Z cthoma54 $
-----------------------------------------------------------------------------
