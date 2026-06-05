//
//  ShopItem.swift
//  156StudyGold
//

import Foundation

struct ShopItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let details: String
    let icon: String
    let price: Int
}

extension ShopItem {
    static let defaults: [ShopItem] = [
        ShopItem(
            id: UUID(),
            name: "Coffee Break",
            details: "Treat yourself to a 15 minute coffee break",
            icon: "cup.and.saucer.fill",
            price: 100
        ),
        ShopItem(
            id: UUID(),
            name: "Movie Night",
            details: "Watch a movie of your choice",
            icon: "film.fill",
            price: 300
        ),
        ShopItem(
            id: UUID(),
            name: "Free Day",
            details: "A full day off without studying",
            icon: "sun.max.fill",
            price: 800
        ),
        ShopItem(
            id: UUID(),
            name: "New Book",
            details: "Buy yourself a new book",
            icon: "books.vertical.fill",
            price: 1200
        ),
        ShopItem(
            id: UUID(),
            name: "Weekend Trip",
            details: "Plan a short weekend trip",
            icon: "airplane",
            price: 3000
        ),
        ShopItem(
            id: UUID(),
            name: "Premium Headphones",
            details: "Reward yourself with great sound",
            icon: "headphones",
            price: 5000
        )
    ]
}
