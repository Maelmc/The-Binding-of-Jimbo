-- Swallowed Penny
TBOJ.Trinket {
  key = "swallowed_penny",
  pos = { x = 0, y = 0 },
  cost = 5,
  config = {extra = {money = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money}}
  end,
  calculate = function(self, card, context)
    if context.press_play then
      return {
        dollars = TBOJ.ease_money(card.ability.extra.money, true),
        card = card
      }
    end
  end,
}

-- Petrified Poop
TBOJ.Trinket {
  key = "petrified_poop",
  pos = { x = 1, y = 0 },
  cost = 5,
  config = {extra = {money = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_poop
    return {vars = {card.ability.extra.money}}
  end,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      local poop = 0
      for _, removed_card in ipairs(context.removed) do
        if SMODS.has_enhancement(removed_card,"m_tboj_poop") then poop = poop + 1 end
      end
      if poop > 0 then
        return {
          dollars = TBOJ.ease_money(card.ability.extra.money * poop, true),
          card = card
        }
      end
      end
  end,
}

-- AAA Battery
-- Broken Remote
-- Purple Heart
-- Broken Magnet
-- Rosary Bead
-- Cartridge
-- Pulse Worm
TBOJ.Trinket {
  key = "pulse_worm",
  pos = { x = 8, y = 0 },
  cost = 4,
  config = {extra = {repetitions = 1, targets = {}}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.repetitions}}
  end,
  calculate = function(self, card, context)
    if context.before then
      local pos = {}
      for _, v in pairs(context.scoring_hand) do
        table.insert(pos,v)
      end

      for _ = 1, 3 do
        local i = pseudorandom_element(pos, "pulse_worm")
        if not i then break end
        table.insert(card.ability.extra.targets,i)
        for k, v in ipairs(pos) do
          if v == i then
            table.remove(pos,k)
            break
          end
        end
      end
    end

    if context.after then
      card.ability.extra.targets = {}
    end

    if context.repetition and context.cardarea == G.play and table.contains(card.ability.extra.targets,context.other_card) then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end,
}

-- Wiggle Worm
TBOJ.Trinket {
  key = "wiggle_worm",
  pos = { x = 9, y = 0 },
  cost = 4,
  config = {extra = {repetitions = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.repetitions}}
  end,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and (context.other_card == context.scoring_hand[2] or context.other_card == context.scoring_hand[4]) then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end,
}

-- Ring Worm
-- Flat Worm
TBOJ.Trinket {
  key = "flat_worm",
  pos = { x = 11, y = 0 },
  cost = 4,
  config = {extra = {repetitions = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.repetitions}}
  end,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[3] then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end,
}

-- Store Credit
TBOJ.Trinket {
  key = "store_credit",
  pos = { x = 12, y = 0 },
  cost = 6,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { key = 'tag_coupon', set = 'Tag' }
    return {vars = {card.ability.extra.money}}
  end,
  calculate = function(self, card, context)
    if context.selling_self then
      G.E_MANAGER:add_event(Event({
        func = (function()
          add_tag(Tag('tag_coupon'))
          play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
          play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
          return true
        end)
      }))
      return nil, true -- This is for Joker retrigger purposes
    end
  end,
}

-- Callus
-- Lucky Rock
TBOJ.Trinket {
  key = "lucky_rock",
  pos = { x = 14, y = 0 },
  cost = 5,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    return {vars = {}}
  end,
  calculate = function(self, card, context)
    if context.check_enhancement then
      if SMODS.has_enhancement(context.other_card, 'm_stone') then
          return {m_lucky = true}
      end
    end
  end,
}

-- Mom's Toenail
-- Black Lipstick
-- Bible Tract
-- Paper Clip
-- Monkey Paw
-- Mysterious Paper
-- Daemon's Tail
-- Missing Poster
-- Butt Penny
-- Mysterious Candy
-- Hook Worm
TBOJ.Trinket {
  key = "hook_worm",
  pos = { x = 10, y = 1 },
  cost = 4,
  config = {extra = {repetitions = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.repetitions}}
  end,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and (context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[5]) then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end,
}

-- Whip Worm
-- Broken Ankh
-- Fish Head
-- Pinky Eye