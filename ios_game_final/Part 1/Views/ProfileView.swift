//
//  ProfileView.swift
//  Part 1
//
//  
//

import SwiftUI
import FirebaseAuth
import GoogleMobileAds

struct ProfileView: View {
    
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var ad: GADRewardedAd?
    
    var body: some View {
        if let user = Auth.auth().currentUser {
            NavigationView {
                List {
                    HStack {
                        Spacer()
                        AsyncImage(url: URL(string: userViewModel.user.avatarUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .padding()
                        
                        Spacer()
                    }
                    HStack {
                        Text("Name")
                            .font(.title3.bold())
                        Spacer()
                        Text(userViewModel.user.name)
                    }
                    .padding(.vertical)
                    HStack {
                        Text("Email")
                            .font(.title3.bold())
                        Spacer()
                        Text(userViewModel.user.email)
                    }
                    .padding(.vertical)
                    HStack {
                        Text("Money")
                            .font(.title3.bold())
                        Spacer()
                        Text("\(userViewModel.user.money)")
                    }
                    .padding(.vertical)
                    HStack {
                        Text("Joined")
                            .font(.title3.bold())
                        Spacer()
                        Text("\(userViewModel.user.joinedDate.formatted(date: .abbreviated, time: .omitted))")
                    }
                    .padding(.vertical)
                    Button {
                        showAd()
                    } label: {
                        Text("Get Reward")
                            .font(.title2.bold())
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.orange
                            }
                            .cornerRadius(10)
                    }
                    .padding(.vertical)
                }
                .navigationBarTitle(Text("Profile"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            do {
                                try Auth.auth().signOut()
                            } catch { }
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right.fill").rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                
                                Text("Log out")
                                    .font(.title2.bold())
                            }
                        }
                    }
                    ToolbarItem {
                        NavigationLink {
                            SettingView(userViewModel: userViewModel)
                        } label: {
                            Text(Image(systemName: "gearshape.fill"))
                                .font(.title3.bold())
                        }
                    }
                }
            }
            .onAppear {
                userViewModel.listenToUserDataChange(id: user.uid)
                loadAd()
            }
        }
    }
    
    func loadAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) { ad, error in
            if error != nil {
                loadAd()
            }
            self.ad = ad
        }
    }
    
    func showAd() {
        if let ad = ad, let controller = UIViewController.getLastPresentedViewController() {
            ad.present(fromRootViewController: controller) {
                userViewModel.getReward()
            }
        } else {
            print("Ad wasn't ready")
        }
    }
}
