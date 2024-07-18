local variables = {
    dict = 'mp_suicide',
    anim = 'pistol',
    DW = false,
    Animka = false,
    Zamknij = true
}

local function loadAnimDict(dict)
    RequestAnimDict(dict)
local repeater = 0
repeat 
    Wait(1)
    repeater = HasAnimDictLoaded(dict)
until (repeater == 1)
end

local function WylaczAnimke()
    if GetAmmoInPedWeapon(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId())) ~= 0 then
    variables.Animka = false
    variables.Zamknij = true
    coords = GetEntityCoords(PlayerPedId())
    rot = GetEntityRotation(PlayerPedId())
    variables.Animka = false
    ClearPedTasks(PlayerPedId())
    SetPedShootRate(PlayerPedId(), 1000)
    SetPedShootsAtCoord(PlayerPedId(), 0, 0, 0, true)
    TaskPlayAnimAdvanced(PlayerPedId(), variables.dict, variables.anim, coords, rot, 8.0, 8.0, 3000, 0, 0.28, 0, 0)
    Wait(200)
    SetEntityHealth(PlayerPedId(), 0)
    variables.DW = false
    else 
        PlaySoundFrontend(-1, 'Faster_Click', 'RESPAWN_ONLINE_SOUNDSET', 1)
    end
end

local function WlaczAnimke()
    variables.Zamknij = false
    variables.DW = true
    loadAnimDict(variables.dict)
    TaskPlayAnim(GetPlayerPed(-1), variables.dict , variables.anim , 8.0, -8.0, -1, 0, 0, false, false, false)
    repeat 
        Wait(10)
        if variables.Animka then
            TriggerEvent('HelpNotification:Show', "~r~[E]~w~ aby naciśnąć spust, ~g~[X]~w~ aby przerwać")
        end
        if variables.Animka and IsControlJustPressed(0, 38) then
            WylaczAnimke()
        end
        if variables.Animka and IsControlJustPressed(0, 73) then
            StopAnimTask(PlayerPedId(), variables.dict, variables.anim, 1.1);
            variables.Animka = false
        end
    until (not variables.Animka)

end

RegisterCommand('popelnijs', function()
    for _, g in ipairs(Config.Bronie) do
        if HasPedGotWeapon(PlayerPedId(), GetHashKey(g.hash), false) then
            variables.Animka = true
            WlaczAnimke()
            break
        else
            TriggerEvent('esx:showNotification', 'Nie masz broni')
            break  
        end
    end

end)

CreateThread(function()
    while true do 
    Wait(100)    
        if (IsEntityPlayingAnim(PlayerPedId(), variables.dict, variables.anim, 3)) then
            print('true')
            currentTime = GetEntityAnimCurrentTime(PlayerPedId(), variables.dict, variables.anim);
            if currentTime >= 0.28 and not variables.Zamknij then
                SetEntityAnimCurrentTime(PlayerPedId(), variables.dict, variables.anim, currentTime);
                SetEntityAnimSpeed(PlayerPedId(), variables.dict, variables.anim, 0);
            end
        end      
    end 
end)
