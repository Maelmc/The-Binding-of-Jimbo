SMODS.Sticker {
  key = "cursed",
  badge_colour = HEX('8E54F2'),
  atlas = "tboj_stickers",
  pos = { x = 0, y = 0 },
  config = {
    perish_start = 5,
    perish_tally = 5
  },
  needs_enable_flag = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.tboj_cursed.perish_start, card.ability.tboj_cursed.perish_start ~= 1 and "s" or "", card.ability.tboj_cursed.perish_tally } }
  end,
  should_apply = function(self, card, center, area, bypass_roll)
    return false
  end,
  apply = function(self, card, val)
    SMODS.Sticker.apply(self, card, val)
    card.ability.eternal = nil
    card.ability.perishable = nil
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false then
      if card.ability.tboj_cursed.perish_tally > 0 then
        if card.ability.tboj_cursed.perish_tally == 1 then
          SMODS.destroy_cards(card, {bypass_eternal = true})
          SMODS.calculate_effect({message = localize("tboj_cursed_ex"), colour = G.C.TBOJ.CURSED}, card)
        else
          card.ability.tboj_cursed.perish_tally = card.ability.tboj_cursed.perish_tally - 1
          return {
            message = localize { type = 'variable', key = 'a_remaining', vars = { card.ability.tboj_cursed.perish_tally } },
            colour = G.C.FILTER,
            delay = 0.45
          }
        end
      end
    end
  end
}

local smods_is_eternal_ref = SMODS.is_eternal
function SMODS.is_eternal(card, trigger, ...)
  return card.ability.tboj_cursed or smods_is_eternal_ref(card, trigger, ...)
end