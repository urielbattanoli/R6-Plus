//
//  Strings.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 10/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

struct Strings {
    
    static var ok: String { return "ok".localized }
    static var cancel: String { return "cancel".localized }
    static var buy: String { return "buy".localized }
    static var restore: String { return "restore".localized }
    static var errorOpenUrl: String { return "error_open_url".localized }
    
    struct Menu {
        static var proGames: String { return "pro_games".localized }
        static var leaderboard: String { return "leaderboard".localized }
        static var favorites: String { return "favorites".localized }
        static var premium: String { return "premium".localized }
        static var news: String { return "news".localized }
    }
    
    struct Search {
        static var playerNotFound: String { return "player_not_found".localized }
        static var search_player: String { return "search_player".localized }
        static var search: String { return "search".localized }
    }
    
    struct ProGames {
        static var noMatches: String { return "no_matches".localized }
        static var streamUnavailable: String { return "not_live".localized }
        static var live: String { return "live".localized }
        static var premiumMatches: String { return "premium_matches".localized }
    }
    
    struct Leaderboard {
        static var maintenance: String { return "maintenance".localized }
        static var skillRating: String { return "skillRating".localized }
        static var global: String { return "global".localized }
        static var apac: String { return "apac".localized }
        static var emea: String { return "emea".localized }
        static var ncsa: String { return "ncsa".localized }
    }
    
    struct Favorites {
        static var noFavorites: String { return "no_favorites".localized }
    }
    
    struct Premium {
        static var premium: String { return "premium".localized }
        static var thanksMessage: String { return "thanks_message".localized }
        static var helpUs: String { return "help_us_message".localized }
        static var buyNow: String { return "buy_now".localized }
    }
    
    struct OponentSelection {
        static var reachedMaximum: String { return "reached_maximum".localized }
        static var upgradeAccount: String { return "upgrade_account".localized }
        static var freeComp: String { return "free_comp".localized }
    }
    
    struct Statistics {
        
        static var generalStats: String { return "general_stats".localized }
        static var playerLevel: String { return "player_level".localized }
        static var wins: String { return "wins".localized }
        static var losses: String { return "losses".localized }
        static var Abandons: String { return "abandons".localized }
        static var winRate: String { return "win_rate".localized }
        static var kills: String { return "kills".localized }
        static var deaths: String { return "deaths".localized }
        static var assists: String { return "assists".localized }
        static var kdRatio: String { return "kd_ratio".localized }
        static var timePlayed: String { return "time_played".localized }
        static var casual: String { return "casual".localized }
        static var ranked: String { return "ranked".localized }
        static var total: String { return "total".localized }
        static var fightStats: String { return "fighting_stats".localized }
        static var aim: String { return "aim".localized }
        static var hsPercent: String { return "percentage_hs".localized }
        static var penetration: String { return "penetration_kills".localized }
        static var melee: String { return "melle_kills".localized }
        static var revived: String { return "revived".localized }
        static var rankedStats: String { return "ranked_stats".localized }
        static var rankedStatsLastSeason: String { return "ranked_stats_season".localized }
        static var mmr: String { return "mmr".localized }
        static var rank: String { return "rank".localized }
        static var skill: String { return "skill".localized }
        static var xp: String { return "XP".localized }
        static var profileInfo: String { return "profile_info".localized }
        static var season: String { return "season".localized }
        static var seasons: String { return "seasons".localized }
        static var aliases: String { return "aliases".localized }
        static var suicide: String { return "suicide".localized }
        static var abandons: String { return "abandons".localized }
        static var opDefenders: String { return "op_defenders".localized }
        static var opAttackers: String { return "op_attackers".localized }
    }
    
    struct Ranking {
        static var copper1: String { return "copper1".localized }
        static var copper2: String { return "copper2".localized }
        static var copper3: String { return "copper3".localized }
        static var copper4: String { return "copper4".localized }
        static var bronze1: String { return "bronze1".localized }
        static var bronze2: String { return "bronze2".localized }
        static var bronze3: String { return "bronze3".localized }
        static var bronze4: String { return "bronze4".localized }
        static var silver1: String { return "silver1".localized }
        static var silver2: String { return "silver2".localized }
        static var silver3: String { return "silver3".localized }
        static var silver4: String { return "silver4".localized }
        static var gold1: String { return "gold1".localized }
        static var gold2: String { return "gold2".localized }
        static var gold3: String { return "gold3".localized }
        static var gold4: String { return "gold4".localized }
        static var platinum1: String { return "platinum1".localized }
        static var platinum2: String { return "platinum2".localized }
        static var platinum3: String { return "platinum3".localized }
        static var diamond: String { return "diamond".localized }
        static var unranked: String { return "unranked".localized }
    }
}
