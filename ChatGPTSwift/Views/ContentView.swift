//
//  ContentView.swift
//  ChatGPTSwift
//
//  Created by Asim Seferli on 02.03.24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ChatView.ViewModel()
    var body: some View {
        VStack {
            ScrollView{
                ForEach(viewModel.message.filter({ $0.role != .system }) , id: \.id){
                    message  in messageView(message: message)
                }
            }
            HStack{
                TextField("Text", text: $viewModel.currentInput)
                Button {
                    viewModel.sendMessage()
                } label: {
                    Image(systemName: "paperplane")
                        .background(.black)
                        .padding(.horizontal , 10 )
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }
    func messageView(message:Messages) -> some View{
        HStack{
            if message.role == .user {Spacer()}
            Text(message.content)
            if message.role  == .assistant{Spacer()}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
