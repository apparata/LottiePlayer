//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation
import Combine
import Lottie

class AnimationFilesModel {
    
    @Published var animationFiles: [AnimationFile]
    
    private var loadSubscription: AnyCancellable?
    
    init(animationFiles: [AnimationFile]) {
        self.animationFiles = animationFiles
    }
    
    func loadFromItemProviders(_ itemProviders: [NSItemProvider]) {
        loadSubscription = Publishers.Sequence(sequence: itemProviders)
            .flatMap { itemProvider in
                Self.loadItem(for: itemProvider)
            }
            .collect()
            .map { (urls: [URL?]) -> [AnimationFile] in
                urls
                    .compactMap { $0 }
                    .compactMap { url in
                        if let animation = Lottie.Animation.filepath(
                            url.path,
                            animationCache: LRUAnimationCache.sharedCache) {
                            return (url, animation)
                        } else {
                            return nil
                        }
                    }
                    .map { (animation: (URL, Lottie.Animation)) -> AnimationFile in
                        AnimationFile(
                            name: animation.0.deletingPathExtension().lastPathComponent,
                            animation: animation.1)
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink { animationFiles in
                self.animationFiles = animationFiles
            }
    }
        
    private static func loadItem(for itemProvider: NSItemProvider) -> AnyPublisher<URL?, Never> {
        
        return Future { promise in
            
            itemProvider.loadItem(forTypeIdentifier: (kUTTypeFileURL as String), options: nil) { item, error in
                
                guard let data = item as? Data else {
                    promise(.success(nil))
                    return
                }
                
                guard let url = URL(dataRepresentation: data, relativeTo: nil) else {
                    promise(.success(nil))
                    return
                }
                
                promise(.success(url))
            }
            
        }.eraseToAnyPublisher()
        
    }

}
