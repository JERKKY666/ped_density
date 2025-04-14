CreateThread(function()
    while true do
        -- Set densities (20%)
        SetPedDensityMultiplierThisFrame(0.2)
        SetScenarioPedDensityMultiplierThisFrame(0.2, 0.2)
        SetVehicleDensityMultiplierThisFrame(0.2)
        SetRandomVehicleDensityMultiplierThisFrame(0.2)
        SetParkedVehicleDensityMultiplierThisFrame(0.2)
        SetScenarioTypeEnabled("WORLD_VEHICLE_PARK_PARALLEL", true)
        SetScenarioTypeEnabled("WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN", true)
        
        -- Make peds ignore players when shooting
        SetPedScreamWhenShot(PlayerPedId(), true)
        SetPedCanRagdollFromPlayerImpact(PlayerPedId(), true)
        
        -- Set relationship groups (make peds scared, not hostile)
        SetRelationshipBetweenGroups(1, GetHashKey("CIVMALE"), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(1, GetHashKey("CIVFEMALE"), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(1, GetHashKey("SECURITY_GUARD"), GetHashKey("PLAYER"))
        
        Wait(0) -- Must run every frame to consistently apply
    end
end)

CreateThread(function()
    while true do
        -- Force peds to flee if player is shooting
        local playerPed = PlayerPedId()
        if IsPedShooting(playerPed) then
            local coords = GetEntityCoords(playerPed)
            local radius = 50.0 -- Radius around player to make peds flee
            local peds = GetGamePool('CPed')

            for _, ped in pairs(peds) do
                if not IsPedAPlayer(ped) and #(GetEntityCoords(ped) - coords) < radius then
                    ClearPedTasks(ped)
                    TaskSmartFleePed(ped, playerPed, 100.0, -1, true, true)
                end
            end
        end
        Wait(500) -- Only check twice per second to stay low-resmon
    end
end)
