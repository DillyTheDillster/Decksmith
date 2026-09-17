-- Retrieves all deck files that may be valid
function Decksmith.retrieve_valid_decks()
    local filedata = SMODS.NFS.getDirectoryItemsInfo('Decksmith_decks')
    local valid_decks = {}
    for _, v in pairs(filedata) do
        if v.type == 'file' and v.name and string.sub(v.name, -4, -1) == '.jkr' then
            table.insert(valid_decks, v)
        end
    end
    return valid_decks
end

-- Returns a key/value table where the key is the filename and the value is the plaintext name
function Decksmith.get_valid_deck_names()
    local valid_decks = Decksmith.retrieve_valid_decks()
    local names = {}
    for _, v in pairs(valid_decks) do
        local data = assert(loadstring(SMODS.NFS.read('Decksmith_decks/' .. v.name)))()
        if data.name then
            names[v.name] = data.name
        end
    end
    return names
end

-- Retrieves data from a specified deck
function Decksmith.get_deck_data(path)
    return assert(loadstring(SMODS.NFS.read('Decksmith_decks/' .. path)))()
end

-- Uses deck data to set deck preset
function Decksmith.set_deck_preset(path)

    local deck_data = Decksmith.get_deck_data(path)
    for k, v in pairs(deck_data) do
        if v ~= '' then
            Decksmith.start_args[k] = v
        end
    end
end

-- Check if a deck with name already exists. Create popup if it does, immediately save if not
function Decksmith.check_save_deck(new_path)
    local existing_names = Decksmith.get_valid_deck_names()
    local already_exists = false
    for k, _ in pairs(existing_names) do
        if k == new_path then
            -- Show popup
            already_exists = true
            break
        end
    end
    if not already_exists then
        Decksmith.write_deck(new_path)
    end
end

-- Creates or overwrites deck save under specified name
function Decksmith.write_deck(path)
    local file = SMODS.NFS.newFile('Decksmith_decks/' .. path)
    file:open('w')
    file:write('return {\r\n')
    for k, v in pairs(Decksmith.start_args) do
        if v ~= '' then
            file:write('    ' .. tostring(k) .. ' = ')
            local value
            if type(v) == 'table' then
                value = '{'
                for kk, vv in pairs(v) do
                    value = value .. tostring(kk) .. ' = ' .. tostring(vv) .. ','
                end
                value = value .. '}'
            else
                value = v
            end
            file:write(tostring(value) .. ',\r\n')
        end
    end 
    file:write('}')
    file:close()
end