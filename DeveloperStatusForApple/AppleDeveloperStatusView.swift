//
//  AppleDeveloperStatusView.swift
//  DeveloperStatusForApple
//
//  Created by Thomas Prezioso Jr on 4/22/22.
//

import SwiftUI

struct AppleDeveloperStatusView: View {
    @StateObject var stateModel = AppleDeveloperStatusViewStateModel()
    
    var body: some View {
        List {
            ForEach(stateModel.status.services) { feature in
                VStack {
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(feature.events.isEmpty ? .green : .yellow)
                        Text(feature.serviceName)
                    }
                }
            }
        }.listStyle(.sidebar)
        .frame(width: 300, height: 500, alignment: .center)
        .onAppear {
            Task { @MainActor in
                await stateModel.fetchData()
            }
        }
    }
}

struct AppleDeveloperStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AppleDeveloperStatusView()
    }
}

class AppleDeveloperStatusViewStateModel: ObservableObject {
    @Published var status = StatusComponents(services: [])
    @Published var loading = false
    @Published var error = false
    
    func fetchData() async {
        Task { @MainActor in
            loading = true
            do {
                status = try await getStatus()
                loading = false
                self.error = false
            } catch {
                print(error)
                self.error = true
                loading = false
            }
        }
    }
    
    func getStatus() async throws -> StatusComponents {
        guard let url = URL(string: "https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js") else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        // Used to trim the excess from the beginning and end of JSON data returned
        let newData = data.subdata(in: Range(13...(data.count - 3)))
        if let components = try? JSONDecoder().decode(StatusComponents.self, from: newData) {
            print(">>\(components.services)")
            return components
        }
        return StatusComponents(services: [])
    }
}
