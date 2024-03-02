//
//  ChatViewModel.swift
//  ChatGPTSwift
//
//  Created by Asim Seferli on 02.03.24.
//

import Foundation

extension ChatView{
    class ViewModel:ObservableObject{
        @Published  var message : [Messages] = []
        @Published var  currentInput :String = ""
        private let openAiService = OpenAiService()
        func sendMessage(){
            let newMessage = Messages(id: UUID(), content: currentInput, role: .user
                                      , createAt: Date())
            message.append(newMessage)
            currentInput = ""
            
            Task {
                let response  = await openAiService.sendMessage(messages: message)
                guard let receivedOpenAiMessage = response.choices?.first?.message else {
                    print("No received Message")
                    return
                }
                let receivedMessage = Messages(id: UUID(), content: receivedOpenAiMessage.content , role: receivedOpenAiMessage.role, createAt: Date())
                await MainActor.run(body: {
                    message.append(receivedMessage)
                })
            }
        }
    }
}

struct Messages : Decodable{
    let id :UUID
    let content : String
    let role : SenderRole
    let createAt: Date
}
