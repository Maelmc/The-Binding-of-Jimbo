return {
  descriptions = {
    tboj_active = {
      active_tboj_book_of_belial = {
        name = "The Book of Belial",
        text = {
          {
            "#1#/#2# {C:attention}charge",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Add {C:mult}+#3#{} Mult to",
            "{C:attention}#4#{} selected card"
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
            "card into a",
            "{C:attention}Poop Card"
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
            "#1#/#2# {C:attention}charges",
            "Must be fully charged to use",
            "Recharges at end of round"
          },
          {
            "Create a random",
            "{C:tarot}Tarot{} card",
            "{C:inactive}(Must have room)"
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
            "{s:0.8}Charged by #3# when using {C:attention,s:0.8}Lil' Battery"
          },
          {
            "{C:white,X:mult}X#4#{} Mult for each",
            "charge when used",
            "{C:inactive}(Currently {C:white,X:mult}X#5#{C:inactive} Mult and #6#)"
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
      j_tboj_the_halo = {
        name = "The Halo",
        text = {
          "{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult",
          "Earn {C:money}$#3#{} at",
          "end of round"
        }
      },
      j_tboj_a_lump_of_coal = {
        name = "A Lump of Coal",
        text = {
          "{C:white,X:red}X1{} Mult, plus",
          "{C:white,X:red}X#1#{} for each",
          "scoring card"
        }
      },
      j_tboj_sacred_heart = {
        name = "Sacred Heart",
        text = {
          "{C:attention}Unscored cards{}",
          "give {C:mult}+#1#{} and {C:white,X:mult}X#2#{} Mult"
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
      j_tboj_proptosis = {
        name = "Proptosis",
        text = {
          "Played cards give {C:white,X:mult}X#1#{} Mult",
          "divided by their {C:attention}position",
          "in {C:attention}played hand{} when scored"
        }
      },
      j_tboj_bozo = {
        name = "Bozo",
        text = {
          "If first hand of round is",
          "a single {C:attention}Poop{} cards,",
          "add {C:dark_edition}Polychrome{} to it"
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
          "Played {C:attention}Poop{} cards",
          "give {C:white,X:red}X#1#{} Mult",
          "when scored"
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
          "Fully charges",
          "selected {C:attention}Active"
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
        name = "Pulse Worm",
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
    }
  },
  misc = {
    challenge_names = {
      
    },
    dictionary = {
      k_tboj_active = "Active",
      k_tboj_trinket = "Trinket",
      k_poop = "Poop",
      k_laser = "Laser",

      tboj_reroll_ex = "Reroll!",
      tboj_familiar = "Familiar",
      tboj_fly = "Fly",
      tboj_saved_by = "Saved by",
      tboj_fused = "Fused",
      tboj_not_fused = "Not fused",
      tboj_charged_ex = "Charged!",
      tboj_active = "Active",
      tboj_inactive = "Inactive",
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
        
    },
  }
  
}