//
//  CardListViewModel.swift
//  FireCards
//
//  Created by Chris Brown on 6/13/22.
//

import Combine

class CardListViewModel: ObservableObject {
    
    @Published var cardRepository = CardRepository()
    @Published var cardViewModels: [CardViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        cardRepository.$cards.map { cards in
            cards.map(CardViewModel.init)
        }
        .assign(to: \.cardViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func add(_ card: Card) {
        cardRepository.add(card)
    }
}
