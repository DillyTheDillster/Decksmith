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
        n=G.UIT.C, config = { align = 'bm', padding = 0.15}, nodes = {
            {n=G.UIT.R, config = {align = 'cm', padding = 0.1}, nodes = label_nodes},
            {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                    create_text_input {
                    id = value .. '_input',
                    prompt_text = args.text or args.label,
                    w = args.w or 2.5,
                    all_caps = args.all_caps or true,
                    ref_table = args.ref_table or Decksmith.start_args,
                    ref_value = value,
                    colour = args.colour,
                    hooked_colour = args.hooked_colour or args.colour and darken(args.colour, 0.3)
                }
            }},
        }
    }
    return t
end
