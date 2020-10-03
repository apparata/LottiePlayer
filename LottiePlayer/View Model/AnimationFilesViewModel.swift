//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation
import Combine

class AnimationFilesViewModel: ObservableObject {
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var animationFileSelection: AnimationFileViewModel?
    
    @Published var animationFiles: [AnimationFileViewModel]
    
    private let animationFilesModel: AnimationFilesModel
    private var cancellables = Set<AnyCancellable>()
    
    init(animationFilesModel: AnimationFilesModel) {
        self.animationFilesModel = animationFilesModel
        self.animationFiles = animationFilesModel.animationFiles.map(AnimationFileViewModel.init)
        
        animationFilesModel.$animationFiles.sink { [weak self] animationFiles in
            self?.objectWillChange.send()
            self?.animationFiles = animationFiles.map(AnimationFileViewModel.init)
        }
        .store(in: &cancellables)
    }    
}
