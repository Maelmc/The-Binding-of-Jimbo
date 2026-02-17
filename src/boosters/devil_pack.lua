SMODS.Booster {
  key = "devil_pack_1",
	kind = "Deal",
	atlas = "boosters",
	pos = { x = 0, y = 0 },
	config = { extra = 4, choose = 1 },
	cost = 4,
	order = 1,
	weight = 1,
  draw_hand = false,
  unlocked = true,
  discovered = false,
	create_card = function(self, card, i)
    if i == 1 then -- first card is an active
      local _k = TBOJ.get_random_key{set = "tboj_active", tags = "devil", seed = "devil_pack"}
      return SMODS.create_card { set = "tboj_active", area = G.pack_cards, skip_materialize = true, key = _k }
    else
      if pseudorandom('soul_devil'..G.GAME.round_resets.ante) > 0.997 then
        local _k = TBOJ.get_random_key{set = "Joker", tags = "angel", target_rarities = {4}, seed = "devil_pack"}
        return SMODS.create_card { set = "Joker", area = G.pack_cards, skip_materialize = true, key = _k }
      else
        local _k = TBOJ.get_random_key{set = "Joker", tags = "devil", seed = "devil_pack"}
        return SMODS.create_card { set = "Joker", area = G.pack_cards, skip_materialize = true, key = _k }
      end
    end
  end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra - 1, 1 } }
	end,
	group_key = "k_tboj_devil_pack",
  ease_background_colour = function(self)
    ease_background_colour{new_colour = G.C.TBOJ.DEVIL, contrast = 3}
  end,
  particles = function(self)
    G.booster_pack_stars = Particles(1, 1, 0,0, {
      timer = 0.07,
      scale = 0.1,
      initialize = true,
      lifespan = 15,
      speed = 0.1,
      padding = -4,
      attach = G.ROOM_ATTACH,
      colours = G.C.TBOJ.DEVIL_PARTICLE,
      fill = true
    })
	end,
}