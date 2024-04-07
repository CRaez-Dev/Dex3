//
//  TempPokemon.swift
//  Dex3
//
//  Created by Carlos Raez on 7/04/24.
//

import Foundation

struct TempPokemon : Codable {
    let id              :   Int
    let name            :   String
    let types           :   [String]
    var hp              :   Int     =   0
    var attack          :   Int     =   0
    var defense         :   Int     =   0
    var specialAttack   :   Int     =   0
    var specialDefense  :   Int     =   0
    var speed           :   Int     =   0
    let sprite          :   URL
    let shiny           :   URL
    
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys:String, CodingKey{
            case type
            
            
            enum TypeKeys:String, CodingKey{
                case name
            }
        }
        
        enum StatsDictionaryKeys: String, CodingKey{
            case value = "base_stat"
            case stat
            
            
            enum StatKeys:String ,CodingKey{
                case name
                case url
            }
        }
        
        enum SpriteKeys :String ,CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
        
    }
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes : [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        self.types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.StatKeys.self,forKey: .stat)
            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                self.specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                self.speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("It will nevet get her so...")
            }
        }
        
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self,forKey: .sprites )
        
        self.sprite = try spriteContainer.decode(URL.self,forKey: .sprite)
        self.shiny = try spriteContainer.decode(URL.self,forKey: .shiny)       
        
    }
}


