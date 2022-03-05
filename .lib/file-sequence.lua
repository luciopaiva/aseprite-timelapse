
function getFileNameWithSequence(seq)
    return seq .. ".png"
end

function isFileSeq(path, seq)
    return app.fs.isFile(app.fs.joinPath(path, getFileNameWithSequence(seq)))
end

function getPivotPoint(left, right)
    return left + math.floor((right - left) / 2)
end

--[[ Finds the next sequence available ]]
function getNextSequence(path)
    local step = 100
    local maxSeq = 1000000
    local seq = 0

    -- coarse grain phase
    for i = 0, maxSeq, step do
        if not isFileSeq(path, i) then
            seq = i
            break
        end
    end

    -- fine grain, binary search
    local left = math.max(0, seq - step)  -- left is a file that does exist
    local right = seq  -- right is a file that does not exist

    while right - left > 1 do
        local pivot = getPivotPoint(left, right)

        if isFileSeq(path, pivot) then
            left = pivot
        else
            right = pivot
        end
    end

    return right
end
