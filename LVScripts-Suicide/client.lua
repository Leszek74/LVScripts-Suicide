RegisterCommand('popelnijs', function()
    local ped = PlayerPedId()
    local Bron = false
    for _, g in ipairs(Config.Bronie) do
        if HasPedGotWeapon(ped, GetHashKey(g.hash), false) then
            WlaczAnimke()
            Animka = true
            Bron = true
            break
        end
    end

    if not Bron then
        TriggerEvent('esx:showNotification', 'Nie masz broni')
    end
end)

local dict = 'mp_suicide'
local anim =  'pistol'
local DW = false 

function WlaczAnimke()
    TaskPlayAnim(GetPlayerPed(-1), dict ,anim ,8.0, -8.0, -1, 0, 0, false, false, false)
    DW = true
    Zamknij = false
end

function WylaczAnimke()
ped = PlayerPedId()
wephash = GetSelectedPedWeapon(ped)
wepammo = GetAmmoInPedWeapon(ped, wephash)
if wepammo ~= 0 then
Animka = false
Zamknij = true
coords = GetEntityCoords(ped)
rot = GetEntityRotation(ped)
Animka = false
ClearPedTasks(ped)
SetPedShootRate(ped, 1000)
SetPedShootsAtCoord(ped, 0, 0, 0, true)
TaskPlayAnimAdvanced(ped, dict, anim, coords, rot, 8.0, 8.0, 3000, 0, 0.28, 0, 0)
Wait(200)
SetEntityHealth(ped, 0)
DW = false
else 
    PlaySoundFrontend(-1, 'Faster_Click', 'RESPAWN_ONLINE_SOUNDSET', 1)
end
end 

CreateThread(function()
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Citizen.Wait(1000)
    end
end)

CreateThread(function()
    while true do 
    Wait(100)
                
            if (IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3)) then
                currentTime = GetEntityAnimCurrentTime(PlayerPedId(), dict, anim);
                if currentTime >= 0.28 and not Zamknij then
                	ped = PlayerPedId()
                    SetEntityAnimCurrentTime(PlayerPedId(), dict, anim, currentTime);
                    SetEntityAnimSpeed(PlayerPedId(), dict, anim, 0);
                end
            end
            
        end 
end)

CreateThread(function()
    while true do 
    Wait(0)
    ped = PlayerPedId()
    coords = GetEntityCoords(ped)
if Animka then
    TriggerEvent('HelpNotification:Show', "~r~[E]~w~ aby naciśnąć spust, ~g~[X]~w~ aby przerwać")
end
if Animka and IsControlJustPressed(0, 38) then
	WylaczAnimke()
end
if Animka and IsControlJustPressed(0, 73) then
	StopAnimTask(PlayerPedId(), dict, anim, 1.1);
	Animka = false
end
end
end)

