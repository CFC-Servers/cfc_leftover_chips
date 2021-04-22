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

-- Which property should be checked for validity to decide if this E2 has been abandoned
checkProperty = {
    gmod_wire_expression_2: "Founder"
    gmod_wire_hologram: "Founder"
    starfall_processor: "owner"
}

leftovers = {}

onCreate = (ent) ->
    return unless IsValid ent
    return unless leftovers[ent\GetClass!]

    rawset watchedEntities, ent, true

    ent\CallOnRemove "CFC_LeftoverChips_Untrack", ->
        rawset watchedEntities, ent, nil

cleanup = ->
    for leftover in pairs leftovers
        if IsValid leftover
            property = checkProperty[leftover\GetClass!]
            continue if IsValid leftover[property]

        SafeRemoveEntityDelayed leftovers, 0

hook.Add "PlayerDisconnected", "CFC_LeftoverChips_Cleanup", cleanup
