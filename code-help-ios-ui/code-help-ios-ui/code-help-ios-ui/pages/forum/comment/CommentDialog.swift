//
//  CommentDialog.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 3.9.23.
//

import SwiftUI

enum CommentDialogType: String {
    case new = "Comment"
    case edit = "Edit"
    case reply = "Reply"
}

struct CommentModalDialog: View {
    typealias DoneAction = (String, PostComment?, CommentDialogType) -> Void
    
    @Binding var show: Bool
    @Binding var text: String
    @Binding var type: CommentDialogType
    
    let comment: PostComment?
    
    var onDone: DoneAction? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(type.rawValue)
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
                
                TextEditor(text: $text)
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
                    
                    Button(type.rawValue, role: .cancel) {
                        show = false
                        onDone?(text, comment, type)
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


struct CommentDialog_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            NavigationStack {
                ForumView()                
            }
        }
    }
}
