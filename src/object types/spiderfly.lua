SMODS.ObjectType {
  key = "tboj_spiderfly",
  default = "spiderfly_tboj_pretty_fly",
}

TBOJ.Spiderfly = SMODS.Center:extend {
  unlocked = true,
  discovered = true,
  pos = {x = 0, y = 0},
  cost = 4,
  set = "tboj_spiderfly",
  atlas = "tboj_spiderfly",
  display_size = { w = 22, h = 12 },
  class_prefix = "spiderfly",
  required_params = {
    "key"
  },
  in_pool = function(self)
    return true
  end
}

TBOJ.Spiderfly {
  key = "pretty_fly",
  pos = { x = 0, y = 1 },
  cost = 2,
  config = {extra = {chips = 30}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      G.E_MANAGER:add_event(Event({
        func = function()
          SMODS.destroy_cards(card, {bypass_eternal = true})
          return true
        end
      }))
      return {
        chips = card.ability.extra.chips
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(1)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(-1)
  end,
  attributes = {"tboj_fly"},
  tboj_designer = "Thor's Girdle"
}

TBOJ.Spiderfly {
  key = "blue_spider",
  pos = { x = 0, y = 0 },
  cost = 2,
  config = {extra = {Xmult = 1.3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      G.E_MANAGER:add_event(Event({
        func = function()
          SMODS.destroy_cards(card, {bypass_eternal = true})
          return true
        end
      }))
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.tboj_spiders:change_size(1)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.tboj_spiders:change_size(-1)
  end,
  attributes = {"tboj_spider"}
}

TBOJ.Spiderfly {
  key = "locust_of_war",
  pos = { x = 1, y = 0 },
  cost = 2,
  config = {extra = {Xmult = 1.2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          SMODS.destroy_cards(card, {bypass_eternal = true})
          return true
        end
      }))
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(1)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(-1)
  end,
  attributes = {"tboj_fly", "tboj_locust"},
}

TBOJ.Spiderfly {
  key = "locust_of_pestilence",
  pos = { x = 1, y = 1 },
  cost = 2,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.tboj_flies then
      G.E_MANAGER:add_event(Event({
        func = function()
          SMODS.destroy_cards(card, {bypass_eternal = true})
          return true
        end
      }))
      return {
        level_up = true,
        message = localize('k_level_up_ex')
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(1)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(-1)
  end,
  attributes = {"tboj_fly", "tboj_locust"},
}

TBOJ.Spiderfly {
  key = "locust_of_famine",
  pos = { x = 2, y = 0 },
  cost = 2,
  config = {extra = {money = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money}}
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        dollars = card.ability.extra.money
      }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          SMODS.destroy_cards(card, {bypass_eternal = true})
          return true
        end
      }))
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(1)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(-1)
  end,
  attributes = {"tboj_fly", "tboj_locust"},
}

TBOJ.Spiderfly {
  key = "locust_of_death",
  pos = { x = 2, y = 1 },
  cost = 2,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  calculate = function(self, card, context)
    if context.discard and not context.blueprint and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        func = function()
          SMODS.add_card {
            set = 'Tarot', -- same pool as purple seal
          }
          G.GAME.consumeable_buffer = 0
          SMODS.destroy_cards(card, {bypass_eternal = true})
          return true
        end
      }))

      return {
        message = localize('k_plus_tarot'),
        colour = G.C.PURPLE
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(1)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.tboj_flies:change_size(-1)
  end,
  attributes = {"tboj_fly", "tboj_locust"},
}

G.C.SECONDARY_SET.tboj_spiderfly = HEX("1B13A0")

local gigo = Game.init_game_object
function Game:init_game_object()
  local res = gigo(self)
  res.tboj_spider_rate = 0
  return res
end

local cfbs = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
  if card.ability.set == "tboj_spiderfly" then
    if card.config.center.key == "spiderfly_tboj_blue_spider" then
      if #G.tboj_spiders.cards >= G.tboj_spiders.config.card_limit + card.ability.card_limit - card.ability.extra_slots_used then
        alert_no_space(card, G.tboj_spiders)
        return false
      else return true end
    else
      if #G.tboj_flies.cards >= G.tboj_flies.config.card_limit + card.ability.card_limit - card.ability.extra_slots_used then
        alert_no_space(card, G.tboj_flies)
        return false
      else return true end
    end
  else return cfbs(card) end
end

--[[local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
  local buttons = G_UIDEF_use_and_sell_buttons_ref(card)
  if (card.area == G.tboj_spiders or card.area == G.tboj_flies) and card.config.center.set == "tboj_spiderfly" then
    local sell = nil

    local use = nil

    buttons = {
      n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            sell
          }},
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            use
          }},
        }},
    }}
  end
  return buttons
end]]