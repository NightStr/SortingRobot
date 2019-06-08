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
        if innerItem == nil then
            robot.select(i)
            for ei=externalCellIndex, component.inventory_controller.getInventorySize(sides.forward) do
                externalStoredItem = component.inventory_controller.getStackInSlot(sides.forward, ei)
                if not(externalStoredItem == nil) then
                    component.inventory_controller.suckFromSlot(sides.forward, ei)
                    externalCellIndex = ei
                    break
                end
            end
        end
        if externalCellIndex == component.inventory_controller.getStackInSlot(sides.forward, ei) then
            break
        end
    end 
end

getAll()

