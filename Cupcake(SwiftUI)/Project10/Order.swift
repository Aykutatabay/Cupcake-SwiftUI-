//
//  Order.swift
//  Project10
//
//  Created by Aykut ATABAY on 17.10.2022.
//

import SwiftUI

class Order: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    static let types = ["Vanilla", "Strawberry", "Chcoloate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            extraFrosting = false
            addSprinkles = false
        }
    }
    
    @Published var extraFrosting = false
    @Published var addSprinkles = false
        
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        // Property wrapper cannot be applied to a computed property
        
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    var cost: Double {
        
        // 2$ per cake
        var cost = Double(quantity) * 2
        
        //complicated cakes cost more
        
        cost += (Double(type) / 2)
        
        // $1 extra frosting
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity)
        }
        
        return cost
    }
    
    init() { }
    
    func encode(to encoder: Encoder) throws {
        
        //  burada amac bu obje içindeki property lerin hangilerinin codable olup olmadıgına kendimiz karar veriyoruz
        // bu yüzden bu sekilde verilerimizi manuel olarak el ile tek tek key ile sakladık
        
        // Encode etmek demek; buradaki verileri belli bir formatta anlasılacak hale getirmek demek.
        //Decode ise bu formatta alınan verileri tekrar buradaki veri degisken vs ye cevirmek demek
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
        
    }
}
