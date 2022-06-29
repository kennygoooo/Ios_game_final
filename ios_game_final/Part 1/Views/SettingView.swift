//
//  SettingView.swift
//  Part 1
//
//  
//

import SwiftUI
import FirebaseAuth

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var userViewModel: UserViewModel
    
    @StateObject var storageViewModel = StorageViewModel()
    
    @State private var uiImage: UIImage?
    @State private var name = ""
    @State private var head: Double = 0
    @State private var face = "1"
    
    var body: some View {
        if Auth.auth().currentUser != nil {
            List {
                HStack {
                    Spacer()
                    VStack {
                        AvatarView(head: head, face: face)
                        Button {
                            head = [0, 1].randomElement()!
                            face = ["0", "1", "2"].randomElement()!
                        } label: {
                            Text("Random")
                                .font(.title2.bold())
                                .padding(8)
                                .foregroundColor(.white)
                                .frame(width: 300)
                                .background {
                                    Color.orange
                                }
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                }
                .padding()
                HStack {
                    Text("Name")
                        .font(.title3.bold())
                        .padding(.trailing, 60)
                    Spacer()
                    TextField("name", text: $name, prompt: Text(userViewModel.user.name))
                        .padding(10)
                        .border(.gray, width: 1)
                }
                HStack {
                    Text("Email")
                        .font(.title3.bold())
                    Spacer()
                    Text(userViewModel.user.email)
                }
                HStack {
                    Text("Money")
                        .font(.title3.bold())
                    Spacer()
                    Text("\(userViewModel.user.money)")
                }
                HStack {
                    Text("Joined")
                        .font(.title3.bold())
                    Spacer()
                    Text("\(userViewModel.user.joinedDate.formatted(date: .abbreviated, time: .omitted))")
                }
                HStack {
                    Text("Head")
                        .font(.title3.bold())
                        .padding(.trailing, 60)
                    Spacer()
                    Slider(value: $head, in: 0...2, step: 1) {
                        Text("head")
                    }
                }
                HStack {
                    Text("Face")
                        .font(.title3.bold())
                        .padding(.trailing, 60)
                    Spacer()
                    Picker("Face", selection: $face) {
                        ForEach(["0", "1", "2"], id: \.self) { item in
                            Text(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationBarTitle(Text("Setting"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        uiImage = AvatarView(head: head, face: face).snapshot()
                        storageViewModel.uploadPhoto(id: userViewModel.user.id ?? "demo", image: uiImage!) { result in
                            switch result {
                            case .success(let url):
                                userViewModel.updateUser(name: name, avatarUrl: url.absoluteString)
                            case .failure(let error):
                                print(error)
                            }
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .onAppear {
                name = userViewModel.user.name
            }
        }
    }
}

struct AvatarView: View {
    
    let head: Double
    let face: String
    
    var body: some View {
        ZStack {
            Image("head\(Int(head))")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Image("face\(face)")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .offset(x: 20, y: 40)
        }
        .background {
            Color.brown
        }
        .cornerRadius(10)
    }
}
