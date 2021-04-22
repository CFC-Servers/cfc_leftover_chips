entsGetAll = ents.GetAll
rawget = rawget
rawset = rawset
pairs = pairs
IsValid = IsValid
SafeRemoveEntityDelayed = SafeRemoveEntityDelayed

leftovers = {
    gmod_wire_expression_2: true
    starfall_processor: true
}

-- Which property should be checked for validity to decide if this E2 has been abandoned
checkProperty = {
    gmod_wire_expression_2: "Founder"
    starfall_processor: "owner"
}

watchedEntities = {}

onCreate = (ent) ->
    return unless IsValid ent
    return unless leftovers[ent\GetClass!]

    watchedEntities[ent] = true

    ent\CallOnRemove "CFC_LeftoverChips_Untrack", ->
        watchedEntities[ent] = nil

cleanup = ->
    for leftover in pairs leftovers
        if IsValid leftover
            property = checkProperty[leftover\GetClass!]
            continue if IsValid leftover[property]

        SafeRemoveEntityDelayed leftovers, 0

hook.Add "PlayerDisconnected", "CFC_LeftoverChips_Cleanup", cleanup
