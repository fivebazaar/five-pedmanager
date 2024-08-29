local pedTable = {}
--- Ped oluşturma fonksiyonu
--- @param uniquename string Ped'in benzersiz adı.
--- @param pedModel string Ped modeli.
--- @param vector4 vector4 Ped'in konumu ve yönü (x, y, z, yaw).
--- @param freeze boolean Ped'i dondurmak için.
--- @param Invicible boolean Ped'in etkilenmemesi için.
--- @param animDict string Animasyon sözlüğü (dictionary) adı.
--- @param animName string Animasyon adı.
--- @return ped Ped nesnesi.
function createPed(uniquename, pedModel, vector4, freeze, Invicible, animDict, animName)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(100)
    end

    local createdPed = CreatePed(4, pedModel, vector4.x, vector4.y, vector4.z, vector4.w, true, false)
    Wait(1000)

    SetEntityInvincible(createdPed, Invicible)
    FreezeEntityPosition(createdPed, freeze)
    SetBlockingOfNonTemporaryEvents(createdPed, freeze)

    if animDict and animName then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
        TaskPlayAnim(createdPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    end

    pedTable[uniquename] = {
        ped = createdPed,
        umbrella = nil,
        animName = animName,
        animDict = animDict
    }

    return createdPed
end
exports('createPed', createPed)

--- Ped'in konumunu dondurur veya serbest bırakır.
--- @param uniquename string Ped'in benzersiz adı.
--- @param freeze boolean Ped'in dondurulup dondurulmayacağı.
function pedFreeze(uniquename, freeze)
    local ped = pedTable[uniquename].ped

    FreezeEntityPosition(ped, freeze)
end
exports('pedFreeze', pedFreeze)



RegisterCommand('pedfreeze', function()
    pedFreeze('farmer_1', false)
end)

--- Ped'e giysi ekler.
--- @param uniquename string Ped'in benzersiz adı.
--- @param componentId number Giysi bileşeninin ID'si.
--- @param drawableId number Giysi modelinin ID'si.
--- @param textureId number Giysi dokusunun ID'si.
function peddressup(uniquename, componentId, drawableId, textureId)
    local ped = pedTable[uniquename].ped
    SetPedComponentVariation(ped, componentId, drawableId, textureId, 0)
end
exports('peddressup', peddressup)



local pedModel1 = 'a_m_m_farmer_01'
local vector4_1 = vector4(122.2, 97.2, 81.43, 180)
local freeze = true
local animDict = 'amb@world_human_hang_out_street@male_a@idle_a'
local animName = 'idle_a'

local myPed1 = createPed('farmer_1', pedModel1, vector4_1, freeze, true, animDict, animName)


local pedModel2 = 'mp_m_freemode_01'
local vector4_2 = vector4(117.84, 98.51, 80.99, 171.98)

local myPed2 = createPed('customped', pedModel2, vector4_2, freeze, true, animDict, animName)

--- Ped'e şemsiye ve animasyon ekler.
--- @param uniquename string Ped'in benzersiz adı.
function GivePedUmbrellaWithEmote(uniquename)
    local pedData = pedTable[uniquename]
    if not pedData then return end

    local ped = pedData.ped
    local umbrellaModel = 'p_amb_brolly_01'
    local animDict = "amb@world_human_drinking@coffee@male@base"
    local animName = "base"

    -- Modeli yükle
    RequestModel(umbrellaModel)
    while not HasModelLoaded(umbrellaModel) do
        Wait(100)
    end

    -- Önceki şemsiyeleri temizle
    RemovePedUmbrella(uniquename)

    -- Yeni şemsiye oluştur
    local umbrella = CreateObject(umbrellaModel, 0.0, 0.0, 0.0, true, true, true)
    AttachEntityToEntity(umbrella, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0200, -0.0360, 0.0, 10.0, 0.0, true, true, false, true, 1, true)

    -- Pedin şemsiye referansını güncelle
    pedData.umbrella = umbrella

    -- Animasyonu başlat
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    pedemote(uniquename, animDict, animName)
end

--- Ped'e animasyon ekler.
--- @param uniquename string Ped'in benzersiz adı.
--- @param animDict string Animasyon sözlüğü (dictionary) adı.
--- @param animName string Animasyon adı.
function pedemote(uniquename, animDict, animName)
    local ped = pedTable[uniquename].ped
    pedTable[uniquename].oldanimDict = pedTable[uniquename].animDict
    pedTable[uniquename].oldanimName = pedTable[uniquename].animName
    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    pedTable[uniquename].animDict = animDict
    pedTable[uniquename].animName = animName
end
exports('pedemote', pedemote)


--- Ped'in mevcut animasyonlarını alır.
--- @param uniquename string Ped'in benzersiz adı.
--- @param anim string Animasyon adı veya sözlüğü (dictionary) adı.
--- @return string Animasyon bilgisi.
function getpedemote(uniquename, anim) --anim = animName or animDict
    return pedTable[uniquename][anim]
end
exports('getpedemote', getpedemote)


--- Ped'in şemsiyesini kaldırır.
--- @param uniquename string Ped'in benzersiz adı.
function RemovePedUmbrella(uniquename)
    local pedData = pedTable[uniquename]
    if not pedData or not pedData.umbrella then return end

    -- Şemsiye varsa, sil
    DeleteObject(pedData.umbrella)
    pedData.umbrella = nil
    animName = pedData.oldanimName
    animDict = pedData.oldanimDict
    pedemote(uniquename, animDict, animName)
end


CreateThread(function()
    while true do
        Wait(1000) 

        local weather = GetWeather() 

        for uniquename, pedData in pairs(pedTable) do
            local ped = pedData.ped
            if weather == 'RAIN' or weather == 'THUNDER' then
                if not pedData.umbrella then
                    GivePedUmbrellaWithEmote(uniquename)
                end
            else
                if pedData.umbrella then
                    RemovePedUmbrella(uniquename)
                end
            end
        end
    end
end)


function cleanUpPeds()
    for uniquename, pedData in pairs(pedTable) do
        local ped = pedData.ped
        if ped then
            if pedData.umbrella then
                DeleteObject(pedData.umbrella)
            end
            DeletePed(ped)
        end
    end
    pedTable = {} 
end


AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        cleanUpPeds()
    end
end)
