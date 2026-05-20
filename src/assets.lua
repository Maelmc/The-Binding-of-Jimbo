-- Atlases
SMODS.Atlas({
  key = "modicon",
  path = "icon.png",
  px = 32,
  py = 32
})

SMODS.Atlas({
  key = "jokers",
  path = "jokers.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "soul_jokers",
  path = "soul_jokers.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "multisprites",
  path = "multisprites.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "consumables",
  path = "consumables.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "backs",
  path = "backs.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "stakes",
  path = "stakes.png",
  px = 29,
  py = 29
})

SMODS.Atlas({
  key = "stake_stickers",
  path = "stake_stickers.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "enhancements",
  path = "enhancements.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "trinkets",
  path = "trinkets.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "boss_blinds",
  atlas_table = "ANIMATION_ATLAS",
  path = "boss_blinds.png",
  px = 34,
  py = 34,
  frames = 21,
})

SMODS.Atlas({
  key = "undiscovered",
  path = "undiscovered.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
    key = "boosters",
    path = "boosters.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "spiderfly",
    path = "spiderfly.png",
    px = 44,
    py = 24
})

SMODS.Atlas({
  key = "wiki",
  path = "wiki.png",
  px = 53,
  py = 53
})

-- Colors
G.C.TBOJ = {
  FAMILIAR = HEX("E70000"),
  FLY = HEX("777777"),
  POOP = HEX("875D5A"),
  LOOT = HEX("C3D5D5"),
  LOOT_DARK = HEX("95ACAD"),
  DEVIL = HEX("434343"),
  DEVIL_PARTICLE = {HEX("540903"), HEX("3A0812"), HEX("71031B")},
  ANGEL = HEX("2B5167"),
  ANGEL_PARTICLE = {HEX("B9BF19"), HEX("A73213"), HEX("A71313")},
  MOD_COLOR = HEX("E3C6C5"),
}

local lc = loc_colour
function loc_colour(_c, _default)
  if not G.ARGS.LOC_COLOURS then
    lc()
  end
  G.ARGS.LOC_COLOURS["tboj_loot"] = HEX("95ACAD")
  return lc(_c, _default)
end
loc_colour()