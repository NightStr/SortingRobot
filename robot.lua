function dropAll()
    local storageItems = {}
    for i=1, component.inventory_controller.getInventorySize(sides.forward) do
        storageItems[i] = component.inventory_controller.getStackInSlot(sides.forward, i)
    end
    local innerItem
    for i=1, 16 do
        innerItem = component.inventory_controller.getStackInInternalSlot(i)
    
        for key, value in pairs(storageItems) do
            if (not(innerItem == nil) and innerItem["name"] == value["name"]) then
                robot.select(i)
                component.inventory_controller.dropIntoSlot(sides.forward, key)
            end
        end
    end    
end

function getAll()
    local storageItems = {}
    local externalCellIndex = 1
    for i=1, 16 do
        innerItem = component.inventory_controller.getStackInInternalSlot(i)
        robot.select(i)
        for externalCellIndex=1, component.inventory_controller.getInventorySize(sides.forward) do
            externalStoredItem = component.inventory_controller.getStackInSlot(sides.forward, externalCellIndex)
            if not(externalStoredItem == nil) then
                print(i)
                if innerItem == nil then
                    component.inventory_controller.suckFromSlot(sides.forward, externalCellIndex)
                    local slotAvaible = innerItem["maxSize"] - innerItem["size"]
                elseif innerItem["name"] == externalStoredItem["name"] and slotAvaible > 0 then
                    component.inventory_controller.suckFromSlot(sides.forward, externalCellIndex, slotAvaible)
                end
            end
        end
    end 
end

getAll()
