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
    
    var previewOptions = ["Brazil", "Europe"]
    
    func getTitle(type: BaseFormType) -> String {
        switch type {
        case .tax:
            return "Tax"
        case .targetInSales:
            return "Target in Sales"
        case .currency:
            return "Currency"
        }
    }
    
    func saveCurrency(value: Int) {
        
    }
    
    func save(type: BaseFormType, value: String) {
         print("value: \(value)")
        switch type {
        case .tax:
            print("in tax")
        case .targetInSales:
            print("in target")
        case .currency:
            print("in currency")
        }
    }
}

struct BaseFormView: View {
    @State var value: String = ""
    @ObservedObject var viewModel: BaseFormViewModel
    private var type:BaseFormType = .tax
    @State private var previewIndex = 0
    var previewOptions: [String] = []
    
    init(value: BaseFormType) {
        self.type = value
        self.viewModel = BaseFormViewModel()
        self.previewOptions = self.viewModel.previewOptions
    }
    
    var body: some View {
        VStack {
            Form {
                
                Section(header: Text("")) {
                    
                    if self.type == .currency {
                        Picker(selection: $previewIndex, label: Text("")) {
                            ForEach(0 ..< previewOptions.count) {
                                Text(self.previewOptions[$0])
                            }
                        }.pickerStyle(WheelPickerStyle())
                    }else {
                        TextField("Type in your value", text: $value)
                    }
                    
                }
                
                Section {
                    Button(action: {
                        
                        if self.type == .currency {
                            self.viewModel.saveCurrency(value: self.previewIndex)
                        }else {
                           self.viewModel.save(type: self.type, value: self.value)
                        }
                        
                        
                        
                    }) {
                        Text("Save changes")
                    }
                }
            }
            
            
        }.navigationBarTitle(self.viewModel.getTitle(type: self.type))
            .listStyle(GroupedListStyle())
    }
}

struct SimpleFormView_Previews: PreviewProvider {
    static var previews: some View {
        BaseFormView(value: .tax)
    }
}
