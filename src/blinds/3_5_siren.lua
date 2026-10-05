SMODS.Blind {
  key = "siren",
  dollars = 5,
  mult = 2,
  boss = { showdown = false, min = 4, max = 80 },
  boss_colour = HEX("515151"),
  pos = { x = 0, y = 1 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function (self, blind, context)
    if context.blind_disabled or context.blind_defeated then
      for _, joker in ipairs(G.jokers.cards) do
        joker.ability.tboj_siren_target = nil
      end
    end

    if blind.disabled then return end

    if context.debuff_card and context.debuff_card.area == G.jokers then
      if context.debuff_card.ability.tboj_siren_target then
        return {
          debuff = true
        }
      end
    end

    if context.press_play and G.jokers.cards[1] then
      blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
      blind.prepped = true
    end

    if context.hand_drawn then
      if blind.prepped and G.jokers.cards[1] then
        local prev_chosen_set = {}
        local fallback_jokers = {}
        local jokers = {}

        for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].ability.tboj_siren_target then
            prev_chosen_set[G.jokers.cards[i]] = true
            G.jokers.cards[i].ability.tboj_siren_target = nil
            if G.jokers.cards[i].debuff then SMODS.recalc_debuff(G.jokers.cards[i]) end
          end
        end

        for i = 1, #G.jokers.cards do
          if not G.jokers.cards[i].debuff and G.jokers.cards[i]:has_attribute("tboj_familiar") then
            if not prev_chosen_set[G.jokers.cards[i]] then
              jokers[#jokers + 1] = G.jokers.cards[i]
            end
            table.insert(fallback_jokers, G.jokers.cards[i])
          end
        end

        if #jokers == 0 then jokers = fallback_jokers end
        local _card = pseudorandom_element(jokers, 'tboj_siren')
        if _card then
          _card.ability.tboj_siren_target = true
          SMODS.recalc_debuff(_card)
          _card:juice_up()
          blind:wiggle()
        end

      end
      blind.prepped = nil
    end
  end,
  tboj_artist = "Maelmc"
}