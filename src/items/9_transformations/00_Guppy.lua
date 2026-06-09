SMODS.Joker {
  key = "transformation_guppy",
  atlas = "transformations",
  pos = {x = 0, y = 0},
  soul_atlas = "transformations",
  soul_pos = {x = 4, y = 0},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    return {vars = {}}
  end,
  rarity = "tboj_transformation",
  cost = 0,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.hand_drawn and not context.blueprint then
      for _ = 1, #context.hand_drawn do
        local _card = SMODS.create_card {
          set = "tboj_spiderfly",
          key = "spiderfly_tboj_pretty_fly",
          area = G.flies
        }
        _card:add_to_deck()
        G.flies:emplace(_card)
      end
      SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, card)
    end

    if context.other_drawn and not context.blueprint then
      for _ = 1, #context.hand_drawn do
        local _card = SMODS.create_card {
          set = "tboj_spiderfly",
          key = "spiderfly_tboj_pretty_fly",
          area = G.flies
        }
        _card:add_to_deck()
        G.flies:emplace(_card)
      end
      SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, card)
    end
  end,
  in_pool = function(self, args)
    return false
  end,
  attributes = {"tboj_transformation"}
}