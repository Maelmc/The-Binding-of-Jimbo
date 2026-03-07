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