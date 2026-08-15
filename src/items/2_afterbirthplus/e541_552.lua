-- Marrow
-- Slipped Rib
-- Hallowed Ground
SMODS.Joker {
  key = "hallowed_ground",
  pos = {x = 2, y = 36 },
  config = {extra = {Xmult_multi = 1.5}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_poop
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if not context.end_of_round and not context.before
      and not context.after and not context.other_card.debuff
      and SMODS.has_enhancement(context.other_card, "m_tboj_poop") then
        return {
          Xmult = card.ability.extra.Xmult_multi,
          card = card
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "tboj_poop", "enhancements", "xmult"}
}

-- Divorce Papers
-- Jaw Bone
-- Brittle Bones
SMODS.Joker {
  key = "brittle_bones",
  pos = {x = 8, y = 36 },
  config = {extra = {chips = 0, chips_mod = 75}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_bone
    return {vars = {card.ability.extra.chips_mod, card.ability.extra.chips}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  enhancement_gate = "m_tboj_bone",
  calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
      local bones = 0
      for _, removed_card in ipairs(context.removed) do
          if SMODS.has_enhancement(removed_card, "m_tboj_bone") then bones = bones + 1 end
      end
      if bones > 0 then
        SMODS.scale_card(card, {
          ref_value = 'chips',
          scalar_value = 'chips_mod',
          operation = function(ref_table, ref_value, initial, change)
            ref_table[ref_value] = initial + bones*change
          end,
        })
        return nil, true
      end
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
  attributes = {"enhancements", "chips"}
}


-- Broken Shovel
-- Broken Shovel 2
-- Mom's Shovel