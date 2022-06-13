//
//  CardViewModel.swift
//  FireCards
//
//  Created by Chris Brown on 6/13/22.
//

import Combine

class CardViewModel: ObservableObject, Identifiable {
    
    @Published var card: Card
    
    private let cardRepository = CardRepository()
    private var cancellables: Set<AnyCancellable> = []
    
    var id = ""
    
    init(card: Card) {
        self.card = card
        
        $card
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func update(card: Card) {
        cardRepository.update(card)
    }
    
    func remove() {
        cardRepository.remove(card)
    }
    
}
