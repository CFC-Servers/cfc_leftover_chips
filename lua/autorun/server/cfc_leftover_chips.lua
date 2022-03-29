local rawget = rawget
local rawset = rawset
local pairs = pairs
local IsValid = IsValid
local watchedEntities = {
  gmod_wire_expression_2 = true,
  gmod_wire_hologram = true,
  starfall_processor = true
}
local getVar
getVar = function(key)
  return function(e)
    return e[key]
  end
end
local getOwner = {
  gmod_wire_hologram = function(e)
    return e:GetPlayerEnt()
  end,
  gmod_wire_expression_2 = getVar("Founder"),
  starfall_processor = getVar("owner")
}
local leftovers = { }
local onCreate
onCreate = function(ent)
  return timer.Simple(0, function()
    if not (IsValid(ent)) then
      return 
    end
    if not (rawget(watchedEntities, ent:GetClass())) then
      return 
    end
    rawset(leftovers, ent, true)
    return ent:CallOnRemove("CFC_Leftovers_Untrack", function()
      return rawset(leftovers, ent, nil)
    end)
  end)
end
local cleanup
cleanup = function()
  for leftover in pairs(leftovers) do
    local _continue_0 = false
    repeat
      if IsValid(leftover) then
        local getter = rawget(getOwner, leftover:GetClass())
        if not (getter) then
          _continue_0 = true
          break
        end
        if IsValid(getter(leftover)) then
          _continue_0 = true
          break
        end
      end
      SafeRemoveEntityDelayed(leftover, 0)
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
end
hook.Add("OnEntityCreated", "CFC_Leftovers_Track", onCreate)
return hook.Add("PlayerDisconnected", "CFC_Leftovers_Cleanup", function()
  return timer.Simple(1, cleanup)
end)
