Decksmith = {}
Decksmith.start_args = {}
Decksmith.mod = SMODS.current_mod

assert(SMODS.load_file('src/cfg.lua'))()
assert(SMODS.load_file('src/deck.lua'))()
assert(SMODS.load_file('src/funcs.lua'))()
assert(SMODS.load_file('src/overrides.lua'))()
assert(SMODS.load_file('src/menus.lua'))()
