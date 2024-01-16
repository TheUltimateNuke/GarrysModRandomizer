local M = {}
function M:FindFilesInRecursiveMode(path, fileExt, pathType)
    pathType = pathType or "GAME"
    if not path or not fileExt then return nil end

    local output = {}
    local queue = {path}

    while #queue > 0 do
        for _, directory in pairs(queue) do
            local files, directories = file.Find(directory .. "/*", pathType)

            for _, filename in pairs(files) do
                print( "found " .. directory .. "/" .. filename )
                if (filename:EndsWith(".mdl")) then
                    table.insert(output, directory .. "/" .. filename)
                end
            end

            for _, subdirectory in pairs(directories) do
                table.insert(queue, directory .. "/" .. subdirectory)
            end

            table.RemoveByValue(queue, directory)
        end
    end

    return output

end
return M