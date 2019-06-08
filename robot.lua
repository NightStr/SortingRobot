function dropAll()
    local storageItems = {}
    for i=1, component.inventory_controller.getInventorySize(3) do
        storageItems[i] = component.inventory_controller.getStackInSlot(3, i)
    end
    local innerItem
    for i=1, 16 do
        innerItem = component.inventory_controller.getStackInInternalSlot(i)
    
        for key, value in pairs(storageItems) do
            if (not(innerItem == nil) and innerItem["name"] == value["name"]) then
                robot.select(i)
                component.inventory_controller.dropIntoSlot(3, key)
            end
        end
    end    
end

function getAll()
    for i=1, 16 do
        innerItem = component.inventory_controller.getStackInInternalSlot(i)
        robot.select(i)
        print(innerItem)
        for externalCellIndex=1, component.inventory_controller.getInventorySize(3) do
            externalStoredItem = component.inventory_controller.getStackInSlot(3, externalCellIndex)
            if not(externalStoredItem == nil) then
                print(i)
                if innerItem == nil then
                    component.inventory_controller.suckFromSlot(3, externalCellIndex)
                elseif innerItem["name"] == externalStoredItem["name"] then
                    slotAvaible = innerItem["maxSize"] - innerItem["size"]
                    if slotAvaible > 0 then
                        component.inventory_controller.suckFromSlot(3, externalCellIndex, slotAvaible)
                    end
                end
            end
        end
    end 
end

getAll()
