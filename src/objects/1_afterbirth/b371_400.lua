-- Holy Light
SMODS.Joker {
  key = "holy_light",
  pos = {x = 13, y = 24},
  config = {extra = {Xmult_multi = 2, num = 1, den = 5}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_holy_light")
    return {vars = {num, den, card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, "tboj_holy_light", card.ability.extra.num, card.ability.extra.den, "tboj_holy_light") then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true,
}

-- Seraphim
SMODS.Joker {
  key = "seraphim",
  pos = {x = 14, y = 25},
  config = {extra = {Xmult_multi = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.pre_splash then
      local _card = copy_card(G.play.cards[1])
      _card.seraphim_target = true
      _card.states.visible = false
      _card:add_to_deck()
      G.deck.config.card_limit = G.deck.config.card_limit + 1
      G.play:emplace(_card)
      G.E_MANAGER:add_event(Event({
        func = function()
          _card:start_materialize()
          if context.blueprint_card then
            context.blueprint_card:juice_up()
          else
            card:juice_up()
          end
          return true
        end
      }))
      playing_card_joker_effects(_card)
    end

    if context.individual and context.other_card.seraphim_target then
      return {
        colour = G.C.MULT,
        Xmult = card.ability.extra.Xmult_multi
      }
    end

    if context.destroy_card and not context.blueprint then
      if context.destroy_card.seraphim_target then return {remove = true} end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  familiar = true,
  angel = true,
}