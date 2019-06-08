local component = require("component")
local sides = require("sides")
local robot = require("robot")

CHARGER = {x=29.5, y=95.5, z=38.5}
DROWER = {x=28.5, y=94.5, z=36.5}
STORAGE1 = {x=27.5, y=94.5, z=30.5}
STORAGE2 = {x=27.5, y=94.5, z=29.5}
STORAGE3 = {x=27.5, y=94.5, z=28.5}
STORAGE4 = {x=27.5, y=94.5, z=27.5}
STORAGE5 = {x=27.5, y=94.5, z=26.5}
STORAGE6 = {x=27.5, y=95.5, z=26.5}
STORAGE7 = {x=27.5, y=95.5, z=27.5}
STORAGE8 = {x=27.5, y=95.5, z=28.5}
STORAGE9 = {x=27.5, y=95.5, z=29.5}
STORAGE10 = {x=27.5, y=95.5, z=30.5}

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


function turnAndGo(fancing, steps)
    if (not(fancing == nil)) then
        while not (component.navigation.getFacing() == fancing) do
            robot.turnLeft()
        end
    end
    for i=1, math.abs(steps) do
        robot.forward()
    end
end


function goTo(position)
    print(position.x, position.y, position.z)
    local currentX, currentY, currentZ = component.navigation.getPosition()
    local deltaX = math.floor(position.x) - math.floor(currentX)
    local deltaY = math.floor(position.y) - math.floor(currentY)
    local deltaZ = math.floor(position.z) - math.floor(currentZ)
    local action
    
    if deltaY > 0 then
        action = robot.up
        checkAction = robot.detectUp
    elseif deltaY < 0 then
        action = robot.down
        checkAction = robot.detectDown
    end
    
    local fancingX
    local fancingZ
    if deltaX > 0 then
        fancingX = 5.0
    elseif deltaX < 0 then
        fancingX = 4.0
    end
    if deltaZ > 0 then
        fancingZ = 3.0
    elseif deltaZ < 0 then
        fancingZ = 2.0
    end

    while deltaX ~= 0 or deltaY ~= 0 or deltaZ ~= 0 do
        print('deltaX', deltaX, 'deltaY', deltaY, 'deltaZ', deltaZ)
        while deltaY ~= 0 do
            print('Move Up/Down')
            if deltaY > 0 then
                _, blockType = robot.detectUp()
                if blockType == 'air' then
                    print('Move up')
                    robot.up()
                    deltaY = deltaY - 1
                else
                    print('Cant move up')
                    break
                end
            elseif deltaY < 0 then
                _, blockType =  robot.detectDown()
                if blockType == 'air' then
                    print('Move down')
                    action = robot.down()
                    deltaY = deltaY + 1
                else
                    print('Cant move down')
                    break
                end
            end
        end
        
        while deltaX ~= 0 and fancingX ~= nil do
            print('Move Left/Right')
            while not (component.navigation.getFacing() == fancingX) do
                robot.turnLeft()
            end
            _, blockType = robot.detect()
            if (blockType == 'air') then
                print('Move Forward')
                robot.forward()
                if deltaX > 0 then
                    deltaX = deltaX - 1
                elseif deltaX < 0 then
                    deltaX = deltaX + 1
                end
            else
                print('Can\' t move to left/right breaked')
                break
            end
        end
        
        while deltaZ ~= 0 and fancingZ ~= nil do
            print('Move forward/backward')
            while not (component.navigation.getFacing() == fancingZ) do
                robot.turnLeft()
            end
            _, blockType = robot.detect()

            if (blockType == 'air') then
                print('Move Forward')
                robot.forward()
                if deltaZ > 0 then
                    deltaZ = deltaZ - 1
                elseif deltaZ < 0 then
                    deltaZ = deltaZ + 1
                end
            else
                print('Can\' t move to forward/backward breaked')
                break
            end
        end
    end
    print('deltaX', deltaX, 'deltaY', deltaY, 'deltaZ', deltaZ)
end


for _, point in ipairs{DROWER,STORAGE1,STORAGE2,STORAGE3,STORAGE4,STORAGE5,STORAGE6,STORAGE7,STORAGE8,STORAGE9,STORAGE10,CHARGER} do
    goTo(point)
end
