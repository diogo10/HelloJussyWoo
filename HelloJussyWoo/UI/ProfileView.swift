import SwiftUI
import Data

struct ProfileView: View {
    
    var body: some View {
        VStack {
            ProfileHeader(viewModel: ProfileViewModel())
        }
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
    let gradient = Gradient(colors: [.blue, .purple])
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                
                HStack() {
                    Image("avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .clipped()
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.top, 44)
                    
                    VStack(alignment: .leading) {
                        Text("Hello Jussy").font(.system(size: 18)).bold().foregroundColor(.white)
                            .padding(.top, 50)
                        
                        Text("diogjp10@gmail.com").font(.system(size: 16)).foregroundColor(.white)
                            .padding(.top, 2)
                    }.padding(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                    
                    
                }.padding(EdgeInsets.init(top: 0, leading: 15, bottom: 0, trailing: 0))
                
                Spacer()
            }
            
            
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
                
            }.padding(.top, 20)
            
            
        }
        .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
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



struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProfileView()
    }
}
