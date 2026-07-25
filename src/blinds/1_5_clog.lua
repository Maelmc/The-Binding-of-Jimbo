SMODS.Blind {
  key = "clog",
  dollars = 5,
  mult = 2,
  boss = { showdown = false, min = 2, max = 80 },
  boss_colour = HEX("7C6E66"),
  pos = { x = 0, y = 18 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
  end,
  calculate = function(self, blind, context)
    if context.before and #G.hand.cards > 0 then
      if pseudorandom("tboj_clog", 0, 1) == 0 then -- up
        TBOJ.juice_flip_hand(blind, false, true)
        for i=1, #G.hand.cards do
          G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() assert(SMODS.modify_rank(G.hand.cards[i], 1));return true end }))
        end
        TBOJ.juice_flip_hand(blind, true, true)
      else -- down
        TBOJ.juice_flip_hand(blind, false, false)
        for i=1, #G.hand.cards do
          G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() assert(SMODS.modify_rank(G.hand.cards[i], -1));return true end }))
        end
        TBOJ.juice_flip_hand(blind, true, false)
      end
    end
  end,
  tboj_artist = "Maelmc"
}