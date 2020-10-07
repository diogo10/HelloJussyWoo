import SwiftUI
import Data

struct DatasheetsView: View {
    @ObservedObject var viewModel = DatasheetsListViewModel()
    @State private var isShowing = false
    
    var body: some View {
        
                List {
                    ForEach(viewModel.list) { section in

                        NavigationLink(destination: ManageDatasheetView(data: section) ) {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(section.name)").bold().font(.subheadline).foregroundColor(.white)
                                        Text("\(section.produtcs.count) products").foregroundColor(.white).font(.caption)
                                    }

                                    Spacer()
                                    Text("\(self.viewModel.getCurrency()) \(String(format: "%.2f", section.price))").bold().font(.subheadline).foregroundColor(.white)

                                }.padding()
                            }
                        }


                    }.onDelete(perform: self.deleteItem).listRowBackground(Color.black)


                }.onAppear {
                    self.viewModel.load()
                }
        
        
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.viewModel.delete(index: indexSet.map({ it in
            it
        }))
    }
    
}

struct GridCell: View {
    var model: Datasheet
    
    var body: some View {
        NavigationLink(destination: ManageDatasheetView(data: model) ) {
            VStack() {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(model.name)").bold().font(.subheadline).foregroundColor(.black)
                        Text("\(model.produtcs.count) products").foregroundColor(.black).font(.caption)
                    }
                    
                    Spacer()
                    Text("\(String(format: "%.2f", model.price))").bold().font(.subheadline).foregroundColor(.black)
                    
                }.padding()
            }.background(Color.pink)
        }
    }
}


class DatasheetsListViewModel : BaseViewModel,ObservableObject {
    
    @Published var list: [Datasheet] = []
    
    override init() {
        super.init()
        self.list =  datasheetRepository.getAll()
    }
    
    func load()  {
        self.list = datasheetRepository.getAll()
    }
    
    func delete(index: [Int]) {
        datasheetRepository.delete(index: index)
        load()
    }
    
}
