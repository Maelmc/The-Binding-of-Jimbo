SMODS.Blind {
  key = "bloat",
  dollars = 5,
  mult = 2,
  boss = { showdown = false, min = 3, max = 80 },
  boss_colour = HEX("BFB3B3"),
  pos = { x = 0, y = 2 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.press_play then
        ease_hands_played(-1)
        blind:juice_up()
      end

      if context.discard then
        ease_discard(-1)
        blind:juice_up()
      end
    end
  end,
  tboj_artist = "Maelmc"
}