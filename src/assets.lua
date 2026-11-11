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

SMODS.Atlas({
    key = "transformations",
    path = "transformations.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "tags",
    path = "tags.png",
    px = 34,
    py = 34
})

SMODS.Atlas({
    key = "stickers",
    path = "stickers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
  key = "the_beast",
  path = "the_beast.png",
  px = 140,
  py = 188
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
  GUPPY = HEX("636363"),
  BOOK = HEX("6F5146"),
  SPIDER = HEX("557293"),
  CURSED = HEX("8E54F2"),
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

-- Sounds
SMODS.Sound({
    key = "transformation",
    path = "transformation.wav"
})

SMODS.Sound({
    key = "bone_break_01",
    path = "bone_break_01.wav"
})

SMODS.Sound({
    key = "bone_break_02",
    path = "bone_break_02.wav"
})

SMODS.Sound({
    key = "bone_break_03",
    path = "bone_break_03.wav"
})

SMODS.Sound({
    key = "bone_heart",
    path = "bone_heart.wav"
})

SMODS.Sound({
    key = "mom_isaac",
    path = "mom_isaac.wav"
})

SMODS.Sound({
    key = "mom_grunt",
    path = "mom_grunt.wav"
})

SMODS.Sound({
    key = "mom_laugh",
    path = "mom_laugh.wav"
})

-- Music
SMODS.Sound({
  key = "planetarium_music",
  path = "planetarium_music.ogg",
	select_music_track = function()
    return G.STATE and G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.label == "p_tboj_planetarium_pack_1"
	end,
  sync = false,
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "the_end_beast_music",
  path = "the_end_beast_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_the_beast" and next(SMODS.find_card("j_tboj_the_beast")) then
      return 1
    end
  end,
  sync = {
    ['tboj_the_end_death_music'] = true,
    ['tboj_the_end_famine_music'] = true,
    ['tboj_the_end_pestilence_music'] = true,
    ['tboj_the_end_war_music'] = true,
  },
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "the_end_death_music",
  path = "the_end_death_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_the_beast" and next(SMODS.find_card("j_tboj_ultra_death")) then
      return 1
    end
  end,
  sync = {
    ['tboj_the_end_beast_music'] = true,
    ['tboj_the_end_famine_music'] = true,
    ['tboj_the_end_pestilence_music'] = true,
    ['tboj_the_end_war_music'] = true,
  },
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "the_end_famine_music",
  path = "the_end_famine_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_the_beast" and next(SMODS.find_card("j_tboj_ultra_famine")) then
      return 1
    end
  end,
  sync = {
    ['tboj_the_end_beast_music'] = true,
    ['tboj_the_end_death_music'] = true,
    ['tboj_the_end_pestilence_music'] = true,
    ['tboj_the_end_war_music'] = true,
  },
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "the_end_pestilence_music",
  path = "the_end_pestilence_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_the_beast" and next(SMODS.find_card("j_tboj_ultra_pestilence")) then
      return 1
    end
  end,
  sync = {
    ['tboj_the_end_beast_music'] = true,
    ['tboj_the_end_death_music'] = true,
    ['tboj_the_end_famine_music'] = true,
    ['tboj_the_end_war_music'] = true,
  },
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "the_end_war_music",
  path = "the_end_war_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_the_beast" and next(SMODS.find_card("j_tboj_ultra_war")) then
      return 1
    end
  end,
  sync = {
    ['tboj_the_end_beast_music'] = true,
    ['tboj_the_end_death_music'] = true,
    ['tboj_the_end_famine_music'] = true,
    ['tboj_the_end_pestilence_music'] = true,
  },
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "delirium_fight_music",
  path = "delirium_fight_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_delirium" then
      return 1
    end
  end,
  sync = false,
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "satan_fight_music",
  path = "satan_fight_music.ogg",
  select_music_track = function()
    if G.GAME.blind and (G.GAME.blind.name == "bl_tboj_satan" or G.GAME.blind.name == "bl_tboj_mega_satan") then
      return 1
    end
  end,
  sync = false,
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "morituros_intro_music",
  path = "morituros_intro_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_hush" then
      if not TBOJ.music.hush then
        TBOJ.music.hush = G.TIMERS.REAL
      end
      return 1
    end
  end,
  sync = false,
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "morituros_loop_music",
  path = "morituros_loop_music.ogg",
  select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_hush" then
      if TBOJ.music.hush then
        local elapsed = G.TIMERS.REAL - TBOJ.music.hush
        if elapsed > 6.36666 then
          return 2
        end
        return false
      end
    end
  end,
  sync = false,
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "morituros_outro_music",
  path = "morituros_outro_music.ogg",
  select_music_track = function()
    if ((not G.GAME.blind) or (G.GAME.blind and G.GAME.blind.name ~= "bl_tboj_hush")) and (TBOJ.music.hush or TBOJ.music.hush_outro) then
      TBOJ.music.hush = nil
      if TBOJ.music.hush_outro then
        local elapsed = G.TIMERS.REAL - TBOJ.music.hush_outro
        if elapsed <= 4.9 then
          return 1
        else
          TBOJ.music.hush_outro = nil
          return false
        end
      else
        TBOJ.music.hush_outro = G.TIMERS.REAL
        return 1
      end
    end
  end,
  sync = false,
  pitch = 1,
  volume = 0.7,
})

SMODS.Sound({
  key = "mom_fight_music",
  path = "mom_fight_music.ogg",
	select_music_track = function()
    if G.GAME.blind and G.GAME.blind.name == "bl_tboj_mom" then
      return 1
    end
	end,
  sync = false,
  pitch = 1,
  volume = 0.7,
})