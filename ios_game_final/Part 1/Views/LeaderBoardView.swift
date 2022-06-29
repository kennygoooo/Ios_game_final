//
//  LeaderBoardView.swift
//  Part 1
//
//  
//

import SwiftUI

struct LeaderBoardView: View {
    
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Leader Board")
                .font(.title.bold())
            
            List {
                Section(header: Text("Order by money")) {
                    ForEach(userViewModel.usersForLeaderBoard) { user in
                        HStack {
                            Text(user.name)
                            
                            Spacer()
                            
                            Text("$ \(user.money)")
                        }
                    }
                }
                .navigationTitle("Leader")
                .onAppear {
                    userViewModel.fetchUserForLeaderBoard()
                }
            }
        }
    }
}
