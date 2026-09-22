import Core

extension GameModel {
    static let sample = GameModel(
        id: 3498,
        name: "Grand Theft Auto V",
        backgroundImage: nil,
        released: "2013-09-17",
        rating: 4.5
    )
}

extension GameDetailModel {
    static let sample = GameDetailModel(
        id: 3498,
        name: "Grand Theft Auto V",
        backgroundImage: nil,
        released: "2013-09-17",
        rating: 4.5,
        descriptionText: "Open world action game.",
        genres: ["Action"],
        platforms: ["PC"]
    )
}
