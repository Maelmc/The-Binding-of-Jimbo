SMODS.Booster {
  key = "devil_pack_1",
	kind = "tboj_deal",
	atlas = "boosters",
	pos = { x = 0, y = 0 },
	config = { extra = 4, choose = 1 },
	cost = 6,
	order = 1,
	weight = 0.5,
  draw_hand = false,
  unlocked = true,
  discovered = false,
	create_card = function(self, card, i)
    if i == 1 then -- first card is an active
      local _k = TBOJ.get_random_key{set = "tboj_active", attributes = {"any", {"tboj_devil", "tboj_guppy"}}, seed = "tboj_devil_pack"}
      return SMODS.create_card { set = "tboj_active", area = G.pack_cards, skip_materialize = true, key = _k }
    else
      if pseudorandom('soul_devil'..G.GAME.round_resets.ante) > 0.997 then
        local _k = TBOJ.get_random_key{set = "Joker", attributes = {"any", {"tboj_devil", "tboj_guppy"}}, target_rarities = {4, "Legendary"}, seed = "tboj_devil_pack"}
        return SMODS.create_card { set = "Joker", area = G.pack_cards, skip_materialize = true, key = _k }
      else
        local _k = TBOJ.get_random_key{set = "Joker", attributes = {"any", {"tboj_devil", "tboj_guppy"}}, seed = "tboj_devil_pack"}
        return SMODS.create_card { set = "Joker", area = G.pack_cards, skip_materialize = true, key = _k }
      end
    end
  end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.choose + (G.GAME.modifiers.booster_choice_mod or 0), card.ability.extra - 1, 1 } }
	end,
	group_key = "k_tboj_devil_pack",
  ease_background_colour = function(self)
    ease_background_colour{new_colour = G.C.TBOJ.DEVIL, contrast = 3}
  end,
  particles = function(self)
    G.booster_pack_stars = Particles(1, 1, 0,0, {
      timer = 0.015,
      scale = 0.2,
      initialize = true,
      lifespan = 1,
      speed = 1.1,
      padding = -1,
      attach = G.ROOM_ATTACH,
      colours = G.C.TBOJ.DEVIL_PARTICLE,
      fill = true
    })
	end,
  select_card = {
    ['Joker'] = 'jokers',
    ['tboj_active'] = 'actives',
  }
}