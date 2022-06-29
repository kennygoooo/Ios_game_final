//
//  ContentView.swift
//  Part 1
//
//  
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var userViewModel = UserViewModel()
    
    @State private var isLogin = false
    
    var body: some View {
        if isLogin {
            TabView {
                LeaderBoardView(userViewModel: userViewModel)
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                            .renderingMode(.template)
                    }
                
                ProfileView(userViewModel: userViewModel)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                            .renderingMode(.template)
                    }
                    .onAppear {
                        Auth.auth().addStateDidChangeListener { auth, user in
                            isLogin = user != nil
                        }
                    }
            }
        } else {
            SignInView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                        .renderingMode(.template)
                }
                .onAppear {
                    Auth.auth().addStateDidChangeListener { auth, user in
                        isLogin = user != nil
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
