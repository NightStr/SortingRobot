local storageItems = {}
for i=1, component.inventory_controller.getInventorySize(sides.forward) do
    storageItems[i-1] = component.inventory_controller.getStackInSlot(sides.forward, i)
end
local innerItem
for i=1, 16 do
    innerItem = component.inventory_controller.getStackInInternalSlot(i)

    for key, value in pairs(storageItems) do
        if (not(innerItem == nil) and innerItem["name"] == value["name"]) then
            robot.select(i)
            component.inventory_controller
        end
    end
end