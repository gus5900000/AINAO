import SwiftUI
import MapKit

struct LandingScreenView: View {
    
    @State var userProfile: UserProfile // This is in fact an @ObservedObject
    @Binding var isLandingScreenView: Bool
    @Binding var cameraPosition: MapCameraPosition
    
    @State private var isEditingProfile = false // Track whether the profile sheet is open
    @State var visibleRegion: MKCoordinateRegion? // This is the region viewed by the user on the map
    @State var searchResults: [MKMapItem] = []
    @State private var showMapScreenModalView: Bool = false
    
    @State var ViewModel = WheatherViewmodel() // (api) appelle de la function
    
    // Sample data for ScrollView
    
    struct WeatherItem: Identifiable {
        let id = UUID()
        let description: String
        let imageName: String
        let icone: String
    }
    
    let weatherItems = [
        WeatherItem(description: "Dans la rue Beaufort, grosse foule, impossible de passer. Bon courage.", imageName: "foule", icone: "icone.name"),
        WeatherItem(description: "Dans la ville de Toulouse, il fait super chaud : 39°C. Attention à vous.", imageName: "chaleur", icone: ""),
        WeatherItem(description: "Dans le métro Saouzelong l'escalator ne fonctionne pas, encore une fois.", imageName: "panne", icone: ""),
        WeatherItem(description: "Pente dans la rue Belbaz à Lille : les skateurs seront contents mais pas moi.", imageName: "pente", icone: "")
    ]
    
    var body: some View {
        NavigationView { // Start of NavigationView
            ZStack {
                Color(Theme.color60)
                    .ignoresSafeArea()
                
                VStack(alignment : .leading) {
                    VStack {
                        ZStack {
                            // Call to MapView which will be protected by the shield
                            MapView(isWidgetMode: true, userProfile: userProfile, isLandingScreenView: $isLandingScreenView, visibleRegion: $visibleRegion, searchResults: $searchResults, showMapScreenModalView: $showMapScreenModalView, cameraPosition: $cameraPosition)
                                .frame(maxWidth: 400, maxHeight: 300) // Set the maximum width and height
                                .background(RoundedRectangle(cornerRadius: Consts.UI.cornerRadiusFrame)
                                    .fill(Theme.frame))
                            
                            // Here is the shield..
                            Color.clear
                                .contentShape(Rectangle()) // This ensures the entire area is tappable
                                .onTapGesture {
                                    isLandingScreenView = false
                                }
                                .gesture(DragGesture().onChanged { _ in })
                                .allowsHitTesting(true) // This allows the view to intercept touch events
                        } // fin Zstack
                    } // fin Vstack
                    
                    .overlay(
                            RoundedRectangle(cornerRadius: 15) // coins arrondis
                                .stroke(Color.white, lineWidth: 2)
                    //            .background(Color.white.opacity(0.3))
                            // Couleur et épaisseur du contour
                        )
                    
                    .cornerRadius(15)
                    .padding()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 2)
                            .padding([.leading,.trailing], 0)
                        ScrollView  {
                            
                            ForEach(weatherItems) { item in
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 1)
                                            .background(Color.white)
                                            .cornerRadius(15)
                                        Image(item.imageName)
                                            .resizable()
                                            .cornerRadius(15)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 15) // coins arrondis
//                                                    .stroke(Color.white, lineWidth: 1) // Couleur et épaisseur du contour
//                                            )
                                    }.frame(width: 120, height: 100)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 1)
                                            .background(Color.white)
                                            .cornerRadius(15)
                                        
                                        Text(item.description)
//                                            .italic()
                                            .padding()
//                                            .background(Color.cyan.opacity(0.4))
//                                            .background(Color.white)
//                                            .cornerRadius(15)
                                            .font(.custom("SF Compact Rounded", size: 16))
                                            .foregroundColor(Theme.color10)
                                    }
                                    
                                } // fin HStack
//                                .padding([.leading,.trailing], 17)
                            } // fin ForEach
                            
                        }
                    }   .clipShape(RoundedRectangle(cornerRadius: 15)) // fin ZStack
                        .padding([.leading,.trailing], 17) // fin ScrollView
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
//                                .fill(Color.gray.opacity(0.15))
//                                .fill(Theme.color30.opacity(0.2))
                                .cornerRadius(15)
                                .frame(width: 360, height: 150)
                                
                                .overlay(
                                        RoundedRectangle(cornerRadius: 15) // coins arrondis
                                            .stroke(Color.white, lineWidth: 1) // Couleur et épaisseur du contour
                                    )
                                .padding()
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Lille")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white/*.opacity(0.7)*/)
                                        .onAppear {
                                            Task {
                                                await ViewModel.fetchWeatherMeteo()
                                            }
                                        }
                                        .padding(.trailing,40)
                                    
                                    if ViewModel.isloading {
                                        ProgressView("Chargement...")
                                    } else {
                                        Text("\(ViewModel.weather.first?.temperature ?? 0, specifier: "%.1f") °C")
                                            .font(.system(size: 32))
//                                            .foregroundColor(.gray.opacity(0.9))
                                            .foregroundColor(Theme.color10.opacity(0.8))
                                            .padding(.leading,24)//decale a droite

                                    } //else
                                } // fin hstack  de la premier ligne lille temp
                               
                                if !ViewModel.isloading {
                                    
                                    VStack(alignment: .leading, spacing: 20) {
                                        
                                        ForEach(ViewModel.weather) { weather in
                                            VStack(alignment: .leading, spacing: -2) {
                                                
                                                Text(weather.description)
                                                
                                                //.foregroundStyle(Theme.color10)
                                                    .foregroundColor(Theme.color10.opacity(0.6))
                                                    .font(.system(size: 20))
                                                    .padding(.leading, 144)//decale a droite
                                                //                                              HStack {
                                                //                                                    Rectangle()
                                                //                                                        .fill(
                                                //                                                            LinearGradient(
                                                //                                                                gradient: Gradient(colors: [.blue, .green, .yellow, .red, .indigo, .purple]),
                                                //                                                                startPoint: .topLeading,
                                                //                                                                endPoint: .bottomTrailing
                                                //                                                            )
                                                //                                                        )
                                                //                                                        .frame(width: 150, height: 5) // ligne multicolore
                                                //                                                        .cornerRadius(15)
                                                //                                                        .padding(.leading,120)
                                                //
                                                //
                                                //                                                    Circle()
                                                //                                                        .fill(Color.white)
                                                //                                                        .frame(width: 20, height: 20)
                                                //                                                        .padding(.leading, -120)
                                                //
                                                //                                                } // fin Vstack
                                                
                                                HStack {
                                                    Text("Qualité \n de l'air")
                                                        .font(.system(size: 24))
                                                        .bold()
                                                        .foregroundStyle(.white/*.opacity(0.7)*/)
                                                    Text("moyenne")
                                                        .foregroundColor(Theme.color10.opacity(0.6))
                                                        .padding(.leading,54)
                                                        .font(.system(size: 32))
                                                } //fin hstack
                                                
                                            } // fin Vstack
                                        } // fin Foreach
                                    } // fin Vstack
                                } // fin if
                            } // fin hsatck
                        } // fin Zstack
                    } // fin hstack
                } // fin vstack
            } // END OF MAIN ZSTACK
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ainao")
//                        .bold()
//                        .font(.title)
                        .foregroundStyle(Theme.color10)
                        .font(.custom("SF Compact Rounded", size: 40))
                } // fin toolbar items
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditingProfile = true
                    }) {
                        CircleImageView(image: Image("clint"), size: 96)
                    }
                    .accentColor(.white)
                    
                } // fin toolbar items
            } // fin toolbar
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $isEditingProfile) {
                ProfileEntranceView(userProfile: $userProfile, isEditingProfile: $isEditingProfile)
                //ProfileScreenView(userProfile: $userProfile, isEditingProfile: $isEditingProfile)
                
            } // Fin shett
        } // END OF MAIN ZSTACK
        
        
        .ignoresSafeArea()
    } // End of NavigationView
} // END OF VAR BODY

struct LandingScreenView_Previews: PreviewProvider {
    @State static var isLandingScreenView = true
    @State static var cameraPosition: MapCameraPosition = .automatic
    
    static var previews: some View {
        LandingScreenView(userProfile: UserProfile(), isLandingScreenView: $isLandingScreenView, cameraPosition: $cameraPosition)
    }
}
