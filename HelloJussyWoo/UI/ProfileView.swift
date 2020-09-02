import SwiftUI
import Data

struct ProfileView: View {
    
    var body: some View {
       TabBgIconView(content: {
            VStack(alignment: .leading) {
                ProfileHeader(viewModel: ProfileViewModel())
            }
       },title: "Settings", imageIcon: "person")
    }
}


class ProfileViewModel : FixedExpensesViewModel {
    
    func getTax() -> String {
        return String(format: "\(repoExpenses.getCurrency()) %.2f", repoExpenses.getTax())
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


struct ProfileHeader: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            List {
                
                NavigationLink(destination: CountryFormView()) {
                    CountryItem(viewModel: self.viewModel)
                }
                
                NavigationLink(destination: FixedExpensesView(viewModel: FixedExpensesViewModel())) {
                    FixedExpenseItem(viewModel: self.viewModel)
                }
                
                NavigationLink(destination: TargetSalesFormView()) {
                    TargetInputItem(viewModel: self.viewModel)
                }
                
                NavigationLink(destination: TaxFormView()) {
                    TaxInputItem(viewModel: viewModel)
                }
                
                TotalItem(viewModel: self.viewModel)
                
            }
            
            
        }.onAppear {
            self.viewModel.load()
        }
    }
}

private struct FixedExpenseItem: View {
    @ObservedObject var viewModel: ProfileViewModel
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
    @ObservedObject var viewModel: ProfileViewModel
    
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
            }.padding()
        }
    }
}

private struct TargetInputItem: View {
    @ObservedObject var viewModel: ProfileViewModel
    
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
    @ObservedObject var viewModel: ProfileViewModel
    
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
    
    @ObservedObject var viewModel: ProfileViewModel
    
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
