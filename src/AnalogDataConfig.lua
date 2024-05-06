local analogData = {}


--模拟机台spin 数据 没有中奖
analogData.batchSpin = {
    list = {
        {
            daily_bonus_multiplier = 0.01,
            base_win = 0,
            blazing_challenge = {
                missions = {
                    {
                        type = 2000,
                        min_bet = 0,
                        target = 50,
                        grade = 0,
                        progress = 0,
                        equal_chip = 10,
                        theme_id = 2000,
                        exp = 600
                    }
                }
            },
            bonus_base_win = 0,
            theme_info = {
                disk_data = {
                    ["20000"] = {20}
                },
                new_disk = {{}, {}, {}, {}, {}},
                map_info = {
                    wager_count = 14,
                    map_level = 0,
                    map_points = 38.5,
                    wager = 10820000000
                }
            },
            lounge_min_bet = 100000,
            jp_win = {},
            win_pos_list = {},
            item_list_down = {
                {4, 4, 5, 5, 5, 5},
                {5, 2, 4, 5, 9, 3},
                {9, 9, 6, 3, 3, 4},
                {6, 6, 6, 5, 5, 6},
                {5, 9, 9, 9, 6, 7}
            },
            coins = 222281893459,
            item_list = {
                {6, 5, 4, 4},
                {6, 3, 3, 4},
                {4, 2, 2, 7},
                {5, 5, 5, 6},
                {5, 3, 3, 3}
            },
            piggy_bag_info = {
                top_bag_coins = 187500,
                cur_bag_coins = 187500
            },
            item_list_up = {
                {4}, {9}, {7}, {5}, {6}
            },
            dashboard = {
                mission = {
                    target = 1,
                    index = 1,
                    type = 3,
                    count = 0,
                    tid = 0,
                    current = 0
                }
            },
            win_lines = {},
            total_win = 0,
            level_up_party = {
                is_activated = 0
            },
            lounge = {},
            experience = "1061337783250"
        }
    }
}

--模拟机台spin 数据 普通中奖
analogData.batchSpinNormalWin = {
    list = {
        {
            daily_bonus_multiplier = 0.83,
            base_win = 5175000000,
            blazing_challenge = {
                missions = {{type = 2000,min_bet = 0,target = 50,grade = 0,progress = 26,equal_chip = 10,theme_id = 2000,exp = 600}}
            },
            bonus_base_win = 0,
            experience = 1074573283250,
            lounge_min_bet = 100000,
            jp_win = {},
            ad_ag = 1,
            item_list_down = {{2,4,5,9,3,7},{2,4,5,9,3,7},{3,3,3,5,5,4},{2,2,2,4,7,6},{7,7,9,9,9,9}},
            win_pos_list = {{1,1},{2,1},{3,1},{4,1},{1,2},{2,2},{3,2},{4,2},{5,2},{1,3},{2,3},{3,3},{4,3},{5,1},{3,4},{1,4},{2,4}},
            atw = {bag_progress = 0.96},
            item_list = {{3,3,4,5},{3,3,4,5},{4,9,7,3},{5,5,4,6},{6,6,6,6}},
            ad_count = 245660785,
            piggy_bag_info = {top_bag_coins = 187500,cur_bag_coins = 187500},
            win_lines = {{line = 1,count = 4,symbol = 4},{line = 2,count = 5,symbol = 6},{line = 3,count = 3,symbol = 7},{line = 5,count = 4,symbol = 4},{line = 6,count = 4,symbol = 4},{line = 8,count = 5,symbol = 6},{line = 9,count = 4,symbol = 7},{line = 11,count = 5,symbol = 6},{line = 12,count = 4,symbol = 7},{line = 13,count = 3,symbol = 3},{line = 14,count = 4,symbol = 4},{line = 15,count = 4,symbol = 4},{line = 17,count = 4,symbol = 4},{line = 18,count = 3,symbol = 7},{line = 19,count = 5,symbol = 6},{line = 21,count = 4,symbol = 4},{line = 22,count = 3,symbol = 7},{line = 23,count = 4,symbol = 7},{line = 24,count = 4,symbol = 3},{line = 25,count = 4,symbol = 4},{line = 26,count = 3,symbol = 5},{line = 27,count = 4,symbol = 7},{line = 28,count = 3,symbol = 3},{line = 29,count = 4,symbol = 4},{line = 30,count = 3,symbol = 5}},
            vouchers_give_coins = 245660785,
            item_list_up = {{6},{6},{4},{3},{5}},
            dashboard = {mission = {target = 5,index = 3,type = 6,count = 2400000000,tid = 0,current = 1}},
            total_win = 5175000000,
            theme_info = {
                disk_data = {["900000000"] = {9,8,6,11,4}},
                wild_pos = {11,7,12,1,2,9,8,6,4},
                meteor_list = {6},
                expand_list = {["6"] = {11,7,12,1,2}},
                new_disk = {{},{},{},{},{}},
                post_wild_pos = {6},
                map_info = {wager_count = 60,map_level = 0,map_points = 61.6,wager = 50240000000},
                hit_flag = 1
            },
            level_up_party = {
                tasks = {
                    {start = 618,target = 635,price_config = {double_xp = 3600,atw = {0,20,0,0,0}},current = 619},
                    {start = 618,target = 651,price_config = {lounge_point = 500,byd = {0,20,0,0}},current = 618},
                    {start = 618,target = 686,price_config = {stamp_list = {{place = 69,label = "LEVEL UP PARTY REWARDS",config = {5,{0,0},{0,0},{1,3},-1}}},coins = 2800000000},current = 618}
                },
                end_time = 1697024783,
                is_activated = 1,
                index = 1
            },
            coins = 240487067126,
            lounge = {eligible_spin = {bet = 100000,target = 200,current = 123}}
        }
    }
}

--模拟机台spin 数据 big_win
analogData.batchSpinBigWin = {
    list = {
        {
            daily_bonus_multiplier = 0.38,
            base_win = 12555000000,
            blazing_challenge = {
                missions = {
                    {
                        type = 2000,
                        min_bet = 0,
                        target = 50,
                        grade = 0,
                        progress = 0,
                        equal_chip = 10,
                        theme_id = 2000,
                        exp = 600
                    }
                }
            },
            bonus_base_win = 0,
            experience = 1066012783250,
            lounge_min_bet = 100000,
            jp_win = {},
            ad_ag = 1,
            item_list_down = {
                {5,9,9,9,6,7},
                {7,7,9,9,9,9},
                {7,3,3,3,3,5},
                {3,3,5,9,9,9},
                {4,6,7,3,3,3}
            },
            win_pos_list = {
                {1,1},
                {2,1},
                {3,1},
                {4,1},
                {5,1},
                {1,2},
                {2,2},
                {3,2},
                {4,2},
                {5,2},
                {1,3},
                {2,3},
                {3,3},
                {1,4},
                {2,4},
                {3,4},
                {4,3},
                {4,4},
                {5,3}
            },
            atw = {bag_progress = 0.71},
            item_list = {
                {5,3,9,3},
                {6,6,7,6},
                {2,4,4,6},
                {7,6,5,3},
                {2,2,2,4}
            },
            ad_count = 989239760,
            piggy_bag_info = {
                top_bag_coins = 187500,
                cur_bag_coins = 187500
            },
            win_lines = {
                {
                    line = 1,
                    count = 5,
                    symbol = 2
                },
                {
                    line = 2,
                    count = 5,
                    symbol = 2
                },
                {
                    line = 3,
                    count = 3,
                    symbol = 4
                },
                {
                    line = 4,
                    count = 3,
                    symbol = 6
                },
                {line = 5,
                count = 5,
                symbol = 2},
                {line = 6,
                count = 5,
                symbol = 5},
                {line = 7,
                count = 3,
                symbol = 4},
                {line = 8,
                count = 5,
                symbol = 2},
                {line = 9,
                count = 4,
                symbol = 4},
                {line = 10,
                count = 3,
                symbol = 6},
                {line = 11,
                count = 5,
                symbol = 2},
                {line = 12,
                count = 5,
                symbol = 4},
                {line = 13,
                count = 3,
                symbol = 6},
                {line = 14,
                count = 5,
                symbol = 2},
                {line = 15,
                count = 4,
                symbol = 5},
                {line = 16,
                count = 3,
                symbol = 4},
                {line = 17,
                count = 4,
                symbol = 5},
                {line = 18,
                count = 3,
                symbol = 4},
                {line = 19,
                count = 5,
                symbol = 2},
                {line = 20,
                count = 5,
                symbol = 4},
                {line = 21,
                count = 5,
                symbol = 5},
                {line = 22,
                count = 3,
                symbol = 4},
                {line = 23,
                count = 5,
                symbol = 4},
                {line = 24,
                count = 5,
                symbol = 6},
                {line = 25,
                count = 4,
                symbol = 5},
                {line = 26,
                count = 4,
                symbol = 3},
                {line = 27,
                count = 5,
                symbol = 4},
                {line = 28,
                count = 3,
                symbol = 6},
                {line = 29,
                count = 5,
                symbol = 2},
                {line = 30,
                count = 4,
                symbol = 5}
            },
            vouchers_give_coins = 247309940,
            item_list_up = {{6},{7},{2},{4},{2}},
            dashboard = {
                mission = {
                    target = 2160000000,
                    index = 2,
                    type = 5,
                    count = 0,
                    tid = 0,
                    current = 2160000000
                }
            },
            total_win = 12555000000,
            theme_info = {
                disk_data = {
                    ["900000000"] = {2,7,16,1,6,11,12,17,4}
                },
                wild_pos = {9,5,10,3,8,2,7,16,1,6,11,12,17,4},
                meteor_list = {4},
                expand_list = {["4"] = {9,5,10,3,8}},
                new_disk = {{},{},{},{},{}},
                post_wild_pos = {4},
                map_info = {
                    wager_count = 35,
                    map_level = 0,
                    map_points = 52.1,
                    wager = 29520000000
                },
                hit_flag = 1
            },
            level_up_party = {is_activated = 0},
            coins = 222891492578,
            lounge = {
                eligible_spin = {
                    bet = 100000,
                    target = 200,
                    current = 98
                }
            }
        }
    }
}

--模拟机台spin freegame
analogData.batchSpinFreeGame = {
    list = {
        {
            daily_bonus_multiplier = 0.93,
            base_win = 1080000000,
            total_win = 1080000000,
            bonus_base_win = 0,
            experience = 1077273283250,
            lounge_min_bet = 100000,
            jp_win = {},
            ad_ag = 1,
            item_list_down = {{6,7,3,3,3,3},{7,4,6,5,6,6},{4,6,5,7,7,7},{7,9,9,6,3,3},{7,4,6,5,4,4}},
            free_spins = 1,
            win_pos_list = {{1,3},{2,2},{3,1},{4,2}},
            bonus_level = 2000000,
            win_lines = {{line = 29,count = 4,symbol = 4}},
            vouchers_give_coins = 245250997,
            coins = 262904593588,
            item_list = {{2,2,4,9},{6,4,5,8},{4,5,8,7},{7,4,2,2},{6,4,5,8}},
            ad_count = 245250997,
            piggy_bag_info = {top_bag_coins = 187500,cur_bag_coins = 187500},
            theme_info = {
                all_disk_data = {
                    ["2000000"] = {}, 
                    ["700000000"] = {},
                    ["400000000"] = {}, 
                    ["900000000"] = {16},
                    ["800000000"] = {12,4},
                    ["20000"] = {20},
                    ["40000"] = {},
                    ["200000"] = {},
                    ["10000000"] = {16,13},
                    ["20000000"] = {},
                    ["10000"] = {},
                    ["40000000"] = {},
                    ["100000"] = {},
                    ["600000000"] = {},
                    ["6000000"] = {},
                    ["500000"] = {},
                    ["200000000"] = {},
                    ["150000000"] = {},
                    ["4000000"] = {},
                    ["100000000"] = {},
                    ["50000"] = {},
                    ["1000000"] = {}
                },
                fg_disk = {},
                new_disk = {{},{},{},{},{}},
                disk_data = {["900000000"] = {16}},
                map_info = {
                    wager_count = 66,
                    map_level = 0,
                    map_points = 65.6,
                    wager = 55640000000
                }
            },
            lounge = {
                eligible_spin = {
                    bet = 100000,
                    target = 200,
                    current = 129
                }
            },
            item_list_up = {{2},{7},{6},{6},{7}},
            dashboard = {mission = {target = 5,index = 3,type = 6,count = 2400000000,tid = 0,current = 1}},
            levelup_dialog = {},
            levelup = {
                {
                    level = 620,
                    lounge_points = 166,
                    vip_points_delta = 6,
                    vip_level = 3,
                    lounge = {
                        delta_lounge_points = 0,
                        delta_reward_coins = 166,
                        dashboard = {
                            mission = {
                                target = 5,
                                index = 3,
                                type = 6,
                                count = 2400000000,
                                tid = 0,
                                current = 1
                            }
                        },
                        end_time = 1698745434
                    },
                    max_bet_multiplier = 90000,
                    level_up_bonus = 92000000,
                    instant_reward = 30000000,
                    turbo_reward = 75000000,
                    level_burst_multiplier = 1,
                    daily_reward = 150000000,
                    bet_per_line = {10000, 30000, 60000, 90000, 120000, 150000,180000, 300000, 450000, 500000, 600000}
                }
            },
            level_up_party = {
                tasks = {
                    {
                        start = 618,
                        target = 635,
                        price_config = {
                            double_xp = 3600,
                            atw = {0,20,0,0,0}
                        },
                        current = 620
                    },
                    {
                        start = 618,
                        target = 651,
                        price_config = {
                            lounge_point = 500,
                            byd = {0,20,0,0}
                        },
                        current = 618
                    },
                    {
                        start = 618,
                        target = 686,
                        price_config = {
                            stamp_list = {
                                {
                                    place = 69,
                                    label = "LEVEL UP PARTY REWARDS",
                                    config = {5,{0,0},{0,0},{1,3},-1}
                                }
                            },
                            coins = 2800000000
                        },
                        current = 618
                    }
                },
                end_time = 1697024783,
                is_activated = 1,
                index = 1
            },
            free_game = {
                fg_disk = {},
                free_spins = 10,
                wild_pos = {}
            },
            atw = {bag_progress = 0.02}
        }
    }
}	

return analogData