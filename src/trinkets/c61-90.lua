-- Golden Horse Shoe 82
TBOJ.Trinket {
  key = "golden_horse_shoe",
  pos = { x = 6, y = 5 },
  cost = 4,
  config = {extra = {num = 1, den = 7}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_golden_horse_shoe")
    return {vars = {num, den}}
  end,
  calculate = function(self, card, context)
    if context.reroll_shop or context.starting_shop then
      if SMODS.pseudorandom_probability(card, "tboj_golden_horse_shoe", card.ability.extra.num, card.ability.extra.den, "tboj_golden_horse_shoe") then
        local _card = SMODS.create_card({set = "Joker", area = G.shop_jokers})
        TBOJ.add_to_shop(_card,localize("tboj_lucky_ex"))
      end
    end
  end,
}

-- NO! 88
TBOJ.Trinket {
  key = "no",
  pos = { x = 12, y = 5 },
  cost = 5,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.tboj_active_rate = 0
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.tboj_active_rate = 4
  end,
}

-- Child Leash 89
TBOJ.Trinket {
  key = "child_leash",
  pos = { x = 13, y = 5 },
  cost = 6,
  config = {extra = {Xmult_multi = 1.2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  calculate = function(self, card, context)
    if context.other_joker and (context.other_joker.config.center.familiar) then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
}

-- Brown Cap 90