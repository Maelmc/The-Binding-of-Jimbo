SMODS.current_mod.custom_collection_tabs = function()
  local trinket_tally = 0
  for _, v in pairs(G.P_CENTER_POOLS.tboj_Trinket) do
    if v.discovered or G.PROFILES[G.SETTINGS.profile].all_unlocked then
      trinket_tally = trinket_tally + 1
    end
  end

  local active_tally = 0
  for _, v in pairs(G.P_CENTER_POOLS.tboj_Active) do
    if v.discovered or G.PROFILES[G.SETTINGS.profile].all_unlocked then
      active_tally = active_tally + 1
    end
  end

  local spiderfly_tally = 0
  for _, v in pairs(G.P_CENTER_POOLS.tboj_spiderfly) do
    if v.discovered or G.PROFILES[G.SETTINGS.profile].all_unlocked then
      spiderfly_tally = spiderfly_tally + 1
    end
  end

  return {
    UIBox_button {
      button = 'your_collection_tboj_Active',
      id = 'your_collection_tboj_Active',
      label = { localize('k_tboj_Actives') },
      count = {
        tally = active_tally,
        of = #G.P_CENTER_POOLS.tboj_Active
      },
      minw = 5
    },

    UIBox_button {
      button = 'your_collection_tboj_Trinket',
      id = 'your_collection_tboj_Trinket',
      label = { localize('k_tboj_Trinkets') },
      count = {
        tally = trinket_tally,
        of = #G.P_CENTER_POOLS.tboj_Trinket
      },
      minw = 5
    },

    UIBox_button {
      button = 'your_collection_tboj_spiderfly',
      id = 'your_collection_tboj_spiderfly',
      label = { localize('k_tboj_spiderfly') },
      count = {
        tally = spiderfly_tally,
        of = #G.P_CENTER_POOLS.tboj_spiderfly
      },
      minw = 5
    },
  }
end

function G.FUNCS.your_collection_tboj_Trinket()
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu {
    definition = SMODS.card_collection_UIBox(G.P_CENTER_POOLS.tboj_Trinket, { 5, 5 }, {
      snap_back = true,
      infotip = nil, --localize('k_BakeryCharmInfo'),
      hide_single_page = true,
      collapse_single_page = true,
    })
  }
end

function G.FUNCS.your_collection_tboj_Active()
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu {
    definition = SMODS.card_collection_UIBox(G.P_CENTER_POOLS.tboj_Active, { 5, 5 }, {
      snap_back = true,
      infotip = nil, --localize('k_BakeryCharmInfo'),
      hide_single_page = true,
      collapse_single_page = true,
    })
  }
end

function G.FUNCS.your_collection_tboj_spiderfly()
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu {
    definition = SMODS.card_collection_UIBox(G.P_CENTER_POOLS.tboj_spiderfly, { 5, 5 }, {
      snap_back = true,
      infotip = nil, --localize('k_BakeryCharmInfo'),
      hide_single_page = true,
      collapse_single_page = true,
    })
  }
end