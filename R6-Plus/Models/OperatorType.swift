//
//  OperatorType.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 07/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

enum OperatorType {
    case attacker
    case defender
    case unknown
}

enum Operator: String {
    case ash = "Ash"
    case bandit = "Bandit"
    case blackbeard = "Blackbeard"
    case blitz = "Blitz"
    case buck = "Buck"
    case capitao = "Capitao"
    case castle = "Castle"
    case caveira = "Caveira"
    case doc = "Doc"
    case dokkaebi = "Dokkaebi"
    case echo = "Echo"
    case ela = "Ela"
    case finka = "Finka"
    case frost = "Frost"
    case fuze = "Fuze"
    case glaz = "Glaz"
    case hibana = "Hibana"
    case iq = "IQ"
    case jackal = "Jackal"
    case jager = "Jager"
    case kapkan = "Kapkan"
    case lesion = "Lesion"
    case lion = "Lion"
    case mira = "Mira"
    case montagne = "Montagne"
    case mute = "Mute"
    case pulse = "Pulse"
    case rook = "Rook"
    case sledge = "Sledge"
    case smoke = "Smoke"
    case tachanka = "Tachanka"
    case thatcher = "Thatcher"
    case thermite = "Thermite"
    case twitch = "Twitch"
    case valkyrie = "Valkyrie"
    case vigil = "Vigil"
    case ying = "Ying"
    case zofia = "Zofia"
    
    var type: OperatorType {
        switch self {
        case .ash, .blitz, .buck, .capitao, .dokkaebi, .finka, .frost, .fuze, .glaz, .hibana, .iq, .jackal, .lion, .montagne, .sledge, .thatcher, .thermite, .twitch, .zofia:
            return .attacker
        default: return .defender
        }
    }
}
