//
//  ConcurrancyViewController.swift
//  Concurrency
//
//  Created by Venkatesh Nyamagoudar on 8/23/23.
//

import UIKit

class ConcurrancyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Task {
            print("This is first.")
            let sum = (1...100000).reduce(0, +)
            print("This is second: 1 + 2 + 3 ... 100 = \(sum)")
            try await performTask()
        }
        print("This is last.")
        Task {
            do {
                let domains = try await fetchDomains()
                for (index, domain) in domains.enumerated() {
                    let attr = domain.attributes
                    print("\(index + 1)) \(attr.name): \(attr.description) - \(attr.level)")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func performTask() async throws {
        print("Starting the task in a function.")
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }catch let error {
            print(error)
        }
        print("Finishing the task in a function.")
    }
    
    func fetchDomains() async throws -> [Domain] {
        let url = URL(string: "https://api.raywenderlich.com/api/domains")!
        let (data, response) = try await URLSession.shared.data(from: url)
        print(data, response)
        return try JSONDecoder().decode(Domains.self, from: data).data
    }

}
