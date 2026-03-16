-- Mostly copied from Pokermon's credit system

local tboj_artists = {
  Maelmc = {display_name = 'Maelmc', artist_colour = HEX("EA6F22"), highlight_colour = nil},
}

local artistname = function(record)
  return type(record) == 'table' and record.name or record
end

function TBOJ.get_artist_info(name_or_record)
  return tboj_artists[artistname(name_or_record)]
end

local divider_text = function(i, limit)
  local div_text

  -- separate by commas if 3 or more items
  if limit > 2 then
    div_text = ', '
  else
    div_text = ' '
  end

  -- add "and" to the last divider
  if limit - 1 == i then
    div_text = div_text .. localize('tboj_and') .. ' '
  end

  return div_text
end

function TBOJ.artist_credit(artists)
  if type(artists) == 'table' and not artists[1] then artists = { artists.name } end
  if type(artists) == 'string' then artists = { artists } end

  local artist_credit = {n=G.UIT.R, config = {align = 'tm'}, nodes = {
      {n=G.UIT.T, config={
          text = localize('tboj_credits_artist'),
          shadow = true,
          colour = G.C.UI.BACKGROUND_WHITE,
          scale = 0.27}}
  }}

  local outline_nodes = {}

  for _, artist in ipairs(artists) do
    local artist_info = TBOJ.get_artist_info(artist) or {}
    local artist_name = artist_info.display_name or (type(artist) == 'table' and artist.name) or artist
    local artist_colour = artist_info.artist_colour or G.C.FILTER
    local artist_highlight = artist_info.highlight_colour or G.C.CLEAR

    local outline_node = {n=G.UIT.C, config={align = "m", colour = artist_highlight, r = 0.05, padding = 0.03, res = 0.15}, nodes = {}}

    local artist_node = {n=G.UIT.O, config={
      object = DynaText({string = artist_name,
        colours = {artist_colour},
        bump = true,
        silent = true,
        pop_in = 0,
        pop_in_rate = 4,
        shadow = true,
        y_offset = -0.6,
        scale =  0.27
      })
    }}

    table.insert(outline_node.nodes, artist_node)

    outline_nodes[#outline_nodes + 1] = outline_node
  end

  for j = 1, #outline_nodes do
    table.insert(artist_credit.nodes, outline_nodes[j])

    if #outline_nodes > 1 and j ~= #outline_nodes then
      local text = divider_text(j, #outline_nodes)

      local amp_node = {n=G.UIT.T, config={
        text = text,
        shadow = true,
        colour = G.C.UI.BACKGROUND_WHITE,
        scale = 0.27}}
      table.insert(artist_credit.nodes, amp_node)
    end
  end
  return artist_credit
end

function TBOJ.designer_credit(designer_name)
    local designer_credit = {n=G.UIT.R, config = {align = 'tm'}, nodes = {
        {n=G.UIT.T, config={
            text = localize('tboj_credits_designer'),
            shadow = true,
            colour = G.C.UI.BACKGROUND_WHITE,
            scale = 0.27}}
    }}
    
    local designer_node = {n=G.UIT.O, config={
            object = DynaText({string = designer_name,
            colours = {G.C.FILTER},
            bump = true,
            silent = true,
            pop_in = 0,
            pop_in_rate = 4,
            shadow = true,
            y_offset = -0.6,
            scale =  0.27
            })
        }}
    
    table.insert(designer_credit.nodes, designer_node)
    return designer_credit
end

local get_credits = function(card)
  if not (card and card.config) then return end
  local center = card.config.center
  if center then
    if card.seal and center.key == 'c_base' and card.area and card.area.config.collection then
      local seal = G.P_SEALS[card.seal]
      return seal.tboj_artist, seal.tboj_designer
    end

    return center.tboj_artist, center.tboj_designer
  end
  local tag = card.config.tag
  if tag then
    local proto = G.P_TAGS[tag.key]
    return proto.tboj_artist, proto.tboj_designer
  end
end

local prev_card_h_popup = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
  local ret_val =prev_card_h_popup(card)
  local artist, designer = get_credits(card)
  if artist then
    table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes, TBOJ.artist_credit(artist))
  end
  if designer then
    table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes, TBOJ.designer_credit(designer))
  end
  
  return ret_val
end

local cuibbp = create_UIBox_blind_popup
function create_UIBox_blind_popup(blind, discovered, vars)
  local ret = cuibbp(blind, discovered, vars)
  if blind.tboj_artist or blind.tboj_designer then
    local nodes = {}
    if blind.tboj_artist then
      nodes[#nodes+1] = TBOJ.artist_credit(blind.tboj_artist)
    end
    if blind.tboj_designer then
      nodes[#nodes+1] = TBOJ.designer_credit(blind.tboj_designer)
    end
    table.insert(ret.nodes,
      {n=G.UIT.R, config = {align = "cm"}, nodes = {
        {n=G.UIT.R, config = {align = "cm", r = 1, colour = adjust_alpha(darken(G.C.BLACK, 0.1), 0.8), padding = 0.05}, nodes = {
          {n=G.UIT.C, config = {minw = 0.2}},
          {n=G.UIT.C, nodes = nodes},
          {n=G.UIT.C, config = {minw = 0.2}},
        }}
      }}
    )
  end
  return ret
end