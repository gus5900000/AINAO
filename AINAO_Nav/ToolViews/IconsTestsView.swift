import SwiftUI

struct IconsTestsView: View {
    @State private var iconColorPOT = Color.blue
    @State private var iconColorPOI = Color.red
    let iconFrameSize: Double = 50
    let colorPickerWidth: CGFloat = 300 // Adjust the width as needed
    let colorPickerHeight: CGFloat = 30 // Adjust the height as needed to make it thinner

    var body: some View {
        TabView {
            // First Tab for POT
            ZStack {
                Color.Tcolor60
                    .ignoresSafeArea()
                
                VStack {
                    Text("POT")
                        .foregroundStyle(Theme.color30)
                        .font(.title)
                        .padding(.top)

                    ColorPicker("Select Icon Color", selection: $iconColorPOT, supportsOpacity: false)
                        .frame(width: colorPickerWidth, height: colorPickerHeight)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .shadow(radius: 5)
                    
                    Divider() // Section line below the color picker
                        .background(Color.gray)
                        .padding(.bottom, 20)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                            ForEach(POTType.allCases, id: \.self) { potType in
                                VStack {
                                    potType.iconImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: iconFrameSize, height: iconFrameSize)
                                        .foregroundColor(iconColorPOT)
                                    Text(potType.displayName)
                                }
                            }
                        }
                    }
                }
            }
            .tabItem {
                Label("POT", systemImage: "p.circle.fill")
            }
            
            // Second Tab for POI
            ZStack {
                Color.Tcolor60
                    .ignoresSafeArea()
                
                VStack {
                    Text("POI")
                        .foregroundStyle(Theme.color30)
                        .font(.title)
                        .padding(.top)

                    ColorPicker("Select Icon Color", selection: $iconColorPOI, supportsOpacity: false)
                        .frame(width: colorPickerWidth, height: colorPickerHeight)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .shadow(radius: 5)
                    
                    Divider() // Section line below the color picker
                        .background(Color.gray)
                        .padding(.bottom, 20)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                            ForEach(POIType.allCases, id: \.self) { poiType in
                                VStack {
                                    poiType.iconImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: iconFrameSize, height: iconFrameSize)
                                        .foregroundColor(iconColorPOI)
                                    Text(poiType.displayName)
                                }
                            }
                        }
                    }
                }
            }
            .tabItem {
                Label("POI", systemImage: "p.square.fill")
            }
        }
    }
}

// Preview
struct IconsTestsView_Previews: PreviewProvider {
    static var previews: some View {
        IconsTestsView()
    }
}
