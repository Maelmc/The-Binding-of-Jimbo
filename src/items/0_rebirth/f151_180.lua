-- Habit
SMODS.Joker {
  key = "habit",
  pos = {x = 5, y = 10 },
  config = {extra = {charge = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.charge}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_left == 0 then
      if G.actives.cards[1] and G.actives.cards[1].ability.extra.curr_charge then
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
            card:juice_up()
            return true
          end
        }))
        TBOJ.charge_active(G.actives.cards[1],card.ability.extra.charge)
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true,
}