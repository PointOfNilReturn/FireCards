//
//  CardRepository.swift
//  FireCards
//
//  Created by Chris Brown on 6/13/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class CardRepository: ObservableObject {
    
    @Published var cards: [Card] = []
    
    var userID = ""
    
    private let path = "cards"
    private let store = Firestore.firestore()
    private let authenticationService = AuthenticationService()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userID, on: self)
            .store(in: &cancellables)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.get()
            }
            .store(in: &cancellables)
    }
    
    func add(_ card: Card) {
        do {
            var newCard = card
            newCard.userID = userID
            _ = try store.collection(path).addDocument(from: newCard)
        } catch {
            fatalError("Unable to add card: \(error.localizedDescription)")
        }
    }
    
    func get() {
        store.collection(path)
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            
            self.cards = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Card.self)
            } ?? []
        }
    }
    
    func update(_ card: Card) {
        guard let id = card.id else { return }
        
        do {
            try store.collection(path).document(id).setData(from: card)
        } catch {
            fatalError("Unable to update card: \(error.localizedDescription)")
        }
    }
    
    func remove(_ card: Card) {
        guard let id = card.id else { return }
        
        store.collection(path).document(id).delete { error in
            if let error = error {
                print("Unable to remove card: \(error.localizedDescription)")
            }
        }
    }
}
