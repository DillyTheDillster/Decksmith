Decksmith.customize_menu = SMODS.RunSelectPage:extend {
    automatic_preview = false,
    optional = function() return SMODS.RunSelect.Setup.choices.deck_choice == 'b_ds_custom' end,
}

Decksmith.customize_menu {
    key = 'general',
    definition = function(self)
        Decksmith.start_args.ds_joker_slots = tonumber(Decksmith.start_args.ds_joker_slots) or 5
        Decksmith.start_args.ds_consumable_slots = tonumber(Decksmith.start_args.ds_consumable_slots) or 2
        Decksmith.start_args.ds_shop_slots = tonumber(Decksmith.start_args.ds_shop_slots) or 2
        Decksmith.start_args.ds_ante_scaling = tonumber(Decksmith.start_args.ds_ante_scaling) or 1
        Decksmith.start_args.ds_winning_ante = tonumber(Decksmith.start_args.ds_winning_ante) or 8

        return Decksmith.create_menu_page({
            key = 'k_ds_general',
            no_reset = true, -- EXAMPLE
            options = {
                {'ds_joker_slots'},
                {'ds_consumable_slots'},
                {'ds_shop_slots'},
                {'spacer'},
                {'ds_winning_ante'},
                {'ds_ante_scaling'}
            }
        })
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
    definition = function(self)
        Decksmith.start_args.ds_starting_dollars = tonumber(Decksmith.start_args.ds_starting_dollars) or 4
        Decksmith.start_args.ds_reroll_cost = tonumber(Decksmith.start_args.ds_reroll_cost) or 5
        Decksmith.start_args.ds_dollars_per_hand = tonumber(Decksmith.start_args.ds_dollars_per_hand) or 1
        Decksmith.start_args.ds_dollars_per_discard = tonumber(Decksmith.start_args.ds_dollars_per_discard) or 0
        Decksmith.start_args.ds_interest_amount = tonumber(Decksmith.start_args.ds_interest_amount) or 1
        Decksmith.start_args.ds_interest_cap = tonumber(Decksmith.start_args.ds_interest_cap) or 5
        Decksmith.start_args.ds_discount_percentage = tonumber(Decksmith.start_args.ds_discount_percentage) or 0
        Decksmith.start_args.ds_discard_cost = tonumber(Decksmith.start_args.ds_discard_cost) or 0


        return Decksmith.create_menu_page({
            key = 'k_ds_money',
            options = {
                {'ds_starting_dollars', {no_random = true}}, -- EXAMPLE
                {'ds_interest_amount', {no_reset = true}}, -- EXAMPLE
                {'ds_interest_cap'},
                {'spacer'},
                {'ds_dollars_per_hand'},
                {'ds_dollars_per_discard'},
                {'ds_discard_cost'},
                {'spacer'},
                {'ds_reroll_cost'},
                {'ds_discount_percentage'}
            }
        })
        
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
    definition = function(self)
        Decksmith.start_args.ds_joker_rate = tonumber(Decksmith.start_args.ds_joker_rate) or 20
        Decksmith.start_args.ds_tarot_rate = tonumber(Decksmith.start_args.ds_tarot_rate) or 4
        Decksmith.start_args.ds_planet_rate = tonumber(Decksmith.start_args.ds_planet_rate) or 4
        Decksmith.start_args.ds_spectral_rate = tonumber(Decksmith.start_args.ds_spectral_rate) or 0
        Decksmith.start_args.ds_pcard_rate = tonumber(Decksmith.start_args.ds_pcard_rate) or 0

        return Decksmith.create_menu_page({
            key = 'k_ds_rates',
            no_random = true, -- EXAMPLE
            options = {
                {'ds_joker_rate'},
                {'ds_tarot_rate'},
                {'ds_planet_rate'},
                {'ds_spectral_rate'},
                {'ds_pcard_rate'}
            }
        })
    end,
    start_run = function(self, choice)
        G.GAME.joker_rate = tonumber(Decksmith.start_args.ds_joker_rate) or G.GAME.joker_rate

        G.GAME.tarot_rate = tonumber(Decksmith.start_args.ds_tarot_rate) or G.GAME.tarot_rate

        G.GAME.planet_rate = tonumber(Decksmith.start_args.ds_planet_rate) or G.GAME.planet_rate

        G.GAME.spectral_rate = tonumber(Decksmith.start_args.ds_spectral_rate)or G.GAME.spectral_rate

        G.GAME.playing_card_rate = tonumber(Decksmith.start_args.ds_pcard_rate) or G.GAME.playing_card_rate
    end
}

Decksmith.customize_menu({
    key = 'starting_jokers',
    automatic_preview = true,
    random_select = true,
    double_click_advance = false,
    selection_limit = function() return tonumber(Decksmith.start_args.ds_joker_slots) or Decksmith.defaults.ds_joker_slots.reset end,
    generate_pool = function(self) return G.P_CENTER_POOLS.Joker end,
    selected_text = function(self, selection)
        if not selection then selection = {} end
        local selected = SMODS.table_size(selection)
        return self:selection_limit() - selected .. ' Jokers Remaining'
    end,
    start_run = function(self, choice)
        for k, _ in pairs(choice) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    local c = SMODS.add_card({key = k, skip_materialize = true})
                    c:start_materialize()
                    return true
                end
            }))
        end
    end,
    handle_choice = function(self, choice, remove)
        SMODS.RunSelectPage.handle_choice(self, choice, remove)
        if remove then
            Decksmith.start_args.ds_starting_jokers[choice.config.center.key] = Decksmith.start_args.ds_starting_jokers[choice.config.center.key] - 1
            if Decksmith.start_args.ds_starting_jokers[choice.config.center.key] <= 0 then
                Decksmith.start_args.ds_starting_jokers[choice.config.center.key] = nil
            end
        elseif not Decksmith.start_args.ds_starting_jokers[choice.config.center.key] then
            Decksmith.start_args.ds_starting_jokers[choice.config.center.key] = 1
        else
            Decksmith.start_args.ds_starting_jokers[choice.config.center.key] = Decksmith.start_args.ds_starting_jokers[choice.config.center.key] + 1
        end
    end,
    choose_random = function(self)
        local choices = SMODS.RunSelect.Setup.choices[self.key] or {}
        if self.selection_limit() > SMODS.table_size(choices) then
            local options = {}
            for i=1, #self.pool do
                if self.pool[i].unlocked then
                    options[#options + 1] = self.pool[i].key
                end
            end

            local selected = pseudorandom_element(options, pseudoseed(os.time()))
            play_sound('whoosh1', math.random()*0.2 + 0.99, 0.35)
            self:handle_choice({config = {center = {key = selected}}})
        end
    end,
    set_default = function(self, choice)
        Decksmith.start_args.ds_starting_jokers = {}
        return nil
    end,
})

Decksmith.customize_menu({
    key = 'starting_vouchers',
    grid_size = {2, 2},
    automatic_preview = true,
    random_select = true,
    selection_limit = #G.P_CENTER_POOLS.Voucher,
    include_deck_preview = true,
    double_click_advance = false,
    generate_pool = function(self) return G.P_CENTER_POOLS.Voucher end,
    selected_text = function(self, selection)
        return localize('run_select_ds_starting_vouchers') -- tried to make this dynamic but gave up lol
    end,
    start_run = function(self, choice)
        for k, _ in pairs(choice) do
            G.GAME.used_vouchers[k] = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.5,
                func = function()
                    local voucher_card = SMODS.create_card({area = G.play, key = k})
                    voucher_card:add_to_deck()
                    voucher_card:start_materialize()
                    voucher_card.cost = 0
                    G.play:emplace(voucher_card)

                    voucher_card:redeem()
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            voucher_card:start_dissolve()
                            return true
                        end
                    }))

                    delay(1)

                    return true
                end
            }))
        end
    end,
    handle_choice = function(self, choice, remove)
        SMODS.RunSelectPage.handle_choice(self, choice, remove)
        if remove then
            Decksmith.start_args.ds_starting_vouchers[choice.config.center.key] = nil
        else
            Decksmith.start_args.ds_starting_vouchers[choice.config.center.key] = true
        end
    end,
    choose_random = function(self)
        local choices = SMODS.RunSelect.Setup.choices[self.key] or {}
        if self.selection_limit > SMODS.table_size(choices) then
            local options = {}
            for i=1, #self.pool do
                if self.pool[i].unlocked then
                    options[#options + 1] = self.pool[i].key
                end
            end

            local selected = false
            while not selected do
                selected = pseudorandom_element(options, pseudoseed(os.time()))
                if (selected == choices or choices[selected]) and #options > 1 then selected = false end
            end
            play_sound('whoosh1', math.random()*0.2 + 0.99, 0.35)
            self:handle_choice({config = {center = {key = selected}}})
        end
    end,
    set_default = function(self, choice)
        Decksmith.start_args.ds_starting_vouchers = {}
        return nil
    end,
})
