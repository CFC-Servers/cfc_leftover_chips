rawget = rawget
rawset = rawset
pairs = pairs
IsValid = IsValid

-- Which classes do we want to insist on destroying
watchedEntities = {
    gmod_wire_expression_2: true
    gmod_wire_hologram: true
    starfall_processor: true
}

getVar = (key) -> (e) -> e[key]

-- Functions to return owners for each class
getOwner = {
    gmod_wire_hologram: (e) -> e\GetPlayerEnt!
    gmod_wire_expression_2: getVar "Founder"
    starfall_processor: getVar "owner"
}

leftovers = {}

onCreate = (ent) ->
    timer.Simple 0, ->
        return unless IsValid ent
        return unless rawget watchedEntities, ent\GetClass!

        rawset leftovers, ent, true

        ent\CallOnRemove "CFC_Leftovers_Untrack", ->
            rawset leftovers, ent, nil

cleanup = ->
    for leftover in pairs leftovers
        if IsValid leftover
            getter = rawget getOwner, leftover\GetClass!
            continue unless getter
            continue if IsValid getter leftover

        SafeRemoveEntityDelayed leftover, 0

hook.Add "OnEntityCreated", "CFC_Leftovers_Track", onCreate
hook.Add "PlayerDisconnected", "CFC_Leftovers_Cleanup", -> timer.Simple 1, cleanup
