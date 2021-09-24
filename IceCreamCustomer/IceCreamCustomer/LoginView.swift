//
//  LoginView.swift
//  LoginView
//
//  Created by Stephen Kockentiedt on 14.09.21.
//

import SwiftUI
import SwiftyBridgesClient

private let loginAPI = LoginAPI(url: serverURL)

struct LoginView: View {
    @Binding var loginToken: String?
    
    @State private var username = ""
    @State private var password = ""
    @State private var errorString: String?
    @State private var isBusy = false
    @State private var showsRegisterView = false
    
    var body: some View {
        VStack {
            TextField("Username", text: $username, prompt: Text("Username"))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            SecureField("Password", text: $password, prompt: Text("Password"))
            if let errorString = errorString {
                Text(errorString)
                    .foregroundColor(.red)
            }
            Button("Log In") {
                isBusy = true
                Task {
                    do {
                        let loginToken = try await loginAPI.logIn(username: username, password: password)
                        self.loginToken = loginToken
                        errorString = nil
                    } catch {
                        print(error)
                        errorString = error.localizedDescription
                    }
                    isBusy = false
                }
            }
            Button("Register") {
                showsRegisterView = true
            }
            .fullScreenCover(isPresented: $showsRegisterView) {
                RegisterView(loginToken: $loginToken)
            }
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .autocapitalization(.none)
        .disabled(isBusy)
        .navigationTitle(Text("Login"))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginToken: .constant(nil))
    }
}

// Should be generated:

//struct LoginAPI {
//    private let baseRequest: URLRequest
//    private let client: SwiftyBridgesClient
//
//    init(url: URL, client: SwiftyBridgesClient = .shared) {
//        self.init(baseRequest: URLRequest(url: url), client: client)
//    }
//
//    init(baseRequest: URLRequest, client: SwiftyBridgesClient = .shared) {
//        self.baseRequest = baseRequest
//        self.client = client
//    }
//
//    func logIn(
//        using data: LoginData,
//        _ fakeString: String
//    ) async throws -> Login {
//        let call =
//        LoginAPI_logIn_using_LoginData__String_Call(
//            parameter0: data,
//            parameter1: fakeString
//        )
//        return try await client.perform(call, baseRequest: baseRequest)
//    }
//}
//
//extension LoginAPI {
//    private struct LoginAPI_logIn_using_LoginData__String_Call: APIMethodCall {
//        typealias ReturnType = Login
//
//        static let typeName = "LoginAPI"
//        static let methodID = "logIn(using: LoginData, _: String) -> Login"
//
//        var parameter0: LoginData
//        var parameter1: String
//
//        enum CodingKeys: String, CodingKey {
//            case parameter0 = "0_using"
//            case parameter1 = "1"
//        }
//    }
//}
