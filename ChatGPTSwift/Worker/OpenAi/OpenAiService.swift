import Foundation
import Alamofire

class OpenAiService {
    private let endpointURL = "https://api.openai.com/v1/chat/completions"

    func sendMessage(messages: [Messages]) async  -> OpenAiChatResponse {
        let openAiMessages = messages.map { ChatMessage(role: $0.role, content: $0.content) }
        let body = ChatBody(model: "gpt-3.5-turbo", messages: openAiMessages)

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openKey)",
            "Content-Type": "application/json"
        ]
    
        return try! await AF.request(endpointURL, method: .post, parameters: body, encoder: .json, headers:  headers).serializingDecodable(OpenAiChatResponse.self).value
        
      
    }
}

struct ChatBody: Encodable {
    let model: String
    let messages: [ChatMessage]
}

struct ChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAiChatResponse: Decodable {
    let choices: [OpenAiChatChoice]?
}

struct OpenAiChatChoice: Decodable {
    let message: ChatMessage
}
