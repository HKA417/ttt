local storeId = nil

-- Function to open the store menu
function OpenStoreMenu(id)
    storeId = id
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open_store",
        storeId = id
    })
end

-- Function to close the store menu
function CloseStoreMenu()
    SetNuiFocus(false)
    SendNUIMessage({
        type = "close_store"
    })
    storeId = nil
end

-- Event handler for buying items from the store
RegisterNetEvent("myStore:buyItem")
AddEventHandler("myStore:buyItem", function(itemName, price)
    TriggerServerEvent("myStore:addItem", itemName, price, 1)
end)

-- Event handler for adding items to the store's inventory
RegisterNetEvent("myStore:addInventoryItem")
AddEventHandler("myStore:addInventoryItem", function(itemName)
    TriggerServerEvent("myStore:addItem", itemName, 0, 1)
end)

-- Event handler for removing items from the store's inventory
RegisterNetEvent("myStore:removeInventoryItem")
AddEventHandler("myStore:removeInventoryItem", function(itemName)
    TriggerServerEvent("myStore:removeItem", itemName)
end)

-- Event handler for updating the store's inventory
RegisterNetEvent("myStore:updateStoreInventory")
AddEventHandler("myStore:updateStoreInventory", function(inventory)
    SendNUIMessage({
        type = "update_store_inventory",
        inventory = inventory
    })
end)

-- NUI callback function to buy items from the store
RegisterNUICallback("buy_item", function(data)
    TriggerServerEvent("myStore:addItem", data.itemName, data.price, data.quantity)
end)

-- NUI callback function to close the store menu
RegisterNUICallback("close_store_menu", function(data)
    CloseStoreMenu()
end)

-- NUI callback function to add an item to the store's inventory
RegisterNUICallback("add_inventory_item", function(data)
    TriggerServerEvent("myStore:addItem", data.itemName, 0, data.quantity)
end)

-- NUI callback function to remove an item from the store's inventory
RegisterNUICallback("remove_inventory_item", function(data)
    TriggerServerEvent("myStore:removeItem", data.itemName)
end)

RegisterCommand("forcecloseui", function()
    DestroyMobilePhone()
end, false)
