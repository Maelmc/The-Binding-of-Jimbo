-- Pisces
-- Eve's Mascara
-- Judas' Shadow
SMODS.Joker {
  key = "judas_shadow",
  pos = {x = 10, y = 20},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.b_tboj_judas
    return {vars = {}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over and context.main_eval then
      if G.GAME.chips / G.GAME.blind.chips >= 0.25 then
        print("a")
        G.E_MANAGER:add_event(Event({
          func = function()
            G.hand_text_area.blind_chips:juice_up()
            G.hand_text_area.game_chips:juice_up()
            play_sound('tarot1')
            TBOJ.change_deck("b_tboj_judas",true)
            SMODS.destroy_cards(card,true)
            return true
        end
        }))
        return {
          message = localize('k_saved_ex'),
          saved = localize('tboj_become_judas'),
          colour = G.C.RED
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil"}
}

-- Maggy's Bow
-- Holy Mantle

-- ???'s Only Friend
-- Samson's Chain
-- Mongo Baby
SMODS.Joker {
  key = "mongo_baby",
  pos = {x = 6, y = 21},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    if card.area and card.area == G.jokers then
      local other_joker
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card and G.jokers.cards[i + 1] and G.jokers.cards[i + 1]:has_attribute("tboj_familiar") then
          other_joker = G.jokers.cards[i + 1]
        end
      end
      local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
      local main_end = {
        {
          n = G.UIT.C,
          config = { align = "bm", minh = 0.4 },
          nodes = {
            {
              n = G.UIT.C,
              config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
              nodes = {
                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
              }
          }
          }
        }
      }
      return { main_end = main_end }
    end
  end,
  rarity = 3,
  cost = 10,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local other_joker = nil
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i] == card and G.jokers.cards[i + 1] and G.jokers.cards[i + 1]:has_attribute("tboj_familiar") then
        other_joker = G.jokers.cards[i + 1] 
      end
    end
    local ret = SMODS.blueprint_effect(card, other_joker, context)
    if ret then
      ret.colour = G.C.TBOJ.MOD_COLOR
    end
    return ret
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar"}
}
-- Isaac's Tears
-- Undefined