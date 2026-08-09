SMODS.Joker {
  key = "transformation_seraphim",
  atlas = "transformations",
  pos = {x = 3, y = 0},
  soul_atlas = "transformations",
  soul_pos = {x = 7, y = 0},
  config = {extra = {to_draw = 50, drawn = 0, on_add = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_soul_heart
    return {vars = {card.ability.extra.on_add, card.ability.extra.to_draw, card.ability.extra.drawn}}
  end,
  rarity = "tboj_transformation",
  cost = 0,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.hand_drawn and not context.blueprint then
      card.ability.extra.drawn = card.ability.extra.drawn + #context.hand_drawn
      while card.ability.extra.drawn >= card.ability.extra.to_draw do
        card.ability.extra.drawn = card.ability.extra.drawn - card.ability.extra.to_draw
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
              G.GAME.consumeable_buffer = 0
              play_sound('timpani')
              SMODS.add_card({key = "c_tboj_soul_heart"})
              return true
            end
          }))
          SMODS.calculate_effect({message = localize('tboj_plus_loot'), colour = G.C.TBOJ.LOOT}, card)
        end
      end
    end

    if context.other_drawn and not context.blueprint then
      card.ability.extra.drawn = card.ability.extra.drawn + #context.other_drawn
      while card.ability.extra.drawn >= card.ability.extra.to_draw do
        card.ability.extra.drawn = card.ability.extra.drawn - card.ability.extra.to_draw
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
              G.GAME.consumeable_buffer = 0
              play_sound('timpani')
              SMODS.add_card({key = "c_tboj_soul_heart"})
              return true
            end
          }))
          SMODS.calculate_effect({message = localize('tboj_plus_loot'), colour = G.C.TBOJ.LOOT}, card)
        end
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      for _ = 1, card.ability.extra.on_add do
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
            G.GAME.consumeable_buffer = 0
            play_sound('timpani')
            SMODS.add_card({key = "c_tboj_soul_heart", edition = 'e_negative'})
            return true
          end
        }))
      end
    end
  end,
  in_pool = function(self, args)
    return false
  end,
  attributes = {"tboj_transformation"}
}