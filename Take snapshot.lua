
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

        -- return app.fs.joinPath(timelapsePath, timestamp .. ".aseprite")
        return app.fs.joinPath(timelapsePath, getFileNameWithSequence(seq)), seq
    end

    return nil, nil
end

function openSeqFile(originalFileName, seq)
    local seqFileName = getTimeLapseFileName(originalFileName, seq)
    return io.open(seqFileName, 'rb')
end

function decideIfShouldKeepSnapshot(tmpFileName, originalFileName, seq)
    local keepIt = true

    if seq > 0 then
        local prevFile = openSeqFile(originalFileName, seq - 1)
        local curFile = openSeqFile(tmpFileName, seq)

        repeat
            local prevContents = prevFile:read(4096)
            local curContents = curFile:read(4096)

            if not prevContents or not curContents then
                break
            end
            
            if (#prevContents ~= #curContents) or (prevContents ~= curContents) then
                keepIt = false
                break
            end
        until false

        prevFile:close()
        curFile:close()
    end

    if keepIt then
        os.rename(tmpFileName, openSeqFile(originalFileName, seq))
    else
        -- local fileNameToRemove = getTimeLapseFileName(originalFileName, seq)
        -- os.remove(fileNameToRemove)
        print("New file did not have any changes, so I will discard it")
    end
end

--[[ Finds the appropriate file name and saves a snapshot ]]
function takeSnapshot()
    local sprite = app.activeSprite
    if sprite then
        local fileName, seq = getTimeLapseFileName(sprite.filename, nil)
        if fileName then
            sprite:saveCopyAs(fileName)
            -- local tmpFileName = os.tmpname()
            -- sprite:saveCopyAs(tmpFileName)
            -- print("Saved " .. fileName)
            -- decideIfShouldKeepSnapshot(tmpFileName, sprite.filename, seq)
        else
            -- print("Could not take snapshot")
        end
    end
end

takeSnapshot()

-- os.execute("cscript test.vbs")
-- os.execute("cmd /c wscript ./test.vbs")
-- local handle = io.popen("./test.vbs")
-- local result = handle:read("*a")
-- print(result)
-- handle:close()

-- result, str, num = os.execute("echo test")
-- print(result)
-- print(str)
-- print(num)
-- print(debug.getinfo(1, "S").source)

