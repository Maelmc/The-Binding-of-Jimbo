-- Meat Cleaver
TBOJ.Active {
  key = "meat_cleaver",
  pos = { x = 0, y = 42 },
  cost = 5,
  config = {extra = {max_charge = 3, curr_charge = 3, max_highlighted = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {
      card.ability.extra.curr_charge, card.ability.extra.max_charge,
      card.ability.extra.max_highlighted,
    }}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    if card.ability.extra.curr_charge >= card.ability.extra.max_charge
    and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted then
      for i = 1, #G.hand.highlighted do
        if SMODS.has_no_rank(G.hand.highlighted[i]) then return false end
      end
      return true
    end
  end,
  use = function(self, card, area, copier)
    local new_cards = {}
    for i = 1, #G.hand.highlighted do
      for j = 1, 2 do
        local _card = copy_card(G.hand.highlighted[i])
        local target_rank
        if _card:get_id() <= 13 and _card:get_id() >= 11 then target_rank = 5
        elseif _card:get_id() == 14 then target_rank = 5.5
        elseif _card:get_id() <= 10 and _card:get_id() >= 2 then target_rank = _card:get_id()/2 end
        if j == 1 then target_rank = math.ceil(target_rank) else target_rank = math.floor(target_rank) end
        if target_rank == 1 then target_rank = "Ace" end
        if target_rank then
          assert(SMODS.change_base(_card, nil, tostring(target_rank)))
          --G.playing_card = (G.playing_card and G.playing_card + 1) or 1
          --_card:add_to_deck()
          --G.deck.config.card_limit = G.deck.config.card_limit + 1
          --G.hand:emplace(_card)
          SMODS.add_to_deck(_card, {area = G.hand})
          _card:start_materialize()
          new_cards[#new_cards + 1] = _card
        end
      end
      SMODS.destroy_cards(G.hand.highlighted[i])
    end
    SMODS.calculate_effect({message = localize("tboj_cleaved_ex")}, card)
    SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"destroy_card", "generation", "rank"},
}

-- Akeldama
-- Magic Skin
-- Revelation
SMODS.Joker {
  key = "revelation",
  atlas = "jokers",
  pos = {x = 12, y = 42},
  soul_atlas = "soul_jokers",
  soul_pos = {x = 12, y = 42},
  config = {extra = {Xmult = 1, Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
  end,
  rarity = 4,
  cost = 20,
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.hand_drawn and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'Xmult',
        scalar_value = 'Xmult_mod',
        operation = function(ref_table, ref_value, initial, change)
          ref_table[ref_value] = initial + #context.hand_drawn*change
        end,
        message_key = 'a_xmult',
      })
    end

    if context.other_drawn and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'Xmult',
        scalar_value = 'Xmult_mod',
        operation = function(ref_table, ref_value, initial, change)
          ref_table[ref_value] = initial + #context.other_drawn*change
        end,
        message_key = 'a_xmult',
      })
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      if card.ability.extra.Xmult > 1 then
        card.ability.extra.Xmult = 1
        return {
          message = localize('k_reset'),
          colour = G.C.RED
        }
      end
    end

    if context.joker_main then
      return {
        xmult = card.ability.extra.Xmult,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "scaling", "xmult", "reset"}
}

-- Consolation Prize
-- Tinytoma

-- Brimstone Bombs
-- 4.5 Volt
-- Fruity Plum
SMODS.Joker {
  key = "fruity_plum",
  pos = {x = 3, y = 43},
  config = {extra = {chips_mod = 2, chips = 0}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips_mod, localize(G.GAME.tboj_fruity_plum_suit or "Spades",'suits_singular'), card.ability.extra.chips,
            colours = {G.C.SUITS[G.GAME.tboj_fruity_plum_suit or "Spades"]},}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:is_suit(G.GAME.tboj_fruity_plum_suit) and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'chips',
        scalar_value = 'chips_mod',
      })
      return nil, true
    end

    if context.joker_main then
      return {
          chips = card.ability.extra.chips
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar", "tboj_fly", "chips", "scaling", "suit"},
  tboj_artist = {"Grumpy Egg", "Maelmc"}
}

-- Plum Flute
-- Star of Bethlehem