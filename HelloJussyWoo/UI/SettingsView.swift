import SwiftUI

struct SettingsView: View {

    var body: some View {

        List {
            Section(header: ListHeader()) {
                
                NavigationLink(destination: ProfileView()) {
                    Item(value: 0)
                }

                NavigationLink(destination: FixedExpensesView(viewModel: FixedExpensesViewModel())) {
                    Item(value: 1)
                }


            }
        }.listStyle(GroupedListStyle())


    }
}

private struct Item: View {
    private let options = ["Profile", "Fixed expenses"]
    private var value = 0

    init(value: Int) {
        self.value = value
    }

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(options[value]).bold().font(.subheadline)
                }
                Spacer()
            }.padding()
        }
    }


}

private struct ListHeader: View {
    var body: some View {
        VStack{
            Text("")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
