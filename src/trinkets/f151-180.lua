-- Flat File
-- Telescope Lens
--[[TBOJ.Trinket {
  key = "telescope_lens",
  pos = { x = 1, y = 10 },
  cost = 4,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hands } }
  end,
  attributes = {"space"}
}]]

-- Mom's Lock
-- Dice Bag
-- Holy Crown
-- Mother's Kiss
TBOJ.Trinket {
  key = "mother_kiss",
  pos = { x = 5, y = 10 },
  cost = 4,
  config = {extra = {hands = 1}},
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hands } }
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
  attributes = {"hands", "passive"}
}

-- Torn Card
-- Torn Pocket

-- Strange Key
-- Lil Clot
-- Temporary Tattoo
TBOJ.Trinket {
  key = "temporary_tattoo",
  pos = { x = 11, y = 11 },
  cost = 5,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    local tags = {'tag_ethereal', 'tag_standard', 'tag_meteor', 'tag_buffoon'}
    local locs = {}
    for _, v in ipairs(tags) do
      locs[#locs+1] = localize({type = "name_text", set = "Tag", key = v})
    end
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_temporary_tattoo_tag_pool', vars = locs}
    return { vars = {} }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and context.beat_boss and context.game_over == false and context.main_eval then
      local tags = {'tag_standard', 'tag_meteor', 'tag_buffoon'}
      local tag = ''
      if pseudorandom('tboj_temporary_tattoo_ethereal') < 1/#tags*2 then
        tag = 'tag_ethereal'
      else
        tag = pseudorandom_element(tags,('tboj_temporary_tattoo'))
      end
      add_tag(Tag(tag))
      play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
      play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
    end
  end,
  attributes = {"tag", "generation", "boss_blind"}
}

-- Swallowed M80
-- RC Remote