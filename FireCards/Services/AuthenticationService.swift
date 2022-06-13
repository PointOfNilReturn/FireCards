//
//  AuthenticationService.swift
//  FireCards
//
//  Created by Chris Brown on 6/13/22.
//

import Firebase

class AuthenticationService: ObservableObject {
    
    @Published var user: User?
    
    private var authenticationStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        addListeners()
    }
    
    func signIn() async {
        do {
            let authDataResult = try await Auth.auth().signInAnonymously()
            user = authDataResult.user
        } catch {
            print("error")
        }
    }
    
    static func signIn() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
    }
}

extension AuthenticationService {
    
    private func addListeners() {
        
        if let handle = authenticationStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authenticationStateHandler = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
    
}
