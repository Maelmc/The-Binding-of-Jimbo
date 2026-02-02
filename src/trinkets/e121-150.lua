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