import SwiftUI


extension View {
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

struct TabBgView<Content>: View where Content: View {
    
    private let content: Content
    @State var isLinkActive = false
    
    public init(@ViewBuilder content: () -> Content, title: String) {
        self.content = content()
        self.title = title
    }
    
    var title: String = "Datasheet"
    var bgColor: Color {
        return Color(hexStringToUIColor(hex: "#009af9"))
    }
    
    
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
                    
//                    VStack(alignment: .trailing) {
//                        
//                        NavigationLink(destination: EmptyView(), isActive: self.$isLinkActive) {
//                            Button(action: {
//                                print("clicked on plus")
//                                self.isLinkActive = true
//                            }) {
//                                Image(systemName: "plus")
//                                    .resizable()
//                                    .padding(6)
//                                    .frame(width: 36, height: 36)
//                                    .background(Color.pink)
//                                    .clipShape(Circle())
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        
//                        
//                        Spacer()
//                        
//                    }.padding(.trailing, 20).padding(.top, 100)
                    
                    
                }.edgesIgnoringSafeArea(.all)
                
            }
            
            //body here
            self.content.padding(.top, 30)
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
    var bgColor: Color {
        return Color(hexStringToUIColor(hex: "#009af9"))
    }
    
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
    var bgColor: Color {
        return Color(hexStringToUIColor(hex: "#009af9"))
    }
    
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
                        
                    }.padding(.leading, 25).padding(.top, 60)
                    
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



