import SwiftUI
import MapKit

struct MapScreenView: View {
    @State var userProfile: UserProfile
    @Binding var isLandingScreenView: Bool
    @State private var showMapScreenModalView: Bool = false
    @State var visibleRegion: MKCoordinateRegion? // This is the region viewed by the user on the map, the region can change if the user moves the map or if the application re-position the map on a POI for instance. The main usage is for the search function
    @State  var searchResults: [MKMapItem] = []
    @Binding var cameraPosition: MapCameraPosition

    @State  var criteria: [Criterion] = []
    
    // Constants for modal positions
    let lowPosition: CGFloat = 0.125 // Low position (1/8th of the screen)
    let midPosition: CGFloat = 0.6   // Mid position (half of the screen)
    let highPosition: CGFloat = 0.9  // High position (near full screen)
    
    // Custom initializer
     init(userProfile: UserProfile, isLandingScreenView: Binding<Bool>, cameraPosition: Binding<MapCameraPosition>) {
         self._userProfile = State(initialValue: userProfile)
         self._isLandingScreenView = isLandingScreenView
         self._cameraPosition = cameraPosition
         self._criteria = State(initialValue: userProfile.criteria) // Initialize criteria with userProfile.criteria
     }

    var body: some View {

        ZStack {
            // Your MapView
            MapView(isWidgetMode: false, userProfile: userProfile, isLandingScreenView: $isLandingScreenView, visibleRegion: $visibleRegion, searchResults: $searchResults, showMapScreenModalView : $showMapScreenModalView, cameraPosition : $cameraPosition)
  
        }
        .sheet(isPresented: $showMapScreenModalView) {
            // Your ModalView
            MapScreenModalView(searchResults : $searchResults,  visibleRegion : $visibleRegion,criteria : $criteria)
                .presentationDetents([
                    .fraction(lowPosition),
                    .fraction(midPosition),
                    .fraction(highPosition)
                ])
                .presentationDragIndicator(.visible)
        }
    }
}

struct MapScreenView_Previews: PreviewProvider {
    @State static var isLandingScreenView = false
    @State static var cameraPosition: MapCameraPosition = .automatic // Automatic means that it will center on markers set on the map


    static var previews: some View {
        MapScreenView(userProfile: UserProfile(), isLandingScreenView: $isLandingScreenView,cameraPosition: $cameraPosition)
    }
}

