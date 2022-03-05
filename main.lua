
dofile("file-sequence.lua")

unsavedByFilename = {}
spriteByFilename = {}

function isSaved(sprite)
    return app.fs.isFile(sprite.filename)
end

function onSpriteChange(filename)
    local obj = spriteByFilename[filename]
    obj.changes = obj.changes + 1
    print("Sprite " .. filename .. " has changed " .. obj.changes .. " times")
    local filename = getTimeLapseFileName(filename, nil)
    print("Will save snapshot " .. filename)
    if filename then
        obj.sprite:saveCopyAs(filename)
    end
end

function registerSprite(sprite)
    local filename = sprite.filename
    local handle = sprite.events:on("change", function() onSpriteChange(filename) end)
    spriteByFilename[filename] = {
        changes = 0,
        sprite = sprite
    }
end

function promoteUnsavedFile(sprite, filename, listener)
    print("Detected a file name change! Sprite " .. filename .. " is now " .. app.activeSprite.filename)
    unsavedByFilename[filename] = nil
    sprite.events:off(listener)
    print("Unregistered filename change listener for " .. filename)
    handleSavedSprite(app.activeSprite)
end

function handleUnsavedSprite(sprite)
    local filename = sprite.filename  -- this will be something like "Sprite-001" in an unsaved file
    if unsavedByFilename[filename] == nil then
        print("Registering unsaved sprite " .. filename)
        function callback()
            promoteUnsavedFile(sprite, filename, callback)
        end
        sprite.events:on("filenamechange", callback)
        unsavedByFilename[filename] = true
    end
end

function handleSavedSprite(sprite)
    local filename = sprite.filename
    if spriteByFilename[filename] == nil then
        print("Registering saved sprite " .. filename)
        registerSprite(sprite)
        -- call it once straight away
        onSpriteChange(filename)
    end
end

function onSiteChange()
    local sprite = app.activeSprite
    if not sprite then
        return
    end

    if isSaved(sprite) then
        handleSavedSprite(sprite)
    else
        handleUnsavedSprite(sprite)
    end
end

function init(plugin)
    print("Aseprite is initializing timelapse plugin")

    app.events:on("sitechange", onSiteChange)

    if plugin.preferences.count == nil then
        plugin.preferences.count = 0
    end

  --
--   plugin:newCommand{
--     id="Timelapse",
--     title="Timelapse",
--     group="main_menu",
--     onclick=function()
--       plugin.preferences.count = plugin.preferences.count+1
--       print("Menu clicked")
--     end
--   }
end

function exit(plugin)
    print("Aseprite is closing timelapse plugin...")
end
