-- 'M
TBOJ.Trinket {
  key = "m",
  pos = { x = 2, y = 9 },
  cost = 5,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {}}
  end,
  calculate = function(self, card, context)
    if context.using_active then
      TBOJ.reroll(context.active,TBOJ.get_random_key({set = context.active.ability.set, seed = "m" .. G.GAME.round_resets.ante}))
      if context.active.ability.extra.curr_charge then context.active.ability.extra.curr_charge = 0 end
    end
  end,
}

-- Teardrop Charm
-- Apple of Sodom
-- Forgotten Lullaby
-- Beth's Faith
-- Old Capacitor
-- Brain Worm
TBOJ.Trinket {
  key = "brain_worm",
  pos = { x = 8, y = 9 },
  cost = 6,
  config = {extra = {repetitions = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.repetitions}}
  end,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == "unscored" then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end,
}