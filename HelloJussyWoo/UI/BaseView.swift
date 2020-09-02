import SwiftUI


extension TabBgView {
    
}

struct TabBgView<Content>: View where Content: View {
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content, title: String) {
        self.content = content()
        self.title = title
    }
    
    var title: String = "Datasheet"
    let bgColor: Color = .blue
    
    var body : some View {
        GeometryReader { geometry in
            ZStack {
                Ellipse()
                    .fill(self.bgColor)
                    .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.33)
                    .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        
                        Spacer()
                        
                    }.padding(.leading, 25).padding(.top, 50)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        
                        NavigationLink(destination: EmptyView()) {
                            
                            Image(systemName: "plus")
                                .resizable()
                                .padding(6)
                                .frame(width: 28, height: 28)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.pink)
                        }
                        
                        
                        Spacer()
                        
                    }.padding(.trailing, 20).padding(.top, 40)
                    
                }.edgesIgnoringSafeArea(.all)
                
            }
            
            //body here
            self.content.padding(.top, 40)
        }
    }
}


struct TabBgIconView<Content>: View where Content: View {
    
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content,title: String, imageIcon: String) {
        self.content = content()
        self.title = title
        self.imageIcon = imageIcon
    }
    
    var title: String = "Datasheet"
    var imageIcon: String = "avatar"
    let bgColor: Color = .blue
    
    var body : some View {
        GeometryReader { geometry in
            ZStack {
                Ellipse()
                    .fill(self.bgColor)
                    .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.33)
                    .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        
                        Spacer()
                        
                    }.padding(.leading, 25).padding(.top, 50)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        NavigationLink(destination: EmptyView()) {
                            
                            Image(systemName: self.imageIcon)
                            .resizable()
                            .padding(6)
                            .frame(width: 28, height: 28)
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(.pink)
                        }
                        
                        Spacer()
                        
                    }.padding(.trailing, 20).padding(.top, 40)
                    
                }.edgesIgnoringSafeArea(.all)
                
            }
            
            //body here
            self.content.padding(.top, 40)
        }
    }
}

struct NoIconBgView<Content>: View where Content: View {
    
    var content: () -> Content
    
    var title: String = "Datasheet"
    let bgColor: Color = .blue
    
    var body : some View {
        GeometryReader { geometry in
            ZStack {
                Ellipse()
                    .fill(self.bgColor)
                    .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.33)
                    .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        
                        Spacer()
                        
                    }.padding(.leading, 25).padding(.top, 50)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Spacer()
                    }.padding(.trailing, 20).padding(.top, 40)
                    
                }.edgesIgnoringSafeArea(.all)
                
            }
            
            //body here
            self.content().padding(.top, 40)
        }
    }
}
