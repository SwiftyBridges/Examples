//
//  ContentView.swift
//  IceCreamCustomer
//
//  Created by Stephen Kockentiedt on 14.09.21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("loginToken") private var loginToken: String?
    
    var body: some View {
        NavigationView {
            if loginToken != nil {
                IceCreamList(loginToken: $loginToken)
            } else {
                LoginView(loginToken: $loginToken)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
