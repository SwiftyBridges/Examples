//
//  IceCreamList.swift
//  IceCreamList
//
//  Created by Stephen Kockentiedt on 14.09.21.
//

import SwiftUI
import SwiftyBridgesClient

struct IceCreamList: View {
    @Binding var loginToken: String?
    
    private let iceCreamAPI: IceCreamAPI
    
    @State private var flavors: [IceCreamFlavor] = []
    @State private var errorString: String?
    @State private var addFlavorText = ""
    
    init(loginToken: Binding<String?>) {
        self._loginToken = loginToken
        self.iceCreamAPI = IceCreamAPI(url: serverURL, bearerToken: loginToken.wrappedValue ?? "")
        
        let httpErrors = iceCreamAPI.errors
            .compactMap { $0 as? HTTPError }
        
        Task { [loginToken] in
            if await httpErrors.first(where: { $0.isUnauthorizedError }) != nil {
                loginToken.wrappedValue = nil
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(flavors) { flavor in
                    Text(flavor.name)
                }
                .onDelete { indexSet in
                    let flavorsToDelete = indexSet.map { flavors[$0] }
                    Task {
                        for flavor in flavorsToDelete {
                            try await iceCreamAPI.delete(flavorWithID: flavor.id)
                        }
                        await loadFlavors()
                    }
                }
            }
            .listStyle(.plain)
            .overlay {
                if flavors.isEmpty {
                    Group {
                        if let errorString = errorString {
                            Text(errorString)
                                .foregroundColor(.red)
                        } else {
                            Text("Nothing to see")
                        }
                    }
                    .allowsHitTesting(false) // Let taps through to List
                }
            }
            HStack {
                TextField("Add flavor", text: $addFlavorText)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    let name = addFlavorText
                    addFlavorText = ""
                    Task {
                        try await iceCreamAPI.add(flavorWithName: name)
                        await loadFlavors()
                    }
                }
            }
            .padding()
        }
        .task { await loadFlavors() }
        .navigationTitle("Flavors")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Reload") {
                    Task {
                        await loadFlavors()
                    }
                }
            }
        }
    }
    
    func loadFlavors() async {
        do {
            self.flavors = try await iceCreamAPI.getAllFlavors()
        } catch {
            errorString = error.localizedDescription
        }
    }
}

struct IceCreamList_Previews: PreviewProvider {
    static var previews: some View {
        IceCreamList(loginToken: .constant(""))
    }
}
