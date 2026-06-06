SMODS.Rarity{
  key = "transformation",
  default_weight = 0,
  badge_colour = HEX("D8A656"),
  pools = {["Joker"] = true},
  get_weight = function(self, weight, object_type)
    return weight
  end,
}

local transformation_attributes = {
  tboj_guppy = "guppy",
  --tboj_fly = "beelzebub",
  tboj_angel = "seraphim",
  --tboj_familiar = "conjoined",
  tboj_book = "bookworm",
  --tboj_poop = "oh_crap",
  tboj_devil = "leviathan",
}

local cc = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  local res = cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  SMODS.calculate_context({card = res, tboj_card_created = true})
  return res
end

local atd = Card.add_to_deck
function Card:add_to_deck(from_debuff)
  local res = atd(self, from_debuff)

  for k, v in pairs(transformation_attributes) do
    if self:has_attribute(k) then
      G.GAME.tboj_transformation = G.GAME.tboj_transformation or {}
      G.GAME.tboj_transformation[k] = G.GAME.tboj_transformation[k] or {}
      
      if not G.GAME.tboj_transformation[k][self.config.center.key] then
        G.GAME.tboj_transformation[k][self.config.center.key] = true
        G.GAME.tboj_transformation[k].count = (G.GAME.tboj_transformation[k].count or 0) + 1

        if G.GAME.tboj_transformation[k].count >= 3 and not G.GAME.tboj_transformation[k].created then
          G.GAME.tboj_transformation[k].created = true
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function() 
              local _trans = SMODS.add_card({key = "j_tboj_transformation_"..v, edition = 'e_negative', })
              _trans:set_eternal(true)
              play_sound('tboj_transformation', 1, 0.4)
              return true 
            end 
          }))
        end
      end
    end
  end

  return res
end