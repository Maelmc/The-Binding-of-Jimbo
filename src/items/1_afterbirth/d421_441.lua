-- PJs
-- Head of the Keeper
SMODS.Joker {
  key = "head_of_the_keeper",
  pos = { x = 8, y = 28 },
  config = {extra = {money_mod = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money_mod}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:get_seal() then
      G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money_mod
      return {
        dollars = card.ability.extra.money_mod,
        func = function()
          G.E_MANAGER:add_event(Event({
            func = function()
              G.GAME.dollar_buffer = 0
              return true
            end
          }))
        end
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"economy","seals"},
}

-- Papa Fly
-- Multidimensional Baby
-- Glitter Bomb
-- My Shadow
-- Jar of Flies
TBOJ.Active {
  key = "jar_of_flies",
  pos = { x = 13, y = 28 },
  cost = 4,
  config = {extra = {max_charge = 20, curr_charge = 0}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge > 0
  end,
  use = function(self, card, area, copier)
    for _ = 1, card.ability.extra.curr_charge do
      local _card = SMODS.create_card {
        set = "tboj_spiderfly",
        key = "spiderfly_tboj_pretty_fly",
        area = G.tboj_flies
      }
      _card:add_to_deck()
      G.tboj_flies:emplace(_card)
    end
    SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, card)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"tboj_fly", "generation"}
}

-- Lil Loki
SMODS.Joker {
  key = "lil_loki",
  pos = {x = 14, y = 28},
  config = {extra = {mult_mod = 1, mult = 0, card_count = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult_mod, card.ability.extra.card_count, card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
      }
    end

    if context.before and not context.blueprint and #context.full_hand == card.ability.extra.card_count then
      SMODS.scale_card(card, {
        ref_value = 'mult',
        scalar_value = 'mult_mod',
      })
      return nil, true
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar", "mult", "scaling"}
}

-- Milk!
-- D7