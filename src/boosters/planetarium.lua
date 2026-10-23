SMODS.Booster {
  key = "planetarium_pack_1",
	kind = "tboj_planetarium",
	atlas = "boosters",
	pos = { x = 2, y = 0 },
	config = { extra = 2, choose = 1 },
	cost = 6,
	order = 1,
	weight = 0,
  draw_hand = false,
  unlocked = true,
  discovered = false,
	create_card = function(self, card, i)
    if not TBOJ.predict_pack_state then
      G.GAME.tboj_planetarium_rate = "fix"
    end
    local _k = SMODS.poll_object({ type = "Joker", attributes = {"tboj_planetarium"}, seed = "tboj_planetarium_pack"..G.GAME.round_resets.ante})
    return SMODS.create_card { set = "Joker", area = G.pack_cards, skip_materialize = true, key = _k }
  end,
	group_key = "k_tboj_planetarium_pack",
  ease_background_colour = function(self)
    ease_background_colour_blind(G.STATES.PLANET_PACK)
  end,
  particles = function(self)
      G.booster_pack_stars = Particles(1, 1, 0, 0, {
          timer = 0.07,
          scale = 0.1,
          initialize = true,
          lifespan = 15,
          speed = 0.1,
          padding = -4,
          attach = G.ROOM_ATTACH,
          colours = { G.C.WHITE, HEX('a7d6e0'), HEX('fddca0') },
          fill = true
      })
      G.booster_pack_meteors = Particles(1, 1, 0, 0, {
          timer = 2,
          scale = 0.05,
          lifespan = 1.5,
          speed = 4,
          attach = G.ROOM_ATTACH,
          colours = { G.C.WHITE },
          fill = true
      })
  end,
  select_card = {
    ['Joker'] = 'jokers',
    ['tboj_Active'] = 'tboj_Actives',
  }
}