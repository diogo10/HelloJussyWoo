import SwiftUI

struct TaxFormView: View {
    
      var body: some View {
          VStack {
            BaseFormView(value: .tax)
          }
      }
}

struct TargetSalesFormView: View {
    
      var body: some View {
          VStack {
            BaseFormView(value: .targetInSales)
          }
      }
}

struct CountryFormView: View {
    
      var body: some View {
          VStack {
            BaseFormView(value: .currency)
          }
      }
}


//MARK -


 enum BaseFormType {
     case tax
     case targetInSales
     case currency
 }

class BaseFormViewModel : FixedExpensesViewModel {
    
    func save(type: BaseFormType, value: String) {
        switch type {
        case .tax:
            print("save tax")
        case .targetInSales:
            print("save target")
        case .currency:
            print("save currency")
        }
    }
}

struct BaseFormView: View {
    @State var value: String = ""
    @ObservedObject var viewModel: BaseFormViewModel
    private var type:BaseFormType = .tax

    init(value: BaseFormType) {
        self.type = value
        self.viewModel = BaseFormViewModel()
    }
    
    var body: some View {
        NavigationView {
            Form {
                
               Section(header: Text("PROFILE")) {
                    TextField("Username", text: $value)
                }
                
                Section {
                    Button(action: {
                       print("save")
                        self.viewModel.save(type: self.type, value: self.value)
                    }) {
                        Text("Save changes")
                    }
                }
            }
        }
    }
}

struct SimpleFormView_Previews: PreviewProvider {
    static var previews: some View {
        BaseFormView(value: .tax)
    }
}
