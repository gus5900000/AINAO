//
//  MapScreenModalView.swift
//  AINAO_Nav
//
//  Created by Vincent Van hoylandt on 27/06/2024.
//
import Foundation
import SwiftUI
import MapKit

struct MapScreenModalView: View {
    // Input Parameters
    
    @Binding  var searchResults: [MKMapItem]
    @Binding  var visibleRegion: MKCoordinateRegion?
    @Binding var criteria : [Criterion]
    
    
    /*
     //Criteria toggles listening
     //    @State var ToiletTapped:Bool = false
     @State var CalmTapped:Bool = false
     @State var StairsTapped:Bool = false
     @State var SlipperyTapped:Bool = false
     @State var WindyTapped:Bool = false
     @State var CrowedTapped:Bool = false
     @State var FirstAidTapped:Bool = false
     @State var ClimatizedTapped:Bool = false
     @State var DangerousTapped:Bool = false
     */
    // Places Symbols listening
    @State var NoiseFilterOn:Bool = false
    @State var StairsFilterOn:Bool = false
    @State var NarrowFilterOn :Bool = false
    @State var FourthFilterOn:Bool = false
    // To be developed: individualize toggle status
    
    // Searchbar listening
    @State var searchText: String = ""
    
    // LazyVGrid dynamic behave
    var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
  
    @State var searchedPOI : [CriterionPOI] = []
    
    struct CriterionPOI {
        let type : POIType
        var isSet : Bool
    }
    
    
    // Custom initializer
    init(searchResults: Binding<[MKMapItem]>,
         visibleRegion: Binding<MKCoordinateRegion?>,
         criteria: Binding<[Criterion]>) {
        self._searchResults = searchResults
        self._visibleRegion = visibleRegion
        self._criteria = criteria
        // Initialize searchedPOI with one CriterionPOI for each POIType
        self.searchedPOI = POIType.allCases.map { CriterionPOI(type: $0, isSet: false) }
        print("Initialized searchedPOI with \(searchedPOI.count) items.")
        
    }
    
    private func initializeSearchedPOI() {
        if searchedPOI.isEmpty {
            searchedPOI = POIType.allCases.map { CriterionPOI(type: $0, isSet: false) }
        }
    }
    
    var body: some View {
        let iconFrameSize: Double = 30
        
        let _ = self.initializeSearchedPOI()
        
        NavigationStack {
            ScrollView {
                //                ShowModalButtonView()
                //
                SearchBarView(searchResults: $searchResults, visibleRegion: $visibleRegion)
                
                //  Spacer().frame(height: 32)
                VStack(alignment : .leading, spacing : 0) {
                    
                    
                    
                    Text("Afficher ces lieux") //Heading 2nd container
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.color10)
                        .padding()
                    
                    // Criteria toggles
                    ZStack {
                        RoundedRectangle(cornerRadius: 12.0)
                            
                            .fill(.white)
                            .frame(width: 350, height: 230,alignment: .center)
                            .frame(maxHeight: .infinity)
                            
                        
                        LazyVGrid(columns: threeColumnGrid, spacing: 18,content:  {
                            
                            ForEach(searchedPOI.indices, id: \.self) { index in
                                
                                Button {
                                    searchedPOI[index].isSet.toggle()
                               //     let _ = print("Toggled() \(searchedPOI[index].type.displayName)")
                                    let displayName = searchedPOI[index].type.displayName
                                     search(for: displayName, visibleRegion: visibleRegion) // Assuming you want to search the entire map
                                    
                                } label: {
                                    VStack {
                                        searchedPOI[index].type.iconImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: iconFrameSize, height: iconFrameSize)
                                            .opacity(searchedPOI[index].isSet ? 1 : 0.3)

                                        //    .foregroundColor(searchedPOI[index].isSet ? Theme.color10 : Theme.appleGrey)
                                        

                                            .foregroundColor(Theme.color30)
                                        

                                        
                                        Text(searchedPOI[index].type.displayName)
                                            .foregroundStyle(Theme.color10)
                                            .font(.system(size: 12))
                                    } // END VSTACK
                                }// END BUTTON
                                
                                /*
                                Toggle(isOn: $searchedPOI[index].isSet) {
                                    HStack {
                                        Text(searchedPOI[index].type.displayName)
                                    }
                                }
                                .padding([.leading, .trailing], 10)
                                .toggleStyle(SwitchToggleStyle(tint: Theme.color10))
                                .foregroundStyle(.black)
                                .font(.system(size: 18))
                                 */
                            }
                        }).padding([.leading, .trailing], 0)
                    }
                    /*
                     .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher un lieu")
                     */
                    Text("Eviter ces situations") //Heading 1st container
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.color10)
                        .padding()
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 12.0)
                            
                            .fill(.white)
                            .frame(width: 350, height: 350,alignment: .center)
                            .frame(maxHeight: .infinity)
                        EditCriteriaView(criteria: $criteria, iconFrameSize: iconFrameSize,grid_style: 1)
                    }
                }
                
            }.background(Theme.appleGrey)
        }.cornerRadius(15)
            .padding()
             .background(Theme.appleGrey)
//            .ignoresSafeArea()
            .onAppear {
                if searchedPOI.isEmpty {
                    searchedPOI = POIType.allCases.map { CriterionPOI(type: $0, isSet: false) }
                    print("Initialized searchedPOI with \(searchedPOI.count) items.")
                }
            }
    }
    // Search func takes a String parameter named query
    func search(for query : String,visibleRegion: MKCoordinateRegion?) {
        
  
        Task {
            await MapManager.searchPlaces(
                searchResult : &searchResults,
                searchText: query,
                visibleRegion: visibleRegion
            )
        }

    }

    
}


struct MapScreenModalView_Previews: PreviewProvider {
    static var mockSearchResults: [MKMapItem] = []
    static var userProfile: UserProfile = UserProfile()
    static var criteria: [Criterion] = userProfile.criteria // Assuming 'userProfile.criteria' is static or initialized with default values
    
    static var mockRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), // Coordinates for Paris
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    static var previews: some View {
        MapScreenModalView(searchResults: .constant(mockSearchResults), visibleRegion: .constant(mockRegion), criteria: .constant(criteria))
    }
}





