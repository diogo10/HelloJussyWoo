import SwiftUI
import Data

struct TaxViewModel : Identifiable {
    var id: UUID
    var title: String
    var anyView: AnyView
}

struct TaxesView: View {
    @ObservedObject var viewModel: TaxesViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                
                ForEach(viewModel.values) { section in
                    section.anyView
                }.listRowBackground((Color.black))
                
            }.onAppear {
                self.viewModel.load()
            }
        }
    }
}


class TaxesViewModel : FixedExpensesViewModel {
    
    @Published var values: [TaxViewModel] = []
    
    
    
    
    override func load() {
        super.load()
        values.removeAll()
        
        values.append(TaxViewModel(id: UUID(), title: "Currency", anyView: AnyView(
            NavigationLink(destination: CountryFormView()) {
                CountryItem(viewModel: self).foregroundColor(Color.white)
            }.background(Color.black)

        )))
                
        values.append(TaxViewModel(id: UUID(), title: "Fixed expenses", anyView: AnyView(
            NavigationLink(destination: FixedExpensesView(viewModel: FixedExpensesViewModel())) {
                FixedExpenseItem(viewModel: self).foregroundColor(.white)
            }
        )))
        
        values.append(TaxViewModel(id: UUID(), title: "Target in Sales", anyView: AnyView(
            NavigationLink(destination: TargetSalesFormView()) {
                TargetInputItem(viewModel: self).foregroundColor(.white)
            }
        )))
        
       
        values.append(TaxViewModel(id: UUID(), title: "Taxes", anyView: AnyView(
            NavigationLink(destination: TaxFormView()) {
                TaxInputItem(viewModel: self).foregroundColor(.white)
            }
        )))
        
        values.append(TaxViewModel(id: UUID(), title: "Total", anyView: AnyView(
            TotalItem(viewModel: self).foregroundColor(.white)
        )))
        
    }
    
    func getTax() -> String {
        return repoExpenses.getTax().format() + " %"
    }
    
    func getImpact() -> String {
        return "\(repoExpenses.impactInEachProduct()) %"
    }
    
    func getCurrencyFlagName() -> String {
        if repoExpenses.getCurrency() == "R$" {
            return "flag_brazil"
        }else {
            return "flag_eu"
        }
    }
    
    func getTargetSales() -> String {
        return String(format: "\(repoExpenses.getCurrency()) %.2f", repoExpenses.getTargetSales())
    }
    
}

private struct FixedExpenseItem: View {
    @ObservedObject var viewModel: TaxesViewModel
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Fixed expenses").font(.caption)
                    Text(viewModel.total()).bold().font(.subheadline)
                }
                
                Spacer()
            }.padding()
        }
    }
}

private struct CountryItem: View {
    @ObservedObject var viewModel: TaxesViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(viewModel.getCurrencyFlagName())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    .clipped()
                
                Text("Currency").bold().font(.subheadline)
                Spacer()
            }.padding().background(Color.black)
        }
    }
}

private struct TargetInputItem: View {
    @ObservedObject var viewModel: TaxesViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Target in sales").font(.caption)
                    Text(viewModel.getTargetSales()).bold().font(.subheadline)
                }
                
                Spacer()
            }.padding()
        }
    }
}

private struct TaxInputItem: View {
    @ObservedObject var viewModel: TaxesViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Tax").font(.caption)
                    Text(viewModel.getTax()).bold().font(.subheadline)
                    Text("Just if you already pay it on sales").font(.footnote).foregroundColor(Color.gray)
                }
                
                Spacer()
            }.padding()
        }
    }
}

private struct TotalItem: View {
    
    @ObservedObject var viewModel: TaxesViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Impact in each product").font(.caption)
                    Text(viewModel.getImpact()).bold().font(.subheadline)
                    Text("Calculated automaticaly based on the above configurations").font(.footnote).foregroundColor(Color.gray)
                }
                
                Spacer()
            }.padding()
        }
    }
}
