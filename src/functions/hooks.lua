local csc = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
  local card = e.config.ref_table
  local card_limit = card.ability.card_limit - card.ability.extra_slots_used
  if card.ability.set == 'tboj_active' then
    if #G.actives.cards < G.actives.config.card_limit + card_limit then
      e.config.colour = G.C.GREEN
      e.config.button = 'use_card'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
    return
  end
  if card.ability.set == 'tboj_trinket' then
    if #G.trinkets.cards < G.trinkets.config.card_limit + card_limit then
      e.config.colour = G.C.GREEN
      e.config.button = 'use_card'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
    return
  end
  return csc(e)
end

local scu = set_consumeable_usage
function set_consumeable_usage(card)
  if card.config.center_key and card.ability.consumeable then
    if card.config.center.set == 'Loot' then 
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
              G.GAME.last_tboj_loot = card.config.center_key
                return true
            end
          }))
            return true
        end
      }))
    end
  end
  return scu(card)
end

local click = Card.click
function Card:click()
  if (not self.highlighted) and self.config and self.config.center and self.config.center.key == "j_tboj_breakfast" and self.area == G.jokers then
    if G.hand and #G.hand.cards > 0 then
      SMODS.draw_cards(1)
      self.ability.extra.to_draw = self.ability.extra.to_draw - 1
      if self.ability.extra.to_draw <= 0 then
        SMODS.destroy_cards(self, true, nil, true)
        SMODS.calculate_effect({message = localize('k_eaten_ex'), colour = G.C.FILTER}, self)
      end
    end
  end
  return click(self)
end

--[[local gba = get_blind_amount
function get_blind_amount(ante)
  local amount = gba(ante)
  if ante >= 4 and G.GAME and G.GAME.applied_stakes then
    for _, v in pairs(G.GAME.applied_stakes) do
      if G.P_CENTER_POOLS.Stake[v].key == "stake_tboj_corpse_stake" then
        amount = amount * 2
        break
      end
    end
  end
  return amount
end]]

local gnb = get_new_boss
function get_new_boss()
  if G.GAME.modifiers.tboj_aprils_fool then return "bl_tboj_bloat" end
  return gnb()
end

bgt = Blind.get_type
function Blind:get_type()
  if self.config and self.config.blind and self.config.blind.small then return "Small" end
  if self.config and self.config.blind and self.config.blind.big then return "Big" end
  return bgt(self)
end