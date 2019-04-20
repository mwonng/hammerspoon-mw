local wm = require('window-management')
local hk = require "hs.hotkey"

-- * Key Binding Utility
--- Bind hotkey for window management.
-- @function windowBind
-- @param {table} hyper - hyper key set
-- @param { ...{key=value} } keyFuncTable - multiple hotkey and function pairs
--   @key {string} hotkey
--   @value {function} callback function

local function windowBind(hyper, keyFuncTable)
  for key,fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end



if wm then
    spoon.ModalMgr:new("window")
    local cmodal = spoon.ModalMgr.modal_list["window"]
    cmodal:bind('', 'escape', 'Deactivate ', function() spoon.ModalMgr:deactivate({"window"}) end)

    -- Window move
    cmodal:bind('', 'A', 'Move Left', wm.moveLeftWindow)
    cmodal:bind('', 'D', 'Move Right', wm.moveRightWindow)
    cmodal:bind('', 'S', 'Move Down', wm.moveDownWindow)
    cmodal:bind('', 'W', 'Move Up', wm.moveUpWindow)

    -- Left edge change
    cmodal:bind('ctrl', 'A', 'Extend Left', wm.leftToLeft)
    cmodal:bind('ctrl', 'D', 'Shrink Left', wm.leftToRight)

    -- Right edge change
    cmodal:bind('command', 'D', 'Extend Right', wm.rightToRight)
    cmodal:bind('command', 'A', 'Shrink Right', wm.rightToLeft)

    -- Top edge change
    cmodal:bind('ctrl', 'W', 'Extend Top', wm.topUp)
    cmodal:bind('ctrl', 'S', 'Shrink Top', wm.topDown)

    -- Tottom edge change
    cmodal:bind('command', 'S', 'Extend Bottom', wm.bottomDown)
    cmodal:bind('command', 'W', 'Shrink Bottom', wm.bottomUp)

    -- half screen
    cmodal:bind('command', 'left', 'Left Half', wm.leftHalf)
    cmodal:bind('command', 'right', 'Right Half', wm.rightHalf)
    cmodal:bind('command', 'up', 'Left Half', wm.topHalf)
    cmodal:bind('command', 'down', 'Right Half', wm.bottomHalf)

    -- Move to other monitor
    cmodal:bind('alt', 'left', 'Left Monitor', wm.throwLeft)
    cmodal:bind('alt', 'right', 'Right Monitor', wm.throwRight)

    hsresizeM_keys = hsresizeM_keys or {"ctrl", "W"}
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "Enter command", function()
            -- Deactivate some modal environments or not before activating a new one
            spoon.ModalMgr:deactivateAll()
            -- Show an status indicator so we know we're in some modal environment now
            spoon.ModalMgr:activate({"window"}, "#B22222")
        end)
    end

end

-- * Move window to screen
-- windowBind({"ctrl", "alt"}, {
--   left = wm.throwLeft,
--   right = wm.throwRight
-- })

-- * Set Window Position on screen
windowBind({"ctrl", "alt", "cmd"}, {
  m = wm.maximizeWindow,    -- ⌃⌥⌘ + M
  c = wm.centerOnScreen,    -- ⌃⌥⌘ + C
--   left = wm.leftHalf,       -- ⌃⌥⌘ + ←
--   right = wm.rightHalf,     -- ⌃⌥⌘ + →
--   up = wm.topHalf,          -- ⌃⌥⌘ + ↑
--   down = wm.bottomHalf      -- ⌃⌥⌘ + ↓
})

-- * Windows-like cycle
-- windowBind({"ctrl", "alt", "cmd"}, {
--   u = wm.cycleLeft,          -- ⌃⌥⌘ + u
--   i = wm.cycleRight          -- ⌃⌥⌘ + i
-- })

-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()