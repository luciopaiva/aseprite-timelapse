
dofile(".lib/file-sequence.lua")

--[[ Obtains the next file name available in the snapshot sequence ]]
function getTimeLapseFileName(fullFileName, seq)

    if fullFileName and app.fs.isFile(fullFileName) then
        local path = app.fs.filePath(fullFileName)
        local title = app.fs.fileTitle(fullFileName)
        local timestamp = os.date("%Y%m%d%H%M%S")

        local timelapsePath = app.fs.joinPath(path, title .. "-timelapse")
        app.fs.makeAllDirectories(timelapsePath)  -- this is like `mkdir -p`
    
        if not seq then
            seq = getNextSequence(timelapsePath)
        end

        return app.fs.joinPath(timelapsePath, getFileNameWithSequence(seq)), seq
    end

    return nil, nil
end

--[[ Finds the appropriate file name and saves a snapshot ]]
function takeSnapshot()
    local sprite = app.activeSprite
    if sprite then
        local fileName, seq = getTimeLapseFileName(sprite.filename, nil)
        if fileName then
            sprite:saveCopyAs(fileName)
        end
    end
end

takeSnapshot()
