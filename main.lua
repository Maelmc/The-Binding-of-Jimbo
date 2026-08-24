TBOJ = {}

TBOJ.config = SMODS.current_mod.config

print("START OF TBOJ")

SMODS.current_mod.optional_features = {
  --retrigger_joker = true,
  quantum_enhancements = true,
  object_weights = true,
}

assert(SMODS.load_file("src/assets.lua"))()

local load_directory = assert(SMODS.load_file("src/loader.lua"))()

load_directory("src/functions")
load_directory("src/object types")
load_directory("src/actives")
load_directory("src/backs")
load_directory("src/blinds")
load_directory("src/boosters")
load_directory("src/challenges")
load_directory("src/consumables")
load_directory("src/enhancements")
load_directory("src/items")
load_directory("src/stakes")
load_directory("src/stickers")
load_directory("src/tags")
load_directory("src/trinkets")
load_directory("src/ui")

print("END OF TBOJ")