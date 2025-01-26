-- Create the main button
local button = CreateFrame("Button", "TranscriptorButton", UIParent, "UIPanelButtonTemplate")
button:SetSize(100, 30)      -- Button size (width, height)
button:SetText("Am i rich?") -- Button text
button:SetPoint("CENTER")    -- Initial position (center of the screen)

-- Create the lock button (lock/unlock button for the main button)
local lockButton = CreateFrame("Button", "LockButton", UIParent, "UIPanelButtonTemplate")
lockButton:SetSize(30, 30) -- Lock button size
lockButton:SetText("🔒") -- Icon or text for the lock button
lockButton:SetPoint("RIGHT", button, "LEFT", -5, 0) -- Position relative to the main button

-- Variables to track the lock state
local isLocked = false

-- Function to toggle lock/unlock the main button
local function ToggleLock()
  isLocked = not isLocked
  if isLocked then
    button:SetMovable(false) -- Disable button movement
    lockButton:SetText("🔓") -- Unlock icon
    print("Button locked.")
  else
    button:SetMovable(true) -- Enable button movement
    lockButton:SetText("🔒") -- Lock icon
    print("Button unlocked.")
  end
end

-- Add the behavior to the lock button
lockButton:SetScript("OnClick", ToggleLock)

-- Make the main button movable
button:SetMovable(true)
button:EnableMouse(true)
button:RegisterForDrag("LeftButton")

button:SetScript("OnDragStart", function(self)
  if not isLocked then
    self:StartMoving() -- Start moving the button when dragging
  end
end)

button:SetScript("OnDragStop", function(self)
  self:StopMovingOrSizing() -- Stop moving the button when drag is finished
end)

-- Custom function to format coin values (replace deprecated GetCoinText)
function FormatCoinValue(value)
  value = tonumber(value)
  if not value then
    return "Impossible to calculate. Please provide a number."
  end

  local gold = math.floor(value / 10000)
  local silver = math.floor((value % 10000) / 100)
  local copper = value % 100
  return string.format("%dg %ds %dc", gold, silver, copper) -- Format the value in gold, silver, and copper
end

-- Function to calculate the value of sellable items in the bags
function CalculateBagValue()
  local totalValue = 0
  for bag = 0, 4 do
    local numSlots = C_Container.GetContainerNumSlots(bag)
    for slot = 1, numSlots do
      local itemLink = C_Container.GetContainerItemLink(bag, slot)

      if itemLink then
        -- Get item info using C_Item.GetItemInfo with itemLink (instead of deprecated GetItemInfo)
        local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
        if itemInfo then
          local itemCount = itemInfo.stackCount or 1
          local itemData = C_Item.GetItemInfo(itemLink)

          if itemData then
            local vendorPrice = select(11, C_Item.GetItemInfo(itemLink))

            -- Check if the item is sellable
            if vendorPrice and vendorPrice > 0 then
              local itemValue = vendorPrice * itemCount
              totalValue = totalValue + itemValue

              -- Debug information
              -- print(string.format("Item: %s", itemLink))
              -- print(string.format("Vendor price per unit: %s", FormatCoinValue(vendorPrice)))
              -- print(string.format("Stack count: %d", itemCount))
              -- print(string.format("Total item value: %s", FormatCoinValue(itemValue)))
              -- print("------------------------")
            end
          end
        end
      end
    end
  end

  return totalValue
end

-- Add a script for clicking the main button
button:SetScript("OnClick", function()
  local totalValue = CalculateBagValue() -- Calculate the value of the bags
  print(string.format("Total bag value: %s", FormatCoinValue(totalValue)))
end)
