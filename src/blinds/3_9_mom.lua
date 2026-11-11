SMODS.Blind {
  key = "mom",
  dollars = 8,
  mult = 2,
  boss = { showdown = true },
  boss_colour = HEX("BE0030"),
  pos = { x = 0, y = 25 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.before then
        local _target = pseudorandom_element(context.full_hand, "tboj_mom")
        if _target then
          SMODS.destroy_cards(_target)
          local sound_key = pseudorandom_element({"tboj_mom_isaac", "tboj_mom_grunt", "tboj_mom_laugh"}, "tboj_mom_voice")
          G.E_MANAGER:add_event(Event({
            func = function()
              blind:juice_up()
              play_sound(sound_key, nil, 0.7)
              return true
            end
          }))
          return {
            message = localize("tboj_stomp_ex"),
            message_card = _target
          }
        end
      end
    end
  end,
}