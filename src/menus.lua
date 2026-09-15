Decksmith.customize_menu = SMODS.RunSelectPage:extend {
    automatic_preview = false,
    optional = function() return SMODS.RunSelect.Setup.choices.deck_choice == 'b_ds_custom' end,
}

Decksmith.customize_menu {
    key = 'general',
    settings = function(self)
        Decksmith.start_args.ds_joker_slots = tonumber(Decksmith.start_args.ds_joker_slots) or 5
        Decksmith.start_args.ds_consumable_slots = tonumber(Decksmith.start_args.ds_consumable_slots) or 2
        Decksmith.start_args.ds_shop_slots = tonumber(Decksmith.start_args.ds_shop_slots) or 2
        Decksmith.start_args.ds_ante_scaling = tonumber(Decksmith.start_args.ds_ante_scaling) or 1
        Decksmith.start_args.ds_winning_ante = tonumber(Decksmith.start_args.ds_winning_ante) or 8

        return {
            {n = G.UIT.R, nodes = {
                {n=G.UIT.C, config = {align = 'cl', minw = 0.6}, nodes = {{n=G.UIT.T, config = {text = localize('run_select_ds_general'), scale = 0.5, colour = G.C.WHITE, vert = true}}}},
                {n=G.UIT.C, config = {minh = 4, minw = 0.04, colour = G.C.L_BLACK}},
                {n=G.UIT.C, config = {align = 'cm', padding = 0.1}, nodes = {
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                        Decksmith.text_input_element('ds_joker_slots'),
                        Decksmith.text_input_element('ds_consumable_slots'),
                        Decksmith.text_input_element('ds_shop_slots'),
                    }},        
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                        Decksmith.text_input_element('ds_ante_scaling'),
                        Decksmith.text_input_element('ds_winning_ante'),
                    }},
                }}
            }}
        }
    end,
    start_run = function(self, choice)
        -- Ante stuff
        G.GAME.starting_params.ante_scaling = tonumber(Decksmith.start_args.ds_ante_scaling) or 1
        G.GAME.win_ante = to_big(tonumber(Decksmith.start_args.ds_winning_ante) or 8)

        -- Area changing
        G.E_MANAGER:add_event(Event({
            func = function()
                if tonumber(Decksmith.start_args.ds_joker_slots) then
                    G.jokers:change_size(Decksmith.start_args.ds_joker_slots - G.GAME.starting_params.joker_slots)
                end

                if tonumber(Decksmith.start_args.ds_consumable_slots) then
                    G.consumeables:change_size(Decksmith.start_args.ds_consumable_slots - G.GAME.starting_params.consumable_slots)
                end

                if tonumber(Decksmith.start_args.ds_shop_slots) then
                    change_shop_size(Decksmith.start_args.ds_shop_slots - 2)
                end
                return true;
            end
        }))

    end
}

Decksmith.customize_menu {
    key = 'money',
    settings = function(self)
        Decksmith.start_args.ds_starting_dollars = tonumber(Decksmith.start_args.ds_starting_dollars) or 4
        Decksmith.start_args.ds_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or 5
        Decksmith.start_args.ds_dollars_per_hand = tonumber(Decksmith.start_args.ds_dollars_per_hand) or 1
        Decksmith.start_args.ds_dollars_per_discard = tonumber(Decksmith.start_args.ds_dollars_per_discard) or 0
        Decksmith.start_args.ds_interest_amount = tonumber(Decksmith.start_args.ds_interest_amount) or 1
        Decksmith.start_args.ds_interest_cap = tonumber(Decksmith.start_args.ds_interest_cap) or 5
        Decksmith.start_args.ds_discount_percentage = tonumber(Decksmith.start_args.ds_discount_percentage) or 0
        Decksmith.start_args.ds_discard_cost = tonumber(Decksmith.start_args.ds_discard_cost) or 0

        return {
            {n = G.UIT.R, nodes = {
                {n=G.UIT.C, config = {align = 'cl', minw = 0.6}, nodes = {{n=G.UIT.T, config = {text = localize('run_select_ds_money'), scale = 0.5, colour = G.C.WHITE, vert = true}}}},
                {n=G.UIT.C, config = {minh = 4, minw = 0.04, colour = G.C.L_BLACK}},
                {n=G.UIT.C, config = {align = 'cm', padding = 0.1}, nodes = {
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                        Decksmith.text_input_element('ds_starting_dollars'),
                        Decksmith.text_input_element('ds_interest_amount'),
                        Decksmith.text_input_element('ds_interest_cap'),
                    }},
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                        Decksmith.text_input_element('ds_dollars_per_hand'),
                        Decksmith.text_input_element('ds_dollars_per_discard'),
                        Decksmith.text_input_element('ds_discard_cost'),
                    }},
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                        Decksmith.text_input_element('ds_reroll_cost'),
                        Decksmith.text_input_element('ds_discount_percentage'),
                    }},
                }}
            }}
        }
    end,
    start_run = function(self, choice)
        G.GAME.dollars = tonumber(Decksmith.start_args.ds_starting_dollars) or G.GAME.dollars

        -- Why are there three values for this?
        G.GAME.base_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or G.GAME.base_reroll_cost
        G.GAME.round_resets.base_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or G.GAME.round_resets.base_reroll_cost
        G.GAME.current_round.base_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or G.GAME.current_round.base_reroll_cost

        G.GAME.modifiers.money_per_hand = tonumber(Decksmith.start_args.ds_dollars_per_hand) or G.GAME.modifiers.money_per_hand
        G.GAME.modifiers.money_per_discard = tonumber(Decksmith.start_args.ds_dollars_per_discard) or G.GAME.modifiers.money_per_discard

        G.GAME.interest_amount = tonumber(Decksmith.start_args.ds_interest_amount) or G.GAME.interest_amount
        G.GAME.interest_cap = tonumber(Decksmith.start_args.ds_interest_cap) or G.GAME.interest_cap

        G.GAME.discount_percent = tonumber(Decksmith.start_args.ds_discount_percentage) or G.GAME.discount_percent
        G.GAME.modifiers.discard_cost = tonumber(Decksmith.start_args.ds_discard_cost) or G.GAME.modifiers.discard_cost
    end
}

Decksmith.customize_menu {
    key = 'rates',
    settings = function(self)
        Decksmith.start_args.ds_joker_rate = tonumber(Decksmith.start_args.ds_joker_rate) or 20
        Decksmith.start_args.ds_tarot_rate = tonumber(Decksmith.start_args.ds_tarot_rate) or 4
        Decksmith.start_args.ds_planet_rate = tonumber(Decksmith.start_args.ds_planet_rate) or 4
        Decksmith.start_args.ds_spectral_rate = tonumber(Decksmith.start_args.ds_spectral_rate) or 0
        Decksmith.start_args.ds_pcard_rate = tonumber(Decksmith.start_args.ds_pcard_rate) or 0

        return {
            {n = G.UIT.R, nodes = {
                {n=G.UIT.C, config = {align = 'cl', minw = 0.6}, nodes = {{n=G.UIT.T, config = {text = localize('run_select_ds_rates'), scale = 0.5, colour = G.C.WHITE, vert = true}}}},
                {n=G.UIT.C, config = {minh = 4, minw = 0.04, colour = G.C.L_BLACK}},
                {n=G.UIT.C, config = {align = 'cm', padding = 0.1}, nodes = {
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                        Decksmith.text_input_element('ds_joker_rate'),
                        Decksmith.text_input_element('ds_tarot_rate'),
                        Decksmith.text_input_element('ds_planet_rate'),
                    }},
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                        Decksmith.text_input_element('ds_spectral_rate'),
                        Decksmith.text_input_element('ds_pcard_rate'),
                    }},
                }}
            }}
        }
    end,
    start_run = function(self, choice)
        G.GAME.joker_rate = tonumber(Decksmith.start_args.ds_joker_rate) or G.GAME.joker_rate

        G.GAME.tarot_rate = tonumber(Decksmith.start_args.ds_tarot_rate) or G.GAME.tarot_rate

        G.GAME.planet_rate = tonumber(Decksmith.start_args.ds_planet_rate) or G.GAME.planet_rate

        G.GAME.spectral_rate = tonumber(Decksmith.start_args.ds_spectral_rate)or G.GAME.spectral_rate

        G.GAME.playing_card_rate = tonumber(Decksmith.start_args.ds_pcard_rate) or G.GAME.playing_card_rate
    end
}
