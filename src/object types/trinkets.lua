SMODS.ObjectType {
  key = "tboj_trinket",
  default = "trinket_tboj_swallowed_penny",
}

TBOJ.Trinket = SMODS.Center:extend {
  unlocked = true,
  discovered = true,
  pos = {x = 0, y = 0},
  cost = 4,
  set = "tboj_trinket",
  atlas = "tboj_trinkets",
  class_prefix = "trinket",
  required_params = {
    "key"
  },
}

G.C.SECONDARY_SET.tboj_trinket = HEX("B741B6")

local gigo = Game.init_game_object
function Game:init_game_object()
  local res = gigo(self)
  res.tboj_trinket_rate = 4
  return res
end

local cfbs = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
  if card.ability.set == "tboj_trinket" then
    if #G.trinkets.cards >= G.trinkets.config.card_limit + card.ability.card_limit - card.ability.extra_slots_used then
      alert_no_space(card, G.trinkets)
      return false
    else return true end
  else return cfbs(card) end
end

local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
  local buttons = G_UIDEF_use_and_sell_buttons_ref(card)
  if card.area == G.trinkets and card.config.center.set == "tboj_trinket" then
    sell = {n=G.UIT.C, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'active_sell', func = 'can_sell_card'}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.C, config={align = "tm"}, nodes={
          {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
            {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
            {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
          }}
        }}
      }},
    }}

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
end