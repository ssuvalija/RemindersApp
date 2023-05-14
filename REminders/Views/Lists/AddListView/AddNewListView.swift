//
//  AddNewListView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/26/23.
//

import SwiftUI

struct AddNewListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddListViewModelImpl
    
    var body: some View {
        let showError = Binding<Bool>(
            get: { self.viewModel.error != nil },
            set: { _ in self.viewModel.error = nil }
        )
        VStack {
            VStack {
                Image(systemName: "line.3.horizontal.circle.fill")
                    .foregroundColor(viewModel.color)
                    .font(.system(size: 100))
                
                TextField("List Name", text: $viewModel.name)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                
            }
            .padding(30)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            ColorPickerView(selectedColor: $viewModel.color)
            Spacer()
            
        }
        .alert(isPresented: showError, content: {
            Alert(title: Text("Error while creating new list"))
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text("New List")
                    .font(.headline)
            })
            
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button("Close") {
                    dismiss()
                }
            })
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button("Done") {
                    Task {
                        let result = await viewModel.addList()
                        
                        if result {
                            dismiss()
                        }
                    }
                }.disabled(!viewModel.isFormValid)
            })

        }
    
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewListView(viewModel: AddListViewModelImpl())
        }
    }
}
