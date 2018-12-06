//
//  CommonTransaction.swift
//
//  Created by Igor Efremov on 14/03/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

func == (lhs: CommonTransaction, rhs: CommonTransaction) -> Bool {
    return lhs.uuid == rhs.uuid && lhs.timestamp == rhs.timestamp && lhs.amount == rhs.amount
}

class CommonTransaction: Codable, Hashable {
    var uuid: String
    var date: String
    var ticker: CryptoTicker = .VEO
    var amount: String
    var timestamp: UInt64
    
    var to: String = ""
    var from: String = ""
    var fee: String = ""

    var nonce: Int = 0

    var pending: Bool = false

    var hashValue: Int {
        return uuid.djb2hash ^ amount.hashValue ^ timestamp.hashValue
    }
    
    private enum CodingKeys: String, CodingKey {
        case uuid, date, ticker, amount, timestamp, to, from, fee, nonce
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.date = try container.decode(String.self, forKey: .date)
        self.ticker = try container.decode(CryptoTicker.self, forKey: .ticker)
        self.amount = try container.decode(String.self, forKey: .amount)
        self.timestamp = try container.decode(UInt64.self, forKey: .timestamp)
        self.to = try container.decode(String.self, forKey: .to)
        self.from = try container.decode(String.self, forKey: .from)
        self.fee = try container.decode(String.self, forKey: .fee)
        self.nonce = try container.decode(Int.self, forKey: .nonce)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(date, forKey: .date)
        try container.encode(amount, forKey: .amount)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(to, forKey: .to)
        try container.encode(from, forKey: .from)
        try container.encode(fee, forKey: .fee)
        try container.encode(nonce, forKey: .nonce)
    }
    
    init(uuid: String, amount: String, fee: String = "", timestamp: UInt64 = 0, nonce: Int = 0) {
        self.uuid = uuid
        self.amount = amount
        self.fee = fee
        self.timestamp = timestamp
        self.date = Date(timeIntervalSince1970: TimeInterval(timestamp)).formattedWith("dd.MM.YYYY HH:mm:ss")
        self.nonce = nonce
    }
}
