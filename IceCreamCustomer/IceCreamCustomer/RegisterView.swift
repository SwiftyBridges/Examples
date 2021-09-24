//
//  RegisterView.swift
//  RegisterView
//
//  Created by Stephen Kockentiedt on 14.09.21.
//

import SwiftUI
import SwiftyBridgesClient

private let loginAPI = LoginAPI(url: serverURL)

struct RegisterView: View {
    @Binding var loginToken: String?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    @State private var password = ""
    @State private var repeatedPassword = ""
    @State private var errorString: String?
    @State private var isBusy = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username, prompt: Text("Username"))
                TextField("Password", text: $password, prompt: Text("Password"))
                TextField("Repeated Password", text: $repeatedPassword, prompt: Text("Repeated Password"))
                if let errorString = errorString {
                    Text(errorString)
                        .foregroundColor(.red)
                }
                Button("Register") {
                    isBusy = true
                    Task {
                        do {
                            let loginToken = try await loginAPI.registerUser(username: username, password: password, confirmPassword: repeatedPassword)
                            self.loginToken = loginToken
                            self.errorString = nil
                        } catch {
                            errorString = error.localizedDescription
                        }
                        isBusy = false
                    }
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .disabled(isBusy)
            .navigationBarTitle(Text("Register"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isBusy)
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(loginToken: .constant(nil))
    }
}
