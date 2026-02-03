TBOJ = {}

tboj_config = SMODS.current_mod.config

print("START OF TBOJ")

SMODS.current_mod.optional_features = {
  --retrigger_joker = true,
  quantum_enhancements = true,
}

assert(SMODS.load_file("src/assets.lua"))()

local load_directory = assert(SMODS.load_file("src/loader.lua"))()

load_directory("src/functions")
load_directory("src/object types")
load_directory("src/actives")
load_directory("src/backs")
load_directory("src/blinds")
load_directory("src/consumables")
load_directory("src/enhancements")
load_directory("src/objects")
load_directory("src/stakes")
load_directory("src/trinkets")

print("END OF TBOJ")