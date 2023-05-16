//
//  AddNewListView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/26/23.
//

import SwiftUI

struct AddNewListView: View {
    @StateObject var viewModel: AddListViewModelImpl = AddListViewModelImpl()
    @EnvironmentObject var coordindator: Coordinator<RemindersRouter>
    
    var body: some View {
        let showError = Binding<Bool>(
            get: { self.viewModel.error != nil },
            set: { _ in self.viewModel.error = nil }
        )
        VStack {
            HeaderView(
                rightButtonTitle: "Done",
                rightButtonAction: {
                    Task {
                        let result = await viewModel.addList()
                        
                        if result {
                            coordindator.dismiss()
                        }
                    }
                    
                },
                title: "New List", leftButtonTitle: "Close",
                leftButtonAction: {
                    coordindator.dismiss() },
                disabledRightButton: {
                    return !viewModel.isFormValid
                }
            )
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
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewListView()
        }
    }
}
