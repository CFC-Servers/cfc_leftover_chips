rawget = rawget
rawset = rawset
pairs = pairs
IsValid = IsValid
SafeRemoveEntityDelayed = SafeRemoveEntityDelayed

-- Which classes do we want to insist on destroying
watchedEntities = {
    gmod_wire_expression_2: true
    gmod_wire_hologram: true
    starfall_processor: true
}

getVar = (key) -> (e) -> e[key]

-- Which property should be checked for validity to decide if this E2 has been abandoned
getters = {
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
hook.Add "OnEntityCreated", "CFC_Leftovers_Track", onCreate

cleanup = ->
    for leftover in pairs leftovers
        if IsValid leftover
            getter = rawget getters, leftover\GetClass!
            continue unless getter

            continue if IsValid getter leftover

        SafeRemoveEntityDelayed leftover, 0
hook.Add "PlayerDisconnected", "CFC_Leftovers_Cleanup", cleanup
