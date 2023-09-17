//
//  PostModalDialog.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 3.9.23.
//

import SwiftUI

enum PostDialogType: String {
    case new = "Post"
    case edit = "Edit"
}

struct PostDialogData {
    let title: String
    let content: String
}

struct PostModalDialog: View {
    typealias DoneAction = (String, PostDialogData) -> Void
    
    @Binding var show: Bool
    
    @State var title: String = ""
    @State var content: String = ""
    
    var dialogType: PostDialogType = .new
    let communityName: String
    
    var onDone: DoneAction? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(dialogType.rawValue)
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
                
                TextField("Title", text: $title)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(.primaryBackground)
                    .padding()
                
                TextEditor(text: $content)
                    .scrollContentBackground(.hidden)
                    .textFieldStyle(.roundedBorder)
                    .background(.primaryBackground)
                    .frame(minHeight: 10, maxHeight: 100)
                    .padding()
                
                HStack {
                    Spacer()
                    
                    Button("Cancel") {
                        show = false
                    }
                    
                    Spacer()
                    
                    Button("Post", role: .cancel) {
                        show = false
                        title = ""
                        content = ""
                        onDone?(communityName, .init(title: title, content: content))
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(.secondaryBackground)
            .cornerRadius(10)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(show ? 1 : 0)
        .animation(.default, value: show)
    }
}

struct PostModalDialog_Previews: PreviewProvider {
    static var previews: some View {
        @State var show = true
        
        PostModalDialog(show: $show, communityName: "initial")
    }
}
