//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import SwiftUI
import SwiftUIToolbox

struct MainSplitView: View {
        
    @ObservedObject private var searchFilter = SearchFilter<AnimationFileViewModel>()
        
    @EnvironmentObject private var animationFilesViewModel: AnimationFilesViewModel
        
    var body: some View {
        NavigationView {
            
            MainSidebarView {
                
                SidebarSearchField(text: self.$searchFilter.searchText)
                    .padding(EdgeInsets(top: 16, leading: 10, bottom: 0, trailing: 10))
                
                List(selection: $animationFilesViewModel.animationFileSelection) {
                    Section(header: Text("Animations")) {
                        ForEach(searchFilter.apply(to: animationFilesViewModel.animationFiles)) { animationFile in
                            AnimationFileRow(animationFile: animationFile) {
                                MainContentView {
                                    LottieUI(animation: animationFile.animation)
                                        .environmentObject(LottiePlayer())
                                }
                            }.tag(animationFile)
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            }
            
            MainContentView {
                Text("Drop Lottie animations here.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
