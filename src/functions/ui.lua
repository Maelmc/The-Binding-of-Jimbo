-- Stolen from Aikoyori's Shenanigans
local function embedded_ui_sprite( sprite_atlas, sprite_pos, desc_nodes, config )
    if not config then config = {} end
    local sprite_atli = G.ASSET_ATLAS[sprite_atlas]
    local height = config.h or sprite_atli.py
    local width = config.w or sprite_atli.px
    local manual_scale = config.manual_scale
    local fix_height = config.fxh
    local fix_width = config.fxw
    local scale = config.scale or 1
    local padding = config.padding or 0.07
    local rounded = config.rounded or 0.1
    local margin_left = config.ml or 0.2
    local margin_top = config.mt or 0
    local alignment = config.alignment or "cm"
    local box_height = config.box_height or 0
    local aspect_ratio = sprite_atli.px / sprite_atli.py
    local longer_value = not manual_scale and math.max(sprite_atli.px, sprite_atli.py) or manual_scale
    local sprt = Sprite(
        --G.ROOM.T.x + margin_left * G.ROOM.T.w, G.ROOM.T.h + margin_top
        --,width*scale/(aspect_ratio*longer_value), height*scale/(aspect_ratio*longer_value),
        --sprite_atli, sprite_pos
        0,0,0.6,0.6, sprite_atli, sprite_pos
    )
    local uiEX = 
    {
        n = G.UIT.R,
        config = { align = alignment , padding = padding, no_fill = true, r = rounded, minh = box_height or fix_height, maxh = fix_height, minw = fix_width, maxw = fix_width },
        nodes = {
            {n = G.UIT.O, config = { object = sprt }}
        }
    }
    if desc_nodes then
        desc_nodes[#desc_nodes+1] = {uiEX}
    end
    return uiEX
end

local function create_button_icon(sprite_atlas, px, py, uit)
  return {
    n = uit or G.UIT.C,
    nodes = {
      embedded_ui_sprite(sprite_atlas, { x = px or 0, y = py or 0 }, nil, {
        w = 18,
        h = 18,
        manual_scale = 54,
        padding = 0,
        rounded = 0.5
      }),
    }
  }
end

G.FUNCS.tboj_open_link = function(e)
  love.system.openURL( e.config.link )
end

local function create_link_sprite_btn(col, atlas, x, y, link)
  col = col or G.C.BLUE
  x = x or 0
  y = y or 0
  atlas = atlas or "icons"
  
  return 
  {
    n = G.UIT.C,
    config = {
      button = "tboj_open_link",
      link = link,
      colour = darken(col, 0.4),
      padding = 0.05,
      r = 0.1,
      emboss = 0.05,
      hover = true,
      shadow = true,
    },
    nodes = {
      create_button_icon(atlas, x, y)
    }
  }
end


SMODS.current_mod.extra_tabs = function ()
  return {
    { 
      label = localize("tboj_links"),
      tab_definition_function = function ()
        return {
          n = G.UIT.ROOT,
          config = {
            r = 0.5,
            padding = 0.5,
            align = "tm",
            colour = G.C.BLACK,
            minw = 6,
            minh = 6,
          },
          nodes = {
            {
              n = G.UIT.C,
              config = {padding = 0.5},
              nodes = {
                {
                  n = G.UIT.R,
                  config = {align = "cm", padding = 0.1},
                  nodes = {
                    create_link_sprite_btn(mix_colours(G.C.BLUE, G.C.GREY, 0.4), "icons", 0, 0, "https://discord.gg/fXfPHpvPc8"),
                    { n = G.UIT.T, config = { text = localize("tboj_discord"), scale = 0.5, colour = G.C.WHITE } },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {align = "cm", padding = 0.1},
                  nodes = {
                    create_link_sprite_btn(G.C.WHITE, "tboj_wiki", 0, 0, "https://balatromods.miraheze.org/wiki/The_Binding_of_Jimbo"),
                    { n = G.UIT.T, config = { text = localize("tboj_wiki"), scale = 0.5, colour = G.C.WHITE } },
                  }
                },
              }
            },
          }
        }
      end
    }
  }
end