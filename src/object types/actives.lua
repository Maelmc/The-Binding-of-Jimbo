SMODS.ObjectType {
  key = "tboj_active",
  default = "active_tboj_the_d6",
  --[[rarities = {
    {key = "Common"},
    {key = "Uncommon"},
    {key = "Rare"},
  }]]
}

TBOJ.Active = SMODS.Center:extend {
  --rarity = "Common",
  unlocked = true,
  discovered = false,
  pos = {x = 0, y = 0},
  cost = 4,
  set = "tboj_active",
  atlas = "tboj_jokers",
  class_prefix = "active",
  required_params = {
    "key"
  },
  inject = function(self)
    G.P_CENTERS[self.key] = self
    if not self.omit then SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self) end
    for k, v in pairs(SMODS.ObjectTypes) do
        -- Should "cards" be formatted as `{[<center key>] = true}` or {<center key>}?
        -- Changing "cards" and "pools" wouldn't be hard to do, just depends on preferred format
        if ((self.pools and self.pools[k]) or (v.cards and v.cards[self.key])) then
            v:inject_card(self)
        end
    end
  end,
}

G.C.SECONDARY_SET.tboj_active = HEX("FFD800")


-- should use this instead of a lovely patch but the patch works well and i cant be bothered to find the correct position
--[[local cca = SMODS.current_mod.custom_card_areas
SMODS.current_mod.custom_card_areas = function(game)
  if cca then
    cca(game)
  end
  game.actives = CardArea(
    0, CAI.consumeable_H + 0.3,
    CAI.consumeable_W / 2,
    CAI.consumeable_H, 
    {card_limit = 1, type = 'joker', highlight_limit = 1}
  )
  game.actives.T.x = game.consumeables.T.x + game.consumeables.T.w - game.actives.T.w
  game.actives.T.y = game.deck.T.y - game.deck.T.h * 2.25
end]]

local gigo = Game.init_game_object
function Game:init_game_object()
  local res = gigo(self)
  res.tboj_active_rate = 4
  return res
end

local cfbs = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
  if card.ability.set == "tboj_active" then
    if #G.actives.cards >= G.actives.config.card_limit + card.ability.card_limit - card.ability.extra_slots_used then
      alert_no_space(card, G.actives)
      return false
    else return true end
  else return cfbs(card) end
end

local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
  local buttons = G_UIDEF_use_and_sell_buttons_ref(card)
  if card.area == G.actives and card.config.center.set == "tboj_active" then
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

    local use = {n=G.UIT.C, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={ref_table = card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'active_use', func = 'can_use_consumeable'}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
      }}
    }}

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

function Card:use_active(area, copier)
    stop_use()
    if self.debuff then return nil end

    if self.ability.extra.max_highlighted then
      update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
    end

    local obj = self.config.center
    if obj.use and type(obj.use) == 'function' then
      obj:use(self, area, copier)
      if not obj.manual_deplete_charges and self.ability.extra.curr_charge then
        self.ability.extra.curr_charge = self.ability.extra.curr_charge - self.ability.extra.max_charge
      end
    end

    SMODS.calculate_context({using_active = true, active = self})
end