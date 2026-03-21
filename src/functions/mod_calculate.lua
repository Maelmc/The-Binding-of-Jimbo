SMODS.current_mod.calculate = function(self, context)
  if G.GAME.modifiers.tboj_aprils_fool and context.buying_card then
    TBOJ.reroll(context.card,TBOJ.get_random_key({set = context.card.ability.set, seed = "tboj_aprils_fools" .. G.GAME.round_resets.ante}),true)
  end

  if G.GAME.modifiers.tboj_aprils_fool and context.using_active then
    TBOJ.reroll(context.active,TBOJ.get_random_key({set = context.active.ability.set, seed = "tboj_aprils_fools" .. G.GAME.round_resets.ante}))
    if context.active.ability.extra.curr_charge then context.active.ability.extra.curr_charge = 0 end
  end
end