local storeLocations = {
    ["buy"] = {x = -709.5749, y = -905.8767, z = 19.2156, h = 74.6610},
    ["sell"] = {x = -707.4838, y = -913.6531, z = 19.2156, h = 281.9125}
}

local storeData = {}

function BuyStore(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    local targetCoords = storeLocations["buy"]
    local dist = #(player.coords - vector3(targetCoords.x, targetCoords.y, targetCoords.z))

    if dist < 3.0 then
        local storeCost = 50000
        if player.Functions.RemoveMoney("cash", storeCost) then
            local store = {
                id = #storeData + 1,
                owner = playerId,
                inventory = {},
                location = storeLocations["sell"]
            }
            table.insert(storeData, store)
            player.Functions.Notify("You have successfully purchased a store!")
        else
            player.Functions.Notify("You don't have enough money to purchase a store!")
        end
    else
        player.Functions.Notify("You're not close enough to the store to purchase it!")
    end
end

function SellItem(playerId, storeId, itemName, price, quantity)
    local player = QBCore.Functions.GetPlayer(playerId)
    local store = storeData[storeId]

    if not store or store.owner ~= playerId then
        player.Functions.Notify("You don't own this store!")
        return
    end

    if not store.inventory[itemName] then
        store.inventory[itemName] = {price = price, quantity = quantity}
    else
        store.inventory[itemName].price = price
        store.inventory[itemName].quantity = quantity
    end

    player.Functions.Notify("You have successfully added/updated the item in your store's inventory!")
end

function RemoveItem(playerId, storeId, itemName)
    local player = QBCore.Functions.GetPlayer(playerId)
    local store = storeData[storeId]

    if not store or store.owner ~= playerId then
        player.Functions.Notify("You don't own this store!")
        return
    end

    if store.inventory[itemName] then
        store.inventory[itemName] = nil
        player.Functions.Notify("You have successfully removed the item from your store's inventory!")
    else
        player.Functions.Notify("The item doesn't exist in your store's inventory!")
    end
end

function OpenStore(playerId, storeId)
    local player = QBCore.Functions.GetPlayer(playerId)
    local store = storeData[storeId]

    if not store or player.coords:DistTo(store.location) > 3.0 then
        player.Functions.Notify("The store doesn't exist or is too far away!")
        return
    end

    local inventory = {}
    for itemName, itemData in pairs(store.inventory) do
        table.insert(inventory, {
            label = itemName,
            value = itemName,
            price = itemData.price,
            quantity = itemData.quantity
        })
    end

    player.TriggerEvent("myStore:openStore", store.owner, inventory)
end

function UpdateStoreInventory(storeId, inventory)
    local store = storeData[storeId]

    if not store then
        return
    end

    store.inventory = inventory
end

RegisterServerEvent("myStore:buyStore")
AddEventHandler("myStore:buyStore", function()
    local playerId = source
    BuyStore(playerId)
end)

RegisterServerEvent("myStore:addItem")
AddEventHandler("myStore:addItem", function(itemName, price, quantity)
    local playerId = source
    local storeId = GetPlayerStoreId(playerId)
    SellItem(playerId, storeId, itemName, price, quantity)
end)

RegisterServerEvent("myStore:removeItem")
AddEventHandler("myStore:removeItem", function(itemName)
    local playerId = source
    local storeId = GetPlayerStoreId(playerId)
    RemoveItem(playerId, storeId, itemName)
end)

RegisterServerEvent("myStore:openStore")
AddEventHandler("myStore:openStore", function(storeId)
    local playerId = source
    OpenStore(playerId, storeId)
end)

RegisterServerEvent("myStore:updateInventory")
AddEventHandler("myStore:updateInventory", function(inventory)
    local storeId = GetPlayerStoreId(source)
    UpdateStoreInventory(storeId, inventory)
end)

function GetPlayerStoreId(playerId)
    for _, store in ipairs(storeData) do
        if store.owner == playerId then
            return store.id
        end
    end
    return nil
end

