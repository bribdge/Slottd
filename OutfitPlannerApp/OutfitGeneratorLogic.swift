//
//  OutfitGeneratorLogic.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 24/06/2026.
//

import Foundation
import SwiftData
import SwiftUI
import FoundationModels
import EventKit

enum ClothingStyle: String, Codable, CaseIterable, Identifiable {
    case casual = "Casual"
    case formal = "Formal"
    case sporty = "Sporty"
    case vintage = "Vintage"
    case streetwear = "Streetwear"
    case bold = "Bold"
    case businessCasual = "Business Casual"
    case grunge = "Grunge"
    case comfy = "Comfy"
    
    var id: Self { self }
}

enum ClothingColor: String, Codable, CaseIterable, Identifiable {
    case white = "White"
    case black = "Black"
    case gray = "Gray"
    case blue = "Blue"
    case red = "Red"
    case orange = "Orange"
    case green = "Green"
    case yellow = "Yellow"
    case pink = "Pink"
    case purple = "Purple"
    case brown = "Brown"
    case multicolor = "Multicolor"
    
    var id: Self { self }
}

enum ClothingType: String, Codable, CaseIterable, Identifiable {
    // Upper Body
    case top = "Top"
    case fullBody = "Full Body"
    
    // Lower Body
    case bottom = "Bottom"
    
    // Footwear
    case footwear = "Footwear"
    
    // Accessories & Extras
    case accessory = "Accessory"
    
    var id: Self { self }
}

@Model // @model classes can only support basic types, like string and int, but not enums. "String, Codable" have been applied to the enums so that they are read to the class as strings.
class ClothingItem {
    var name: String
    var style: ClothingStyle
    var color: ClothingColor
    var type: ClothingType
    @Attribute(.externalStorage) var image: Data? // @Attribute() tells SwiftData that the images should be stored right into the storage and not in the SQLite database. Keeps the app fast
    
    var outfitsAsTop: [Outfit] = []
    var outfitsAsBottom: [Outfit] = []
    var outfitsAsFootwear: [Outfit] = []
//    var attire: ClothingAttire
    
    init(/*image: PhotosPickerItem, */name: String, style: ClothingStyle, color: ClothingColor, type: ClothingType, image: Data?, parentOutfits: [Outfit]?/*, attire: ClothingAttire*/) {
//        self.image = image
        self.name = name
        self.style = style
        self.color = color
        self.type = type
        self.image = image
//        self.attire = attire
    }
    
    var description: String {
        "\(name) (\(style.rawValue), \(color.rawValue))"
        }
}

@Model
class Outfit {
    var id: UUID
    
    @Relationship(deleteRule: .nullify, inverse: \ClothingItem.outfitsAsTop)
    var top: ClothingItem?
    
    @Relationship(deleteRule: .nullify, inverse: \ClothingItem.outfitsAsBottom)
    var bottom: ClothingItem?
    

    var accessories: [ClothingItem] = []
    
    @Relationship(deleteRule: .nullify, inverse: \ClothingItem.outfitsAsFootwear)
    var footwear: ClothingItem?
    var occasionIdentifier: String?
    var outfitRationale: String?
    var accessoryRationale: String?
    var isValid: Bool
    init(top: ClothingItem?, bottom: ClothingItem?, accessories: [ClothingItem], footwear: ClothingItem?, occasionIdentifier: String?, outfitRationale: String?, accessoryRationale: String? ,isValid: Bool, id: UUID) {
        self.accessories = accessories
        self.footwear = footwear
        self.top = top
        self.bottom = bottom
        self.occasionIdentifier = occasionIdentifier
        self.outfitRationale = outfitRationale
        self.outfitRationale = outfitRationale
        self.isValid = isValid
        self.id = id
    }
    
    var aiDescription: String {
        return "Top:\(top?.description ?? "") | Bottom:\(bottom?.description ?? "") | Footwear:\(footwear?.description ?? "")"
    }
    
    var description: String {
        return "Top: \(top?.description ?? "")\nBottom: \(bottom?.description ?? "")\nFootwear: \(footwear?.description ?? "")"
    }
}

@Model
class DailyOutfitList {
    var dailyOutfit: Outfit
    var eventOutfits: [Outfit]
    
    init(dailyOutfit: Outfit, eventOutfits: [Outfit]) {
        self.dailyOutfit = dailyOutfit
        self.eventOutfits = eventOutfits
    }
    
    var description: String {
        return "Daily Outfit: \(dailyOutfit.description), Event Outfits: \(eventOutfits.map() { $0.description })"
    }
}

func colorDoesClash(color1: ClothingColor, color2: ClothingColor) -> Bool {
    if color1 == color2 {
        return false
    }
    
    switch color1 {
    case .blue:
        switch color2 {
        case .red, .orange, .black: return true
        default: return false
    }
    case .red:
        switch color2 {
        case .blue, .orange, .purple, .green: return true
        default: return false
        }
    case .green:
        switch color2 {
        case .orange, .red, .purple: return true
        default: return false
        }
    case .yellow:
        switch color2 {
        case .pink, .purple: return true
        default: return false
        }
    case .orange:
        switch color2 {
        case .blue, .pink, .red, .green, .purple: return true
        default: return false
        }
    case .purple:
        switch color2 {
        case .red, .green, .yellow, .orange: return true
        default: return false
        }
    case .brown:
        switch color2 {
        case .black: return true
        default: return false
        }
    case .black:
        switch color2 {
        case .blue, .brown: return true
        default: return false
        }
    default:
        return false
    }
}

func styleDoesClash(style1: ClothingStyle, style2: ClothingStyle) -> Bool {
    if style1 == style2 {
        return false
    }
    
    switch style1 {
    case .casual:
        switch style2 {
        case .bold, .formal: return true
        default: return false
        }
    case .formal:
        switch style2 {
        case .casual, .sporty, .streetwear, .bold, .grunge, .comfy: return true
        default: return false
        }
    case .sporty:
        switch style2 {
        case .formal, .vintage: return true
        default: return false
        }
    case .vintage:
        switch style2 {
        case .sporty, .streetwear, .comfy: return true
        default: return false
        }
    case .streetwear:
        switch style2 {
        case .formal, .vintage, .businessCasual: return true
        default: return false
        }
    case .bold:
        switch style2 {
        case .casual, .formal, .businessCasual, .comfy: return true
        default: return false
        }
    case .businessCasual:
        switch style2 {
        case .streetwear, .bold, .grunge, .comfy: return true
        default: return false
        }
    case .grunge:
        switch style2 {
        case .formal, .businessCasual: return true
        default: return false
        }
    default:
        switch style2 {
        case .formal, .vintage, .bold, .businessCasual: return true
        default: return false
        }
    }
}

func separateClothingByType(clothingItems: [ClothingItem]) -> (tops: [ClothingItem], bottoms: [ClothingItem], footwear: [ClothingItem], accessories: [ClothingItem]) {
    var tops: [ClothingItem] = []
    var bottoms: [ClothingItem] = []
    var footwear: [ClothingItem] = []
    var accessories: [ClothingItem] = []
    
    for clothingItem in clothingItems {
        switch clothingItem.type {
            case .top, .fullBody:  tops.append(clothingItem)
            case .bottom:          bottoms.append(clothingItem)
            case .footwear:        footwear.append(clothingItem)
            case .accessory:       accessories.append(clothingItem)
        }
    }
    
    return (tops, bottoms, footwear, accessories)
}

@Generable()
struct AccessoryResponse {
    @Guide(description: "The index(es) of the accessories you chose.", .element(.range(0...7)))
    var indexes: [Int]
    
    @Guide(description: "A VERY brief, casual reason why the accessories fit the outfit.")
    var rationale: String
}

@Generable()
struct OutfitResponse {
    @Guide(description: "The index of the outfit you have chosen.", .range(0...7))
    var index: Int
    
    @Guide(description: "A casual but not too short reason why this outfit works, and why it fits the occasion. Never reference the other choices. Never reference acessories, outerwear, or other clothing items. Lean more towards a description of what the outfit can do rather than why it works.")
    var rationale: String
}


let sportyKeywords = [
    "workout", "gym session", "weight lifting", "weightlifting", "free weights", "cardio", "fitness class", "bootcamp",
    "crossfit", "calisthenics", "bodybuilding", "strength training",
    "running", "track and field", "marathon", "5k", "10k", "sprinting", "jogging",
    "soccer", "football", "basketball", "tennis", "badminton", "volleyball", "rugby", "baseball",
    "hiking", "rock climbing", "cycling", "biking", "swimming laps", "swim laps", "lap pool", "skateboarding",
    "yoga class", "vinyasa", "pilates", "athletic", "training", "sports practice", "team practice"
]

let formalKeywords = [
    "black tie", "white tie", "gala", "prom", "charity ball", "awards banquet", "award ceremony", "wedding ceremony", "opera", "ballet",
    "job interview", "business conference", "board meeting", "client pitch", "corporate event", "networking event", "academic seminar", "thesis defense",
    "funeral", "memorial service", "graduation ceremony", "court appearance",
    "cocktail attire", "formal wear", "business professional"
]

let comfyKeywords = [
    "lounging", "lazy day", "staying home", "chilling", "movie night", "lying in bed", "sleeping",
    "pajamas", "pajama party", "loungewear", "sweatpants day",
    "gaming", "video games", "studying at home", "cramming", "rest", "recovery", "sick", "couch potato",
    "staycation", "hangout", "casual Sunday"
]

let boldKeywords = [
    "nightclub", "clubbing", "rave", "music festival", "concert gig", "edm festival", "bar hopping", "pub crawl",
    "birthday party", "bachelorette", "bachelor party", "vip lounge", "carnival",
    "date night", "dinner date", "fashion show", "runway showcase",
    "costume party", "halloween party", "themed party", "cosplay"
]

func generateDailyOutfit(tops: [ClothingItem], bottoms: [ClothingItem], footwear: [ClothingItem], accessories: [ClothingItem], occasionTitle: String, occasionIdentifier: String?) async -> Outfit {
    let model = SystemLanguageModel.default
    let session = LanguageModelSession()
    var randomOutfitCombinations: [Outfit] = []
    var randomOutfitCombinationDescriptions: [String] = []
    var randomAccessories: [ClothingItem] = []
    var randomAccessoryDescriptions: [String] = []
    var isValid: Bool = true
    
    // filtering clothing items
    

    
    let titleLowercased = occasionTitle.lowercased()
    let isSportyEvent = sportyKeywords.contains { titleLowercased.contains($0) }
    let isFormalEvent = formalKeywords.contains { titleLowercased.contains($0) }
    let isComfyEvent = comfyKeywords.contains { titleLowercased.contains($0) }
    let isBoldEvent = boldKeywords.contains { titleLowercased.contains($0) }
    
    let filteredTops = tops.filter { item in
        if isSportyEvent { return item.style == .sporty || item.style == .comfy }
        if isFormalEvent { return item.style == .formal || item.style == .businessCasual }
        if isComfyEvent  { return item.style == .comfy  || item.style == .casual }
        if isBoldEvent   { return item.style == .bold   || item.style == .streetwear || item.style == .grunge }
        return true // default to all if there is no specific type
    }

    let filteredBottoms = bottoms.filter { item in
        if isSportyEvent { return item.style == .sporty || item.style == .comfy }
        if isFormalEvent { return item.style == .formal || item.style == .businessCasual }
        if isComfyEvent  { return item.style == .comfy  || item.style == .casual }
        if isBoldEvent   { return item.style == .bold   || item.style == .streetwear || item.style == .grunge }
        return true
    }

    let filteredFootwear = footwear.filter { item in
        if isSportyEvent { return item.style == .sporty }
        if isFormalEvent { return item.style == .formal || item.style == .businessCasual }
        if isComfyEvent  { return item.style == .comfy  || item.style == .casual }
        if isBoldEvent   { return item.style == .bold   || item.style == .streetwear || item.style == .formal }
        return true
    }
    
    if filteredTops == [] || filteredBottoms == [] || filteredFootwear == [] { // maybe change to .count() < 4
        isValid = false
    }
    
    let finalTops = filteredTops.isEmpty ? tops: filteredTops
    let finalBottoms  = filteredBottoms.isEmpty ? bottoms : filteredBottoms
    let finalFootwear = filteredFootwear.isEmpty ? footwear : filteredFootwear
    
    if model.isAvailable == true {
        
    for _ in 1...8 {
        var count = 25
        inner: while true {
            count -= 1
            
            var randomOutfit = Outfit(top: nil, bottom: nil, accessories: [], footwear: nil, occasionIdentifier: occasionIdentifier, outfitRationale: nil, accessoryRationale: nil, isValid: false, id: UUID())
            
            let randomTop = finalTops.randomElement()
            
            if randomTop?.type == .fullBody {
                randomOutfit = Outfit(top: randomTop, bottom: nil, accessories: [], footwear: finalFootwear.randomElement()!, occasionIdentifier: occasionIdentifier, outfitRationale: nil, accessoryRationale: nil, isValid: isValid, id: UUID())
            } else {
                randomOutfit = Outfit(top: randomTop, bottom: finalBottoms.randomElement()!, accessories: [], footwear: finalFootwear.randomElement()!, occasionIdentifier: occasionIdentifier, outfitRationale: nil, accessoryRationale: nil, isValid: isValid, id: UUID())
            }
            
            if count <= 0 {
                randomOutfitCombinations.append(randomOutfit)
                randomOutfitCombinationDescriptions.append(randomOutfit.aiDescription)
                break inner
            }
            
            if colorDoesClash(color1: randomTop?.color ?? .white, color2: randomOutfit.bottom?.color ?? .white) || styleDoesClash(style1: randomTop?.style ?? .casual, style2: randomOutfit.bottom?.style ?? .casual) {
                continue inner
            }
            
            randomOutfitCombinations.append(randomOutfit)
            randomOutfitCombinationDescriptions.append(randomOutfit.aiDescription)
            break inner
            }
        if !accessories.isEmpty {
            if let picked = accessories.randomElement() {
                randomAccessories.append(picked)
                randomAccessoryDescriptions.append(picked.description)
            }
        }
        
        }
        
        let formattedOutfits = randomOutfitCombinationDescriptions.enumerated() // .enumerated adds the ability to show the index as well. $0.offset is the index and $0.element is the actual item
            .map { "[\($0.offset)] \($0.element)" }
            .joined(separator: "\n")
        
        let formattedAccessories = randomAccessoryDescriptions.enumerated() // .enumerated adds the ability to show the index as well. $0.offset is the index and $0.element is the actual item
            .map { "[\($0.offset)] \($0.element)" }
            .joined(separator: "\n")
        
        do {
            let prompt = """
                You are a professional fashion planner AI. Your task is to analyze a list of outfits and select the single best option.

                CRITERIA FOR "FASHIONABLE":
                - Color Harmony: Look for complementary colors or intentional tonal palettes.
                - Style Cohesion: High marks for pieces that share a cohesive aesthetic (e.g., Minimalist + Minimalist, Retro + Bohemian). Avoid jarring style clashes (e.g., Avant Garde + Sporty).
                \(occasionTitle == "" ? "- A regular day. Could be out and about or lounging around inside." : "- Outfit Occasion: The name of this outfit's occasion is \(occasionTitle). Choose an outfit that best suits this occasion.")
            
                Always prioritize making the outfit fit the occasion rather than what looks most stylish.
            
            \(formattedOutfits) 
            """
            let response = try await session.respond(to: prompt, generating: OutfitResponse.self) // await forces the code ahead to stop and wait for the response to finish loading
            let chosenOutfit = randomOutfitCombinations[response.content.index]
            
            let accessoryPrompt = """
                You are a professional accessory picking AI. Your task is to find the best accessories to math the outfit provided

                CRITERIA FOR "FASHIONABLE":
                - Color Harmony: Look for complementary colors or intentional tonal palettes.
                - Style Cohesion: High marks for pieces that share a cohesive aesthetic (e.g., Minimalist + Minimalist, Retro + Bohemian). Avoid jarring style clashes (e.g., Avant Garde + Sporty).
            
                Always prioritize making the accessory fit the outfit rather than what looks most stylish on its own.
            
                OUTFIT: \(chosenOutfit.aiDescription)
            
            \(formattedAccessories)
                
            """
            
            if accessories != [] {
                let accessoryResponse = try await session.respond(to: accessoryPrompt, generating: AccessoryResponse.self)
                chosenOutfit.accessoryRationale = accessoryResponse.content.rationale
                
                for accessoryIndex in accessoryResponse.content.indexes {
                    chosenOutfit.accessories.append(randomAccessories[accessoryIndex])
                }
            }
            
            chosenOutfit.outfitRationale = response.content.rationale

            return chosenOutfit
        } catch {
            print(error)
            return generateDailyOutfitFallback(tops: tops, bottoms: bottoms, footwear: footwear, occasionTitle: occasionTitle, occasionIdentifier: occasionIdentifier)
        }
    }
    return generateDailyOutfitFallback(tops: tops, bottoms: bottoms, footwear: footwear, occasionTitle: occasionTitle, occasionIdentifier: occasionIdentifier)
}

func generateDailyOutfitFallback(tops: [ClothingItem], bottoms: [ClothingItem], footwear: [ClothingItem], occasionTitle: String, occasionIdentifier: String?) -> Outfit {
    var isValid: Bool = true
    
    let titleLowercased = occasionTitle.lowercased()
    let isSportyEvent = sportyKeywords.contains { titleLowercased.contains($0) }
    let isFormalEvent = formalKeywords.contains { titleLowercased.contains($0) }
    let isComfyEvent  = comfyKeywords.contains { titleLowercased.contains($0) }
    let isBoldEvent   = boldKeywords.contains { titleLowercased.contains($0) }
    
    let filteredTops = tops.filter { item in
        if isSportyEvent { return item.style == .sporty || item.style == .comfy }
        if isFormalEvent { return item.style == .formal || item.style == .businessCasual }
        if isComfyEvent  { return item.style == .comfy  || item.style == .casual }
        if isBoldEvent   { return item.style == .bold   || item.style == .streetwear || item.style == .grunge }
        return true // default to all if there is no specific type
    }

    let filteredBottoms = bottoms.filter { item in
        if isSportyEvent { return item.style == .sporty || item.style == .comfy }
        if isFormalEvent { return item.style == .formal || item.style == .businessCasual }
        if isComfyEvent  { return item.style == .comfy  || item.style == .casual }
        if isBoldEvent   { return item.style == .bold   || item.style == .streetwear || item.style == .grunge }
        return true
    }

    let filteredFootwear = footwear.filter { item in
        if isSportyEvent { return item.style == .sporty }
        if isFormalEvent { return item.style == .formal || item.style == .businessCasual }
        if isComfyEvent  { return item.style == .comfy  || item.style == .casual }
        if isBoldEvent   { return item.style == .bold   || item.style == .streetwear || item.style == .formal }
        return true
    }
    
    if filteredTops == [] || filteredBottoms == [] || filteredFootwear == [] {
        isValid = false
    }
    
    let finalTops = filteredTops.isEmpty ? tops: filteredTops
    let finalBottoms  = filteredBottoms.isEmpty ? bottoms : filteredBottoms
    let finalFootwear = filteredFootwear.isEmpty ? footwear : filteredFootwear
    
    var count = 50
    while true {
        let randomTop = finalTops.randomElement()!
        let randomBottom = finalBottoms.randomElement()!
        let randomFootwear = finalFootwear.randomElement()!
        
        if count <= 1 {
            return Outfit(top: randomTop, bottom: randomBottom, accessories: [], footwear: randomFootwear, occasionIdentifier: occasionIdentifier, outfitRationale: nil, accessoryRationale: nil, isValid: isValid, id: UUID())
        }
        
        if colorDoesClash(color1: randomTop.color, color2: randomBottom.color) || styleDoesClash(style1: randomTop.style, style2: randomBottom.style) {
            count -= 1
            continue;
        } else {
            return Outfit(top: randomTop, bottom: randomBottom, accessories: [], footwear: randomFootwear, occasionIdentifier: occasionIdentifier, outfitRationale: nil, accessoryRationale: nil, isValid: isValid, id: UUID())
        }
    }
}

