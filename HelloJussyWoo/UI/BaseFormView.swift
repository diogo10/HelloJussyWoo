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
    
    func getValue(type: BaseFormType) -> String {
        switch type {
        case .tax:
            return repoExpenses.getTax().format()
        case .targetInSales:
            return repoExpenses.getTargetSales().format()
         default:
            return ""
        }
    }
    
    func getInputType(type: BaseFormType) -> UIKeyboardType {
        switch type {
        case .tax:
            return .numberPad
        case .targetInSales:
            return .numberPad
         default:
            return .default
        }
    }
    
    func saveCurrency(value: Int) {
         print("value: \(value)")
        
        if value == 1 {
            //EU
            repoExpenses.setCurrency(value: "€")
        } else {
            repoExpenses.setCurrency(value: "R$")
        }
        
    }
    
    func save(type: BaseFormType, value: String) {
         print("value: \(value)")
        let doubleValue = Double(value) ?? 0.0
        switch type {
        case .tax:
            print("in tax")
            repoExpenses.addTax(value: doubleValue)
           
       default:
            print("in target")
             repoExpenses.setTargetSales(value: doubleValue)
        }
    }
}

struct BaseFormView: View {
    @State var value: String = ""
    @ObservedObject var viewModel: BaseFormViewModel
    private var type:BaseFormType = .tax
    @State private var previewIndex = 0
    var previewOptions: [String] = []
    @Environment(\.presentationMode) var presentation
    
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
                            .keyboardType(self.viewModel.getInputType(type: self.type))
                    }
                    
                }
                
                Section {
                    Button(action: {
                        
                        if self.type == .currency {
                            self.viewModel.saveCurrency(value: self.previewIndex)
                        }else {
                           self.viewModel.save(type: self.type, value: self.value)
                        }
                        self.presentation.wrappedValue.dismiss()
                        
                        
                    }) {
                        Text("Save changes")
                    }
                }
            }.onAppear {
                self.value = self.viewModel.getValue(type: self.type)
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

public extension Double {
    func format() -> String {
        return String(format: "%.2f", self)
    }
}
