//
//  MapView.swift
//  EatSideStory
//
//  Created by FrancoisW on 16/06/2024.
//


import SwiftUI
import MapKit
import SwiftData

/*
 This view has two modes, one fulle screen, the other one in widget mode with
 */
struct MapView: View {
    
    @State var isWidgetMode : Bool
    @State var userProfile : UserProfile
    @Binding var  isLandingScreenView : Bool
    @Binding var visibleRegion: MKCoordinateRegion? // This is the region viewed by the user on the map, the region can change if the user moves the map or if the application re-position the map on a POI for instance. The main usage is for the search function
    @Binding  var searchResults: [MKMapItem]
    @State private var route: MKRoute?
    @Binding  var showMapScreenModalView: Bool
    @Binding var cameraPosition: MapCameraPosition
    
    
    // State variable
    
    @State var selectedResult: MKMapItem? // This MKMapItem commes from the user selection of a MapItem on the Map
    @State var userCreatedMapItem: UnifiedMapItem? // This map item is
    @State var doDisplayPOXMapItemInfoView : Bool = false

    //
    // .automatic (changes when Markers change)
    // . region(MKoordinateRegion) at a given region
    // rect()
    // item(MKMapItem)
    //camera(MapCamera)
    // userlOca
    
    @State private var selectedTag: UUID?
    
    
    @State  var userUnifiedMapItem : [UnifiedMapItem] = []
    @State  var searchUnifiedMapItem : [UnifiedMapItem] = []
    var listUnifiedMapItems : [UnifiedMapItem] {return userUnifiedMapItem + searchUnifiedMapItem}
    
    @State var isManualMarker = false // When we enter this mode, we know that we are currently trying to create or not a marker
    @State  var currentlyEditedPlacemark : Placemark?
    
    
    @FocusState private var searchFieldFocus: Bool
    
    // MAP configurztion related variables
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var mapType: Int = 2
    
    @State  var simplonUUID = UUID()
    @Namespace private var mapScope
    //    @State private var mapStyleConfig = MapStyleConfig()
    @State private var pickMapStyle = false
    
    
    var selectedMapStyle: MapStyle {
        switch mapType {
        case 0: return .standard
        case 1: return .hybrid
        case 2: return .standard(elevation: .realistic)
        case 3: return .imagery(elevation: .realistic)
            
        default: return .standard
        }
    }
    
    private var locationManager = CLLocationManager()
    @StateObject private var locationDelegate = LocationManagerDelegate()
    
    // Variables involved in the creation of new POIs and POTs
    @State private var newLocation: CLLocationCoordinate2D?
    
    
    
    init(isWidgetMode: Bool,
         userProfile: UserProfile,
         isLandingScreenView: Binding<Bool>,
         visibleRegion: Binding<MKCoordinateRegion?>,
         searchResults: Binding<[MKMapItem]>,
         showMapScreenModalView: Binding<Bool>,
         cameraPosition: Binding<MapCameraPosition>) {
        self._isWidgetMode = State(initialValue: isWidgetMode)
        self._userProfile = State(initialValue: userProfile)
        self._isLandingScreenView = isLandingScreenView
        self._visibleRegion = visibleRegion
        self._searchResults = searchResults
        self._showMapScreenModalView = showMapScreenModalView
        self._cameraPosition = cameraPosition
        // Initialize other properties as needed
    }
    
    
    var body: some View {
        MapReader { proxy in
            Map(position: $cameraPosition, selection : $selectedResult, scope : mapScope) {
                //        Map(position: $cameraPosition, selection : $selectedTag) {
                
                let _ = print("IsLanding(\(isLandingScreenView)) : \(cameraPosition)")
                /*
                 Marker("Simplon", systemImage: "shower.handheld.fill", coordinate : Consts.Map.simplonCoordinate)
                 .tint(Color.Tcolor60)
                 .tag(simplonUUID)
                 
                 */
                /*
                 if let centerCoordinate = visibleRegion?.center {
                 MapCircle(
                 //   center: simplonRegion.center,
                 center : centerCoordinate,
                 radius: 3000
                 )
                 .foregroundStyle(.red.opacity(0.5))
                 }
                 */
                /*
                 ForEach(listPlacemarks) { placemark in
                 if placemark.destination != nil {
                 Marker(coordinate: placemark.coordinate) {
                 Label(placemark.name, systemImage: "star")
                 }
                 .tint(.yellow)
                 .tag(placemark.id)
                 } else {
                 Marker(placemark.name, coordinate: placemark.coordinate)
                 .tag(placemark.id)
                 
                 }
                 }
                 */
                
                ForEach (searchResults, id: \.self) { result in
                    Marker(item : result)
                }
                .annotationTitles(.hidden) // Can be hidden if screen too crowded
                
                let gradient = LinearGradient(
                    colors: [.yellow,.green,.blue],
                    startPoint: .leading, endPoint: .trailing
                )
                
                let stroke = StrokeStyle(
                    lineWidth: 6,
                    lineCap:.round,
                    lineJoin:.round                )
                
                if let route {
                    let _ = print("We've got a route guys !")
                    MapPolyline(route)
                        .stroke(.blue,style: stroke)
                }
                
                // Here we do put our user location, not to ghet lost
                UserAnnotation()
                
                
            } // END OF MAP()
            // CAUTION Tricky area, we disable any userinteraction with the map if in widget mode
            .disabled(isWidgetMode)
            
            /*
            .simultaneousGesture(LongPressGesture(minimumDuration: 1)
              .sequenced(before: DragGesture(minimumDistance: 0))
              .onEnded { value in
                switch value {
                case .first(true, let longPress):
                  // This means the LongPressGesture has succeeded
                  // Get the location from longPress.location
                  print("Long press detected!")
                  if let location = longPress.location {
                    // Use the location for further actions (e.g., show info view)
                    print("Location: \(location)")
                  }
                  break
                case .second(true, let drag):
                  // This means the DragGesture has started after the long press (likely accidental)
                  // Ignore the drag gesture
                  print("Drag gesture after long press, ignored.")
                  break
                default:
                  break
                }
              })

            */
            
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)

                   searchResults.removeAll()
                   searchResults.append(mapItem)
                   selectedResult = mapItem
                   doDisplayPOXMapItemInfoView = true
                }
                
            }
            
            
            /***
             When the displayed map area change (because of user gesture or because the app changed it, the visible region is automatically. Please note that this variable is only updated
             when the user stops moving the map
             */
            .onMapCameraChange(frequency: .onEnd){ context in
                visibleRegion = context.region
            }
            
            .onAppear {
                /* Here we position the map on the user's default preferred region */
                if let region = userProfile.region {
                    cameraPosition = .region(region)
                }
                
                locationManager.delegate = locationDelegate
                locationManager.requestWhenInUseAuthorization()
                
                Text("Authorization Status: \(locationDelegate.authorizationStatus.rawValue)")
                    .onChange(of: locationDelegate.authorizationStatus) { newStatus in
                        print("Authorization status changed to: \(newStatus.rawValue)")
                        checkLocationAuthorizationStatus()
                    }
                
                // Request permission to access user location
                checkLocationAuthorizationStatus()
            }
                
            .safeAreaInset(edge: .bottom) {
                
             
                MapViewInsetBottom(
                    isWidgetMode : isWidgetMode,
                    searchFieldFocus: _searchFieldFocus,
                    visibleRegion: $visibleRegion,
                    searchResults: $searchResults,
                    cameraPosition: $cameraPosition,
                    selectedResult: $selectedResult,
                    route: $route,
                    showMapScreenModalView: $showMapScreenModalView,
                    userCreatedMapItem : $userCreatedMapItem,
                    doDisplayPOXMapItemInfoView : $doDisplayPOXMapItemInfoView,
                    userProfile : $userProfile
                )
                
               
                
                
            }
            
  
            .safeAreaInset(edge: .top) {
                if !isWidgetMode {
                    
                    
                    HStack(spacing: 0) {
                        Spacer()
                        VStack {
                            
                            // First Button
                            Button(action: {
                                print("Landing Toggle")
                                isLandingScreenView.toggle()
                            }) {
                                if !isWidgetMode {
                                    MapScreenButtonView(systemName: "minus.circle")
                                    //  .padding()
                                }
                            }
                            
                            
                            
                            MapUserLocationButton(scope: mapScope)
                            MapCompass(scope: mapScope)
                                .mapControlVisibility(.visible)
                            MapPitchToggle(scope: mapScope)
                                .mapControlVisibility(.visible)
                        }
                    }
                    .buttonBorderShape(.circle)
                    .padding()
                    .foregroundColor(.red)
                    
                    
                }
            }
            .mapScope(mapScope)
            
            .onChange(of: searchResults) { _ in
                cameraPosition = .automatic // Automatically adjusts the camera to show markers
            }
            
            .onChange(of: selectedResult) { _ in
                getDirections()
            }
        
            
            .mapStyle(selectedMapStyle)
            .mapControls {
                if !isWidgetMode {
                    //           MapUserLocationButton()
                    //         MapCompass()
                    MapScaleView()
                    //       MapPitchToggle()
                }
            } // END OF MAP Modifiers
        } // END OF MapReader
    } // END OF VAR BODY
    
    func getDirections() {
        // TODO, NEEED TO FIND A WAY TO REMOVE THE ROUTE
        //route = nil
        
        print("Entering GetDirections()")
        
        guard let selectedResult else {
            print("Entering GetDirections: NO SELECTED RESULT")
            
            return
        }
        
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: Consts.Map.simplonCoordinate)) // Default source for the route
        
        
        // Check if location services are enabled
        print("IsLocation enabled")

        // Use the last known location as the source if authorization status is allowed
        if locationDelegate.authorizationStatus == .authorizedWhenInUse || locationDelegate.authorizationStatus == .authorizedAlways {
            print("Yahoo, Location enabled")

            if let userLocation = locationManager.location?.coordinate {
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
                print("Yahoo, Found location")

            }
            else {
                print("Location not found")

            }

        } else {
            // Handle the case where location services are not authorized
            print("Location services are not authorized.")
        }

        
        
        
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                route = response.routes.first
            } catch {
                print("Error calculating directions: \(error)")
            }
        }
    }
    
    /*
     
     private func checkLocationAuthorizationStatus() {
     // Use the new instance property on CLLocationManager for iOS 14 and later
     let locationManager = CLLocationManager()
     locationManager.requestWhenInUseAuthorization()
     }
     */
    
    private func checkLocationAuthorizationStatus() {
        // Use the new instance property on CLLocationManager for iOS 14 and later
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    
    
}

struct MapStyleButton: View {
    @Binding var mapType: Int
    
    var body: some View {
        Button(action: {
            // Cycle through the map styles
            mapType = (mapType + 1) % 4
        }) {
            Image(systemName: "map.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.Tcolor30)
        }
        .frame(width: 60, height: 60)
        .clipShape(Circle())
        .background(Color.white.opacity(0.7).blur(radius: 10))
    }
}

struct MapViewControls: View {
    @Binding var mapType: Int
    // ... other bindings and state properties
    
    var body: some View {
        VStack {
            MapStyleButton(mapType: $mapType)
            // ... other custom buttons
            
            MapUserLocationButton()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .background(Color.white.opacity(0.7).blur(radius: 10))
            
            MapCompass()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .background(Color.white.opacity(0.7).blur(radius: 10))
            
            // ... other MapKit controls
        }
    }
}

struct MapViewInsetTopDeprecated: View {
    @State var isWidgetMode: Bool
    @Binding var cameraPosition: MapCameraPosition
    @Binding var mapType: Int
    @Binding var isLandingScreenView: Bool
    
    var body: some View {
        
        HStack {
            
            Spacer() // This will push the buttons to the edges
            
            
            
            /*
             if isWidgetMode {
             MapScreenButtonView(systemName: "plus.circle.fill")
             } else {
             MapScreenButtonView(systemName: "minus.circle.fill")
             }
             */
        }
        
        
        /*
         if !isWidgetMode {
         // Second Button
         Button(action: {
         print("Map Type Toggle")
         mapType = (mapType + 1) % 4
         }) {
         MapScreenButtonView(systemName: mapType == 0 ? "map.circle.fill" : "map.circle")
         }
         }
         */
    }
}



struct MapViewInsetBottom: View {
    @State var isWidgetMode : Bool
    
    @FocusState  var searchFieldFocus: Bool
    
    @Binding  var visibleRegion: MKCoordinateRegion?
    @Binding  var searchResults: [MKMapItem]
    @Binding var cameraPosition: MapCameraPosition
    @Binding  var selectedResult: MKMapItem? // This MKMapItem commes from the user selection of a MapItem on the Map
    @Binding  var route: MKRoute?
    @Binding  var showMapScreenModalView: Bool
    @Binding var userCreatedMapItem: UnifiedMapItem?
    @Binding var doDisplayPOXMapItemInfoView : Bool
    @Binding var userProfile : UserProfile

    
    var body: some View {
        //let _ = print("MapViewInsetBottom")
        
        if !isWidgetMode {
            
            HStack(spacing: 0) {
                Spacer()
                
                /*
                BeantownButtons(searchResults: $searchResults, position: $cameraPosition, visibleRegion: visibleRegion)
                    .padding(.top)
                    .background(.ultraThinMaterial)
                */
                
                
                Spacer()
                VStack {
                    SearchButton(showMapScreenModalView: $showMapScreenModalView,route : $route)
                        .padding()
                    
                }
            }
            
            
            /*
             CAUTION, the POX ItemInfoView needs to be placed after the other buttons in order to hide them
             */
            if let selectedResult {
        if (doDisplayPOXMapItemInfoView) {

          //      if (doDisplayPOXMapItemInfoView) {
                    let _ = print(("Calling POXMapItemInfoView\(selectedResult)"))
                    POXMapItemInfoView(
                        selectedResult: selectedResult,
                        route: route,
                        userCreatedMapItem: $userCreatedMapItem,
                        doDisplayPOXMapItemInfoView: $doDisplayPOXMapItemInfoView,
                    userProfile: $userProfile) // This map item is
                    
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        
    }
}


struct MapView_Previews: PreviewProvider {
    @State static var isLandingScreenView = true // Initialize the state variable
    @State static var showMapScreenModalView = false
    
    @State static var visibleRegion: MKCoordinateRegion? // This is the region viewed by the user on the map, the region can change if the user moves the map or if the application re-position the map on a POI for instance. The main usage is for the search function
    @State static var searchResults: [MKMapItem] = []
    @State static var cameraPosition: MapCameraPosition = .automatic // Automatic means that it will center on markers set on the map
    
    
    static var previews: some View {
        Group {
            MapView(isWidgetMode: true,
                    userProfile: UserProfile(),
                    isLandingScreenView: $isLandingScreenView,
                    visibleRegion: $visibleRegion,
                    searchResults: $searchResults,
                    showMapScreenModalView: $showMapScreenModalView,
                    cameraPosition: $cameraPosition)
            .previewDisplayName("Widget Mode")
            
            MapView(isWidgetMode: false,userProfile: UserProfile(),isLandingScreenView: $isLandingScreenView,visibleRegion: $visibleRegion,searchResults: $searchResults,
                    showMapScreenModalView: $showMapScreenModalView,
                    cameraPosition: $cameraPosition)
            .previewDisplayName("Full Screen Mode")
        }
    }
}

struct SearchButton: View {
    @Binding  var showMapScreenModalView: Bool
    @Binding  var route: MKRoute?
    
    var body: some View {
        
        Button(action: {
            route = nil
            showMapScreenModalView = true
        }) {
            MapScreenButtonView(systemName: "magnifyingglass")
        }
    }
    
}
