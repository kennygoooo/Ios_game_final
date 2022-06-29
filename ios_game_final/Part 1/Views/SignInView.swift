//
//  SignInView.swift
//  Part 1
//
//  
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SignInView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Welcome")
                .font(.largeTitle.bold())
            
            Spacer()
            
            TextField("Email", text: $email, prompt: Text("Email"))
                .padding()
                .foregroundColor(.black)
                .background(.quaternary)
                .cornerRadius(5)
            
            SecureField("Password", text: $password, prompt: Text("Password"))
                .padding()
                .foregroundColor(.black)
                .background(.quaternary)
                .cornerRadius(5)
            
            HStack(spacing: 15) {
                Button {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        guard let user = result?.user, error == nil else { return }
                        let db = Firestore.firestore()
                        let player = User(name: "not set", email: email, money: 2000, joinedDate: Date.now)
                        do {
                            try db.collection("users").document(user.uid).setData(from: player)
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .padding()
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .frame(width: 140)
                        .background {
                            Color.green
                        }
                        .cornerRadius(8)
                }
                
                Button {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        guard error == nil else { return }
                    }
                } label: {
                    Text("Log In")
                        .padding()
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .frame(width: 140)
                        .background {
                            Color.green
                        }
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
