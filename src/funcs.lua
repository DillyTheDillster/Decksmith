to_big = to_big or function(x) return x end

function Decksmith.text_input_element(value, args)
    args = args or {}
    args.colour = args.colour or G.C.BLUE
    local label = args.label or G.localization.misc.dictionary['k_'..value] or value
    label = type(label) == 'string' and {label} or label

    local label_nodes = {}

    for _, v in pairs(label) do
        table.insert(label_nodes, {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.T, config = {text = v, scale = args.label_size or 0.37, colour = args.label_colour or G.C.WHITE}}}})
    end

    local t = {
        n=G.UIT.R, config = { align = 'cr', padding = 0.1}, nodes = {
            {n=G.UIT.C, config = {align = 'cl', padding = 0.1, minw = 3.8}, nodes = label_nodes},
            {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                create_text_input {
                    id = value .. '_input',
                    prompt_text = args.text or args.label,
                    w = args.w or 1.5,
                    h = args.h or 0.5,
                    all_caps = args.all_caps or false,
                    ref_table = args.ref_table or Decksmith.start_args,
                    ref_value = value,
                    colour = args.colour,
                    hooked_colour = args.hooked_colour or args.colour and darken(args.colour, 0.3),
                    extended_corpus = true
                }
            }},
            {n=G.UIT.C, config = {align='cm'}, nodes = {
                {n=G.UIT.C, config={minw = 0.2}},
                Decksmith.create_value_button(not args.no_random and 'random', Decksmith.button_size/1.5, value),
                {n=G.UIT.C, config={minw = 0.1}},
                Decksmith.create_value_button(not args.no_reset and 'reset', Decksmith.button_size/1.5, value),
            }}
        }
    }

    if not args.no_random then table.insert(Decksmith.this_page_random_options, value) end
    if not args.no_reset then table.insert(Decksmith.this_page_reset_options, value) end

    return t
end

function Decksmith.toggle_element(value, args)
    args = args or {}
    args.colour = args.colour or G.C.BLUE
    local label = args.label or G.localization.misc.dictionary['k_'..value] or value
    label = type(label) == 'string' and {label} or label

    local label_nodes = {}

    for _, v in pairs(label) do
        table.insert(label_nodes, {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.T, config = {text = v, scale = args.label_size or 0.37, colour = args.label_colour or G.C.WHITE}}}})
    end

    local t = {
        n=G.UIT.R, config = { align = 'cr', padding = 0.1}, nodes = {
            {n=G.UIT.C, config = {align = 'cl', padding = 0.1, minw = 3.8}, nodes = label_nodes},
            {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                create_toggle {
                    col = true,
                    id = value .. '_input',
                    label = '',
                    scale = args.scale or 1,
                    w = args.w or 1.5,
                    h = args.h or 0.5,
                    ref_table = args.ref_table or Decksmith.start_args,
                    ref_value = value,
                    colour = args.colour,
                    shadow = true,
                }
            }},
            {n=G.UIT.C, config = {align='cm'}, nodes = {
                {n=G.UIT.C, config={minw = 0.2}},
                Decksmith.create_value_button(not args.no_random and 'random', Decksmith.button_size/1.5, value),
                {n=G.UIT.C, config={minw = 0.1}},
                Decksmith.create_value_button(not args.no_reset and 'reset', Decksmith.button_size/1.5, value),
            }}
        }
    }

    if not args.no_random then table.insert(Decksmith.this_page_random_options, value) end
    if not args.no_reset then table.insert(Decksmith.this_page_reset_options, value) end

    return t
end

function Decksmith.button_element(value, args)
    args = args or {}
    args.colour = args.colour or G.C.BLUE
    local label = args.label or G.localization.misc.dictionary['k_'..value] or value
    label = type(label) == 'string' and {label} or label

    local btn_text = ''

    for i, v in ipairs(label) do
        btn_text = btn_text .. i == 1 and '' or '' .. v
    end

    local t = {
        n=G.UIT.R, config = { align = 'cm', minh = 2}, nodes = {
            {n=G.UIT.R, config = {align = 'cm', colour = args.colour or G.C.BLUE, r = 0.1, hover = true, button = args.button or value, func = args.func, ref_value = value, miw = 3, minh = 0.5, padding = 0.05}, nodes = {
                {n=G.UIT.T, config = {text = btn_text, colour = args.colour or G.C.UI.TEXT_LIGHT}}
            }}
        }
    }

    return t
end


function Decksmith.create_menu_page(args)
    SMODS.RunSelect.Functions.build_preview_areas('deck_choice')
    local deck_preview = SMODS.RunSelect.Functions.build_preview_ui('deck_choice', true)
    deck_preview.nodes[1].config.minh = Decksmith.page_height
    deck_preview.nodes[1].config.align = 'cm'
    SMODS.RunSelect.Functions.populate_preview_ui('deck_choice', SMODS.RunSelect.Setup.choices.deck_choice, true)

    local options = {n=G.UIT.C, config = {align = 'cl'}, nodes = {}}
    Decksmith.this_page_random_options = {}
    Decksmith.this_page_reset_options = {}
    
    for _, option in ipairs(args.options) do
        -- print(option)
        if option[2] and option[2].type then
            if option[2].type == 'text_input' then
                options.nodes[#options.nodes + 1] = {n=G.UIT.R, config = {minh = 0.02, colour = G.C.L_BLACK}} or Decksmith.text_input_element(option[1], option[2])
            elseif option[2].type == 'toggle' then
                options.nodes[#options.nodes + 1] = {n=G.UIT.R, config = {minh = 0.02, colour = G.C.L_BLACK}} or Decksmith.toggle_element(option[1], option[2])
            elseif option[2].type == 'button' then
                options.nodes[#options.nodes + 1] = {n=G.UIT.R, config = {minh = 0.02, colour = G.C.L_BLACK}} or Decksmith.button_element(option[1], option[2])
            end
        else
            options.nodes[#options.nodes + 1] = option[1] == 'spacer' and {n=G.UIT.R, config = {minh = 0.02, colour = G.C.L_BLACK}} or Decksmith.text_input_element(option[1], option[2])
        end
    end                        

    return 
        {n = G.UIT.R, config = {align = 'cm'}, nodes = {
            deck_preview, -- can be moved to the right if preferred, I think it looks good on the left and helps make it clear that you are customising this deck in particular
            {n=G.UIT.C, config={minh = Decksmith.page_height, padding = 0.1}, nodes = {
                {n=G.UIT.R, config = {colour = G.C.BLACK, r = true, align = 'cl', padding = 0.1, emboss = 0.05}, nodes = {
                    {n=G.UIT.C, config = {align = 'cm', minw = 1}, nodes = {
                        {n=G.UIT.R, config={minh=2*Decksmith.button_size + 0.1}}, -- random reset buttons spacer
                        {n=G.UIT.R, config={minh=Decksmith.page_height-0.4-(4*Decksmith.button_size), align='cm'}, nodes={
                            -- TODO: should probably be dynatext incase of localization changes or longer text
                            {n=G.UIT.T, config = {text = localize(args.key), scale = 0.8, colour = G.C.L_BLACK, vert = true}}
                        }},
                        {n=G.UIT.R, config={minh=1, align='cm'}, nodes={ -- whole page random/reset buttons
                            {n=G.UIT.R, nodes = {Decksmith.create_value_button(not args.no_random and 'random_all', Decksmith.button_size, args.key)}},
                            {n=G.UIT.R, config={minh = 0.1}}, -- spacer
                            {n=G.UIT.R, nodes = {Decksmith.create_value_button(not args.no_reset and 'reset_all', Decksmith.button_size, args.key)}},
                        }}
                    }},
                    {n=G.UIT.C, config = {minh = 4, minw = 0.04, colour = G.C.L_BLACK}}, -- line
                    {n=G.UIT.C, config = {align = 'cm', padding = 0.05}, nodes = {
                        options
                    }}
                }}
            }},
        }}
end

function Decksmith.create_value_button(type, size, key)
    local args = Decksmith.buttons[type] or {}

    if args.atlas then
        local sprite = SMODS.create_sprite(0, 0, size, size, args.atlas, args.pos)
        sprite.states.hover.can = false
        sprite.states.click.can = false
        sprite.states.drag.can = false
        return {n=G.UIT.C, config = {
            minw = size,
            minh = size,
            colour = G.C.CLEAR,
            tooltip = args.tooltip and {text = {localize(args.tooltip)}},
            button = args.on_click,
            hover = args.hover,
            shadow = args.shadow,
            ref_value = key,
            align = 'cm',
            r = true
        }, nodes = {
            {n=G.UIT.O, config = {object = sprite}}
        }}
    end

    return {n=G.UIT.C, config = {
        minw = size,
        minh = size,
        colour = args.colour,
        tooltip = args.tooltip and {text = {localize(args.tooltip)}},
        button = args.on_click,
        hover = args.hover,
        shadow = args.shadow,
        r=true,
        ref_value = key
    }}
end

G.FUNCS.ds_reset = function(e)
    --  print('[NYI] Reset',e.config.ref_value)
    Decksmith.start_args[e.config.ref_value] = Decksmith.defaults[e.config.ref_value].reset
    Decksmith.reset_page()
end

G.FUNCS.ds_reset_all = function(e)
    --  print('[NYI] Reset',e.config.ref_value)
    for _, v in pairs(Decksmith.this_page_reset_options) do
        Decksmith.start_args[v] = Decksmith.defaults[v].reset
    end
    Decksmith.reset_page()
end

G.FUNCS.ds_random = function(e)
    -- print('[NYI] Random',e.config.ref_value)
    Decksmith.start_args[e.config.ref_value] = math.random(Decksmith.defaults[e.config.ref_value].min, Decksmith.defaults[e.config.ref_value].max)
    Decksmith.reset_page()
end

G.FUNCS.ds_random_all = function(e)
    -- print('[NYI] Random',e.config.ref_value)
    for _, v in pairs(Decksmith.this_page_random_options) do
        Decksmith.start_args[v] = math.random(Decksmith.defaults[v].min, Decksmith.defaults[v].max)
    end
    Decksmith.reset_page()
end

function Decksmith.reset_page()
    local b = G.OVERLAY_MENU:get_UIE_by_ID("previous_selection")
    local o = b.config.ref_value
    b.config.ref_value = 0
    SMODS.RunSelect.Functions.change_page(b)
    b.config.ref_value = o
end

function Decksmith.get_consumable_pools()
    return {G.P_CENTER_POOLS.Tarot, G.P_CENTER_POOLS.Planet, G.P_CENTER_POOLS.Spectral}
end

function Decksmith.handle_duplicate_choices(page_def, choice, remove, start_table_ref)
    if not Decksmith.start_args.banned_keys or not Decksmith.start_args.banned_keys[choice.config.center.key] then
        SMODS.RunSelect.Setup.choices[page_def.key] = SMODS.RunSelect.Setup.choices[page_def.key] or {}

        local selection_limit
        if type(page_def.selection_limit) == 'function' then
            selection_limit = page_def:selection_limit() or 1
        else
            selection_limit = page_def.selection_limit
        end

        if not remove then
            if selection_limit > 1 then

                local already_selected = 0
                for _, count in pairs(SMODS.RunSelect.Setup.choices[page_def.key]) do
                    already_selected = already_selected + count
                end

                if already_selected < selection_limit then
                    if not SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] then
                        SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] = 1
                    else
                        SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] = SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] + 1
                    end
                    start_table_ref[choice.config.center.key] = SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key]
                else
                    if choice.juice_up then choice:juice_up() end
                    return
                end
            else
                SMODS.RunSelect.Setup.choices[page_def.key] = choice.config.center.key
            end
            if SMODS.RunSelect.Internals.preview_area then SMODS.RunSelect.Functions.populate_preview_ui(page_def.key, choice.config.center.key, page_def.silent) end
        else
            SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] = SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] - 1
            if SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] <= 0 then
                SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key] = nil
            end
            start_table_ref[choice.config.center.key] = SMODS.RunSelect.Setup.choices[page_def.key][choice.config.center.key]

            if SMODS.RunSelect.Internals.preview_area then SMODS.RunSelect.Functions.populate_preview_ui(page_def.key, choice, page_def.silent, true) end
        end
    end
end