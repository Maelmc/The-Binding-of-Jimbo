return {
  descriptions = {
    tboj_active = {
      active_tboj_the_book_of_belial = {
        name = "The Book of Belial",
        text = {
          {
            "#1#/#2# {C:attention}charge",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Add {C:mult}+#3#{} permanent Mult",
            "to {C:attention}#4#{} selected card"
          }
        }
      },
      active_tboj_the_poop = {
        name = "The Poop",
        text = {
          {
            "#1#/#2# {C:attention}charge",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Enhance {C:attention}#3#{} selected",
            "card into a {C:attention}Poop Card"
          }
        }
      },
      active_tboj_mr_boom = {
        name = "Mr. Boom",
        text = {
          {
            "#1#/#2# {C:attention}charge",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "{C:white,X:mult}X#3#{} Mult on the next hand",
            "{C:inactive}(#4#)"
          }
        }
      },
      active_tboj_my_little_unicorn = {
        name = "My Little Unicorn",
        text = {
          {
            "#1#/#2# {C:attention}charges",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Add {C:dark_edition}Polychrome{} to",
            "a selected card"
          }
        }
      },
      active_tboj_deck_of_cards = {
        name = "Deck of Cards",
        text = {
          {
            "#1#/#2# {C:attention}charge",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Create a random {C:tarot}Tarot{} card",
            "{C:inactive}(Must have room)"
          }
        }
      },
      active_tboj_the_book_of_sin = {
        name = "The Book of Sin",
        text = {
          {
            "#1#/#2# {C:attention}charge",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Create a random {C:tboj_loot}Loot{} card",
            "{C:inactive}(Must have room)"
          }
        }
      },
      active_tboj_the_d6 = {
        name = "The D6",
        text = {
          {
            "#1#/#2# {C:attention}charge",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "{C:attention}Reroll{} all {C:attention}Jokers",
            "and {C:attention}Actives{} in the shop",
            "into ones of the same {C:attention}rarity"
          }
        }
      },
      active_tboj_smelter = {
        name = "Smelter",
        text = {
          {
            "#1#/#2# {C:attention}charges",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Add {C:dark_edition}Negative{} to",
            "a selected {C:attention}Trinket"
          }
        }
      },
      active_tboj_dull_razor = {
        name = "Dull Razor",
        text = {
          {
            "#1#/#2# {C:attention}charges",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Pretend to {C:attention}destroy",
            "selected playing cards",
          }
        }
      },
      active_tboj_larynx = {
        name = "Larynx",
        text = {
          {
            "#1#/#2# {C:attention}charges",
            "Must have at least 1 charge to use",
            "Recharges at end of round",
          },
          {
            "{C:white,X:mult}X#3#{} Mult for each charge when used",
            "{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive} Mult and #5#)"
          }
        }
      },
      active_tboj_genesis = {
        name = "Genesis",
        text = {
          {
            "Must have at least",
            "{C:attention}1{} Joker to use",
            "Cannot use during a",
            "{C:attention}Blind{} or a {C:attention}Booster Pack"
          },
          {
            "{C:attention}Destroy{} all your Jokers",
            "and create a {C:attention}Buffoon Tag",
            "for each Joker destroyed,",
            "then {C:red}self-destructs",
            "{C:inactive}(Bypasses {C:attention}Eternal{C:inactive})"
          }
        }
      },
      active_tboj_lemegeton = {
        name = "Lemegeton",
        text = {
          {
            "#1#/#2# {C:attention}charges",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Create a random {C:dark_edition}Negative{}",
            "and {C:attention}Perishable{} Joker",
          }
        }
      },
    },
    Back = {
      b_tboj_isaac = {
        name = "Isaac Deck",
        text = {
          "Start with {C:attention,T:active_tboj_the_d6}The D6"
        }
      },
    },
    Blind = {
      bl_tboj_siren = {
        name = "The Siren",
        text = {
          "Familiar Jokers",
          "are debuffed"
        }, 
      },
    },
    Enhanced = {
      m_tboj_poop = {
        name = "Poop Card",
        text = {
          "{C:inactive}Does nothing",
        },
      },
      m_tboj_laser = {
        name = "Laser Card",
        text = {
          "Balance {C:attention}#1#%{} of {C:chips}Chips",
          "and {C:mult}Mult{} when scored"
        },
      },
    },
    Joker = {
      j_tboj_the_inner_eye = {
        name = "The Inner Eye",
        text = {
          "{C:attention}+1{} card selection limit"
        }
      },
      j_tboj_spoon_bender = {
        name = "Spoon Bender",
        text = {
          "{C:attention}Unscored cards{}",
          "give {C:white,X:mult}X#1#{} Mult"
        }
      },
      j_tboj_cricket_head = {
        name = "Cricket's Head",
        text = {
          "{C:mult}+#1#{} and {C:white,X:mult}X#2#{} Mult"
        }
      },
      j_tboj_number_one = {
        name = "Number One",
        text = {
          "{C:chips}+#1#{} Chips if",
          "played hand contains",
          "{C:attention}#2#{} cards or less"
        }
      },
      j_tboj_brother_bobby = {
        name = "Brother Bobby",
        text = {
          "{C:chips}+#1#{} Chips"
        }
      },
      j_tboj_heart = {
        name = "<3",
        text = {
          "Sell this card to",
          "convert all cards {C:attention}held",
          "{C:attention}in hand{} to {C:hearts}Hearts"
        }
      },
      j_tboj_a_dollar = {
        name = "A Dollar",
        text = {
          "Sell this card to",
          "earn {C:money}$#1#"
        }
      },
      j_tboj_boom = {
        name = "Boom!",
        text = {
          "Sell this card to",
          "create {C:attention}#1# Bombs",
          "{C:inactive}(Must have room)"
        }
      },
      j_tboj_lucky_foot = {
        name = "Lucky Foot",
        text = {
          "Adds {C:attention}#1#{} to all {C:attention}listed",
          "{C:green,E:1,S:1.1}probabilities",
          "{C:attention}Pills{} cannot reduce",
          "a poker hand's {C:attention}level"
        } 
      },
      j_tboj_steven = {
        name = "Steven",
        text = {
          "{C:mult}+#1#{} Mult"
        }
      },
      j_tboj_distant_admiration = {
        name = "Distant Admiration",
        text = {
          "{C:attention}Third{} and {C:attention}fourth",
          "scoring cards give",
          "{C:mult}+#1#{} Mult when scored"
        }
      },
      j_tboj_charm_of_the_vampire = {
        name = "Charm of the Vampire",
        text = {
          "This Joker gains {C:mult}+#1#{} Mult",
          "when {C:attention}Blind{} is defeated",
          "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
      },
      j_tboj_the_battery = {
        name = "The Battery",
        text = {
          "{C:attention}Actives{} can be overcharged",
          "up to {C:attention}twice{} their maximum charge"
        }
      },
      j_tboj_steam_sale = {
        name = "Steam Sale",
        text = {
          "Everything costs {C:money}$#1#{} less",
          "{C:inactive,s:0.8}(Rerolls, cards, vouchers, packs)",
        }
      },
      j_tboj_sister_maggy = {
        name = "Sister Maggy",
        text = {
          "{C:mult}+#1#{} Mult"
        }
      },
      j_tboj_chocolate_milk = {
        name = "Chocolate Milk",
        text = {
          "Gains {C:white,X:mult}X#1#{} Mult when a",
          "hand is played",
          "Only scores when this is your",
          "{C:attention}rightmost{} Joker, then {C:attention}resets",
          "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
        }
      },
      j_tboj_cube_of_meat = {
        name = "Cube of Meat",
        text = {
            {
            "{C:mult}+#1#{}, {C:mult}+#2#{}, {C:white,X:mult}X#3#{} or {C:white,X:mult}X#4#{} Mult",
            "depending on this Joker's stage",
            "{C:inactive}(Currently {C:attention}Stage #5#{C:inactive})"
          },
          {
            "Buying another {C:attention}Cube of Meat{}",
            "increases the stage of {C:attention}leftmost",
            "{C:attention}Cube of Meat{} instead",
            "{C:inactive}(Can appear multiple times in shop)"
          },
        }
      },
      j_tboj_a_quarter = {
        name = "A Quarter",
        text = {
          "Sell this card to",
          "earn {C:money}$#1#"
        }
      },
      j_tboj_the_mark = {
        name = "The Mark",
        text = {
          "Each played {C:attention}6{} gives",
          "{C:mult}+#1#{} Mult when scored",
          "If played hand is exactly",
          "{C:attention}three 6s{}, they each give",
          "{C:mult}+#2#{} Mult when scored instead"
        }
      },
      j_tboj_the_pact = {
        name = "The Pact",
        text = {
          "{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult"
        }
      },
      j_tboj_dead_cat = {
        name = "Dead Cat",
        text = {
          "Prevents Death {C:attention}#1#{} times",
          "if chips scored are",
          "at least {C:attention}75%{} of required chips",
          "then {C:red}self-destructs"
        }
      },
      j_tboj_robo_baby = {
        name = "Robo-Baby",
        text = {
          "When round begins,",
          "add a random {C:attention}Laser Card",
          "to your hand",
        }
      },
      j_tboj_the_relic = {
        name = "The Relic",
        text = {
          "Create a {C:attention}Soul Heart",
          "at end of round",
          "{C:inactive}(Must have room)"
        },
      },
      j_tboj_the_halo = {
        name = "The Halo",
        text = {
          "{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult",
          "Earn {C:money}$#3#{} at",
          "end of round"
        }
      },
      j_tboj_money_equal_power = {
        name = "Money = Power",
        text = {
          "{X:mult,C:white}X#1#{} Mult for",
          "every {C:money}$#2#{} you have",
          "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
        }
      },
      j_tboj_ouija_board = {
        name = "Ouija Board",
        text = {
          "If first hand of round is",
          "a single {C:attention}card with a rank{}, destroy",
          "it and create a {C:spectral}Spectral{} card",
          "Only works once per rank",
          "{C:inactive}(Must have room)",
        }
      },
      j_tboj_brimstone = {
        name = "Brimstone",
        text = {
          "{C:white,X:mult}X#1#{} for each",
          "scoring card"
        }
      },
      j_tboj_whore_of_babylon = {
        name = "Whore of Babylon",
        text = {
          "{C:red}+#1#{} Mult on {C:attention}final",
          "{C:attention}hand{} of round",
        }
      },
      j_tboj_a_lump_of_coal = {
        name = "A Lump of Coal",
        text = {
          "{C:white,X:red}X1{} Mult, plus {C:white,X:red}X#1#{}",
          "for each scoring card"
        }
      },
      j_tboj_sacred_heart = {
        name = "Sacred Heart",
        text = {
          "{C:attention}Unscored cards{}",
          "give {C:white,X:mult}X#1#{} Mult"
        }
      },
      j_tboj_stop_watch = {
        name = "Stop Watch",
        text = {
          "{C:attention}Doubles{} scaling values"
        }
      },
      j_tboj_e_coli = {
        name = "E. Coli",
        text = {
          "All played {C:attention}face{} cards",
          "become {C:attention}Poop{} cards",
          "when scored"
        }
      },
      j_tboj_contract_from_below = {
        name = "Contract From Below",
        text = {
          "Earn {C:money}${} equal to {C:attention}double",
          "the Blind's reward at end of round",
          "{C:green}#1# in #2#{} chance to {C:attention}lose it{} instead",
        }
      },
      j_tboj_20_20 = {
        name = "20/20",
        text = {
          "Retrigger all played cards",
          "{C:attention}#1#{} additionnal time"
        }
      },
      j_tboj_proptosis = {
        name = "Proptosis",
        text = {
          "Played cards give {C:white,X:mult}X#1#{} Mult",
          "divided by their {C:attention}position",
          "in {C:attention}played hand{} when scored"
        }
      },
      j_tboj_the_mind = {
        name = "The Mind",
        text = {
          "{C:attention}+#1#{} hand size"
        }
      },
      j_tboj_the_body = {
        name = "The Body",
        text = {
          "{C:red}+#1#{} discards"
        }
      },
      j_tboj_the_soul = {
        name = "The Soul",
        text = {
          "{C:blue}+#1#{} hands"
        }
      },
      j_tboj_betrayal = {
        name = "Betrayal",
        text = {
          "Destroy the {C:attention}first card",
          "in {C:attention}first{} hand of round that",
          "has less {C:attention}total{} {C:chips}Chips{} than the",
          "next card in {C:attention}poker hand",
        },
      },
      j_tboj_paschal_candle = {
        name = "Paschal Candle",
        text = {
          "This Joker gains {C:chips}+#1#{} Chips",
          "per consecutive {C:attention}Blind",
          "defeated in a {C:attention}single hand",
          "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
        },
      },
      j_tboj_lusty_blood = {
        name = "Lusty Blood",
        text = {
          "This Joker gains {X:mult,C:white}X#1#{} Mult",
          "for each playing card {C:attention}destroyed{},",
          "resets when {C:attention}Boss Blind{} is defeated",
          "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
        },
      },
      j_tboj_shard_of_glass = {
        name = "Shard of Glass",
        text = {
          "When a {C:attention}Glass Card{}",
          "is destroyed, destroy",
          "cards {C:attention}adjacent{} to it"
        }
      },
      j_tboj_bozo = {
        name = "Bozo",
        text = {
          "If first hand of round is",
          "a single {C:attention}Poop{} card,",
          "add {C:dark_edition}Polychrome{} to it"
        }
      },
      j_tboj_death_list = {
        name = "Death's List",
        text = {
          "Create a random {C:tboj_loot}Loot{} card",
          "and this Joker gains {C:chips}+#1#{} Chips",
          "if winning hand contains",
          "a scoring {C:attention}#2#{},",
          "rank changes every round",
          "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
          "{C:inactive}(Must have room)"
        }
      },
      j_tboj_schoolbag = {
        name = "Schoolbag",
        text = {
          "{C:attention}+#1#{} active slot",
          "Destroy a random non-{C:dark_edition}Negative{}",
          "{C:attention}Active{} when sold or destroyed",
          "if you have more than the limit"
        }
      },
      j_tboj_hallowed_ground = {
        name = "Hallowed Ground",
        text = {
          "Played {C:attention}Poop{} cards give",
          "{C:white,X:red}X#1#{} Mult when scored"
        }
      },
      j_tboj_blood_oath = {
        name = "Blood Oath",
        text = {
          "When {C:attention}Blind{} is selected,",
          "lose all {C:blue}Hands{} but one",
          "and this Joker gains",
          "{C:white,X:mult}X#1#{} Mult per hand lost,",
          "resets at end of round",
          "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
        }
      },
      j_tboj_soul_locket = {
        name = "Soul Locket",
        text = {
          "This Joker randomly gains",
          "{C:chips}+#1#{} Chips or {C:mult}+#2#{} Mult when",
          "using a {C:attention}Soul Heart",
          "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips and {C:mult}+#4#{C:inactive} Mult)"
        }
      },
      j_tboj_sacred_orb = {
        name = "Sacred Orb",
        text = {
          "{C:blue}Common{} Jokers cannot",
          "appear in the shop",
          "{C:green}Uncommon{} Jokers in the shop",
          "have a {C:green}#1# in #2#{} chance",
          "to be {C:attention}rerolled"
        }
      },
    },
    Loot = {
      c_tboj_bomb = {
        name = "Bomb",
        text = {
          "{C:white,X:red}X#1#{} Mult on the next hand",
          "then {C:red}self-destructs{} when used",
          "{C:inactive}(#2#!)"
        }
      },
      c_tboj_lil_battery = {
        name = "Lil' Battery",
        text = {
          "Add up to {C:attention}#1# charges",
          "to a selected {C:attention}Active"
        }
      },
      c_tboj_pill = {
        name = "Pill",
        text = {
          "Increases a random {C:attention}poker",
          "{C:attention}hand{}'s level by {C:attention}#3#",
          "{C:green}#1# in #2#{} chance to",
          "decrease it instead"
        }
      },
      c_tboj_soul_heart = {
        name = "Soul Heart",
        text = {
          "Add {C:chips}+#1#{} permanent Chips",
          "to {C:attention}#2#{} selected card"
        }
      },
    },
    Spectral = {
      c_tboj_spindown_dice = {
            name = "Spindown Dice",
            text = {
                "{C:attention}Reroll{} selected Joker",
                "to the previous one",
                "in {C:attention}collection{} order",
                "{C:inactive}Destroys {C:attention}Joker",
                "{C:inactive}and {C:attention}The Sad Onion",
            }
        }
    },
    Stake={
        stake_tboj_void_stake = {
          name = "Void Stake",
          text = {
            "{X:gray,C:attention}+1{} Ante win requirement"
          },
        },
    },
    Tag = {
        
    },
    tboj_trinket = {
      trinket_tboj_swallowed_penny = {
        name = "Swallowed Penny",
        text = {
          "Earn {C:money}$#1#{} when",
          "playing a hand"
        }
      },
      trinket_tboj_petrified_poop = {
        name = "Petrified Poop",
        text = {
          "Earn {C:money}$#1#{} when",
          "a {C:attention}Poop{} card",
          "is destroyed"
        }
      },
      trinket_tboj_pulse_worm = {
        name = "Pulse Worm",
        text = {
          "Retrigger {C:attention}3{} random",
          "played cards used in scoring",
          "{C:attention}#1#{} additionnal time"
        }
      },
      trinket_tboj_wiggle_worm = {
        name = "Wiggle Worm",
        text = {
          "Retrigger {C:attention}second{} and {C:attention}fourth",
          "played cards used in scoring",
          "{C:attention}#1#{} additionnal time"
        }
      },
      trinket_tboj_flat_worm = {
        name = "Flat Worm",
        text = {
          "Retrigger {C:attention}third{} played",
          "card used in scoring",
          "{C:attention}#1#{} additionnal times"
        }
      },
      trinket_tboj_store_credit = {
        name = "Store Credit",
        text = {
          "Sell this card to",
          "create a free",
          "{C:attention}Coupon Tag"
        }
      },
      trinket_tboj_lucky_rock = {
        name = "Lucky Rock",
        text = {
          "{C:attention}Stone Cards{} are considered",
          "to be {C:attention}Lucky Cards"
        }
      },
      trinket_tboj_hook_worm = {
        name = "Hook Worm",
        text = {
          "Retrigger {C:attention}first{} and {C:attention}fifth",
          "played cards used in scoring",
          "{C:attention}#1#{} additionnal time"
        }
      },
      trinket_tboj_curved_horn = {
        name = "Curved Horn",
        text = {
          "{C:white,X:mult}X#1#{} Mult"
        }
      },
      trinket_tboj_lucky_toe = {
        name = "Lucky Toe",
        text = {
          "Adds {C:attention}#1#{} to all {C:attention}listed",
          "{C:green,E:1,S:1.1}probabilities",
          "{C:inactive}(ex: {C:green}1 in 6{C:inactive} -> {C:green}2 in 6{C:inactive})",
        }
      },
      trinket_tboj_no = {
        name = "No!",
        text = {
          "{C:attention}Actives{} no longer",
          "appear in the shop"
        }
      },
      trinket_tboj_m = {
        name = "'M",
        text = {
          "Using an {C:attention}Active",
          "{C:attention}rerolls{} it"
        }
      },
      trinket_tboj_brain_worm = {
        name = "Brain Worm",
        text = {
          "Retrigger {C:attention}unscored{} cards",
          "{C:attention}#1#{} additionnal time"
        }
      },
    },
    Voucher = {
        
    },
    Other = {
      tboj_reroll = {
        name = "Reroll",
        text = {
            "{C:attention}Transform{} into a",
            "different card of",
            "the same {C:attention}set"
        }
      },
      undiscovered_loot = {
          name = "Not Discovered",
          text = {
              "Purchase or use",
              "this card in an",
              "unseeded run to",
              "learn what it does"
          }
      },
      used_ranks = {
          name = "Used ranks",
          text = {
              "#1#, #2#, #3#,",
              "#4#, #5#, #6#",
              "#7#, #8#, #9#",
              "#10#, #11#, #12#",
              "#13#, #14#"

          }
      },
      p_tboj_devil_pack_1 = {
        name = "Devil Pack",
        text = {
          "Choose {C:attention}#1#{} from among",
          "{C:attention}#2#{} devil {C:attention}Joker{} cards and",
          "{C:attention}#3#{} devil {C:attention}Active{} card",
        },
      },
    }
  },
  misc = {
    challenge_names = {
      c_tboj_daily_run = "Daily Run",
    },
    dictionary = {
      k_tboj_active = "Active",
      k_tboj_trinket = "Trinket",
      k_poop = "Poop",
      k_laser = "Laser",
      k_tboj_devil_pack = "Devil Pack",

      tboj_reroll_ex = "Reroll!",
      tboj_familiar = "Familiar",
      tboj_fly = "Fly",
      tboj_saved_by = "Saved by",
      tboj_fused = "Fused",
      tboj_not_fused = "Not fused",
      tboj_charged_ex = "Charged!",
      tboj_active = "Active",
      tboj_inactive = "Inactive",
      tboj_plus_loot = "+1 Loot",
      tboj_betrayal_ex = "Betrayal!",
    },  
    labels = {

    },
    poker_hands = {
        
    },
    quips = {
        
    },
    v_dictionary = {  
      tboj_percent = "#1#%",
    },
    v_text = {
        ch_c_tboj_daily_run = {"Play a random seed every day"},
        ch_c_tboj_daily_run2 = {"Resets at {C:attention}"..tostring(os.date("%I:%M %p", 0))}
    },
  }
  
}