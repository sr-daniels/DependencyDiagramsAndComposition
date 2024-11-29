//
//  DependencyExamples.swift
//  DependencyDiagramsAndComposition
//
//  Created by Sharonda Daniels on 11/28/24.
//

import UIKit

protocol FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void)
}

// Solid line, empty head: ---|>,  indicates a "inherits from" / "is a" relationship wheras FeedViewController inherits from UIViewController
class FeedViewController: UIViewController {
    // Solid line, filled head: ---▶, indicates a "depends on" / "has a" relationship whereas FeedViewController has a FeedLoader
    var loader: FeedLoader!
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.loadFeed { loadedItems in
            // Update UI
        }
    }
}

// Dashed line, empty head: -  -  -|>,  indicates a "conforms to" / "implements" relationship whereas RemoteFeedLoader conforms to FeedLoader
class RemoteFeedLoader: FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void) {
        // Do something
    }
}

// Dashed line, empty head: -  -  -|>,  indicates a "conforms to" / "implements" relationship whereas LocalFeedLoader conforms to FeedLoader
class LocalFeedLoader: FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void) {
        // Do something
    }
}

struct Reachability {
    static let networkAvailable = false
}

class RemoteWithLocalFallbackFeedService: FeedLoader {
    let remote: RemoteFeedLoader
    let local: LocalFeedLoader
    
    init(remote: RemoteFeedLoader, local: LocalFeedLoader) {
        self.remote = remote
        self.local = local
    }
    func loadFeed(completion: @escaping ([String]) -> Void) {
        let load = Reachability.networkAvailable ? remote.loadFeed : local.loadFeed
        load(completion)
    }
}

// Different types of viewmodel initializations
let vc = FeedViewController(loader: RemoteFeedLoader())
let vc2 = FeedViewController(loader: LocalFeedLoader())
let vc3 = FeedViewController()
vc3.loader = FeedViewController(loader: RemoteWithLocalFallbackFeedService(remote: RemoteFeedLoader(), local: LocalFeedLoader()))
