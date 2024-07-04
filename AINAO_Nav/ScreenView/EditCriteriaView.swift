//
//  EditCriteriaView.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 01/07/2024.
//

import SwiftUI

struct EditCriteriaView: View {
    
    @Binding var criteria : [Criterion]
    let iconFrameSize: Double
    var grid_style : Int
    var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.red)
                .frame(width:200)
            
            RoundedRectangle(cornerRadius: 15.0)
                .fill(Theme.frame)
                .frame(width: 340, height: 240, alignment: .center)
            
            
            switch grid_style {
            case 0:
                LazyVGrid(columns: twoColumnGrid, spacing: 16, content: {
                    ForEach(criteria.indices, id: \.self) { index in
                        /*** FIRST OPTION */
                        Toggle(isOn: $criteria[index].isSet) {
                            HStack {
                                Text(criteria[index].type.displayName)
                            }
                        }
                        .padding([.leading, .trailing], 10)
                        .toggleStyle(SwitchToggleStyle(tint: Theme.color10))
                        .foregroundStyle(.black)
                        .font(.system(size: 18))
                    }
                })
                
            case 1:
                
                
                LazyVGrid(columns: threeColumnGrid, spacing: 16,content:  {
                    ForEach(criteria.indices, id: \.self) { index in
                        
                        Button {
                            criteria[index].isSet.toggle()
                            let _ = print("Toggled() \(criteria[index].type.displayName)")
                            
                        } label: {
                            VStack {
                                criteria[index].type.iconImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: iconFrameSize, height: iconFrameSize)
                                
            //                       .foregroundColor(criteria[index].isSet ? Theme.color10 : Theme.color30)

                                    .foregroundColor(Theme.color30)
                                    .opacity(criteria[index].isSet ? 1 : 0.3)
                                
                                Text(criteria[index].type.displayName)
                                    .foregroundStyle(Theme.color10)
                                    .font(.system(size: 12))
                            } // END VSTACK
                            
                        }// END BUTTON
                    } // END FOR EACH
                }) // END LAZY GRID
                
            case 2:
                LazyVGrid(columns: threeColumnGrid, spacing: 16) {
                    ForEach(criteria.indices, id: \.self) { index in
                        HStack {
                            // Checkbox icon
                            Image(systemName: criteria[index].isSet ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    // Toggle the isSet property for the current criterion
                                    criteria[index].isSet.toggle()
                                }
                                .foregroundColor(criteria[index].isSet ? Theme.color10 : Theme.color30)
                            
                            // Display the icon image for the current criterion
                            criteria[index].type.iconImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconFrameSize, height: iconFrameSize)
                        }
                        .onTapGesture {
                            // Print the display name of the current criterion
                            print("Checkbox \(criteria[index].type.displayName) is now \(criteria[index].isSet ? "checked" : "unchecked")")
                        }
                    } // End of ForEach
                } // End of LazyVGrid
            case 3 :
                LazyVGrid(columns: twoColumnGrid, spacing: 16) {
                    ForEach(criteria.indices, id: \.self) { index in
                        HStack {
                            // Checkbox icon
                            Image(systemName: criteria[index].isSet ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    // Toggle the isSet property for the current criterion
                                    criteria[index].isSet.toggle()
                                }
                                .foregroundColor(criteria[index].isSet ? Theme.color10 : Theme.color30)
                            
                            // Display the display name for the current criterion
                            Text(criteria[index].type.displayName)
                                .foregroundStyle(Theme.color10)
                                .font(.system(size: 12))
                        }
                        .onTapGesture {
                            // Print the display name of the current criterion
                            print("Checkbox \(criteria[index].type.displayName) is now \(criteria[index].isSet ? "checked" : "unchecked")")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure alignment to the leading edge
                    } // End of ForEach
                } // End of LazyVGrid
                .padding()
                
            default:
                // Assuming you want a simple list for the default case
                List(criteria.indices, id: \.self) { index in
                    Toggle(isOn: $criteria[index].isSet) {
                        Text(criteria[index].type.displayName)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Theme.color10))
                    .foregroundStyle(.black)
                    .font(.system(size: 18))
                }
            }
        } // END OF MAIN ZSTACK
    }
    
}
// Define a custom checkbox style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}



/*
 switch grid_style {
 case 0:
 LazyVGrid(columns: twoColumnGrid, spacing: 16,content:  {
 ForEach(criteria.indices, id: \.self) { index in
 
 
 /*** FIRST OPTION */
 Toggle(isOn: $criteria[index].isSet) {
 HStack {
 Text(criteria[index].type.displayName)
 }
 }
 .padding([.leading, .trailing], 10)
 .toggleStyle(SwitchToggleStyle(tint: Theme.color10))
 .foregroundStyle(.black)
 .font(.system(size: 18))
 
 
 
 
 case 1:
 LazyVGrid(columns: threeColumnGrid, spacing: 16,content:  {
 ForEach(criteria.indices, id: \.self) { index in
 
 Button {
 criteria[index].isSet.toggle()
 let _ = print("Toggled() \(criteria[index].type.displayName)")
 
 } label: {
 VStack {
 criteria[index].type.iconImage
 .resizable()
 .scaledToFit()
 .frame(width: iconFrameSize, height: iconFrameSize)
 
 .foregroundColor(criteria[index].isSet ? Theme.color10 : Theme.color30)
 
 Text(criteria[index].type.displayName)
 .foregroundStyle(Theme.color10)
 .font(.system(size: 12))
 
 }
 } // END BUTTON
 
 default :
 Text("TOTO")
 }
 }
 
 */
/*
 Button {
 CalmTapped.toggle()
 let _ = print("Calm Toggled")
 
 } label: {
 VStack {
 Image(systemName: "figure.mind.and.body").foregroundStyle(CalmTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("au calme")
 .foregroundStyle(.black)
 }
 }
 
 Button {
 StairsTapped.toggle()
 } label: {
 VStack {
 Image(systemName: "stairs").foregroundStyle(StairsTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("sans escalier")
 .foregroundStyle(.black)
 }
 }
 Button {
 SlipperyTapped.toggle()
 } label: {
 VStack {
 Image(systemName: "figure.fall").foregroundStyle(SlipperyTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("non glissant")
 .foregroundStyle(Theme.color10)
 }
 }
 
 Button {
 WindyTapped.toggle()
 } label: {
 VStack {
 Image(systemName: "wind").foregroundStyle(WindyTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("sans vent")
 .foregroundStyle(.black)
 }
 }
 
 Button {
 CrowedTapped.toggle()
 } label: {
 VStack {
 Image(systemName: "person.3").foregroundStyle(CrowedTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("peu fréquenté").foregroundStyle(.black)
 }
 }
 
 Button {
 FirstAidTapped.toggle()
 } label: {
 VStack {
 Image(systemName: "cross.case").foregroundStyle(FirstAidTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("où se soigner").foregroundStyle(.black)
 }
 }
 
 Button {
 ClimatizedTapped.toggle()
 } label: {
 VStack {
 Image(systemName: "sThemenowflake").foregroundStyle(ClimatizedTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("climatisé").foregroundStyle(.black)
 }
 }
 Button {
 DangerousTapped.toggle()
 } label: {
 VStack {
 Image(systemName: "exclamationmark.triangle").foregroundStyle(DangerousTapped ? Theme.color10 : Theme.color30)
 .font(.system(size: 40))
 Text("sans danger").foregroundStyle(.black)
 }
 }
 */
//                                .onAppear {
//                        changeHeight.toggle()
struct Style0_Previews: PreviewProvider {
    static var userProfile: UserProfile = UserProfile()
    static var criteria: [Criterion] = userProfile.criteria // Assuming 'userProfile.criteria' is static or initialized with default values
    
    @Binding var criteria : [Criterion]
    let iconFrameSize: Double
    static var previews: some View {
        EditCriteriaView(criteria: .constant(criteria), iconFrameSize: 30,grid_style: 0)
    }
}

struct Style1_Previews: PreviewProvider {
    static var userProfile: UserProfile = UserProfile()
    static var criteria: [Criterion] = userProfile.criteria // Assuming 'userProfile.criteria' is static or initialized with default values
    
    @Binding var criteria : [Criterion]
    let iconFrameSize: Double
    static var previews: some View {
        EditCriteriaView(criteria: .constant(criteria), iconFrameSize: 30,grid_style: 1)
    }
}

struct Style2_Previews: PreviewProvider {
    static var userProfile: UserProfile = UserProfile()
    static var criteria: [Criterion] = userProfile.criteria // Assuming 'userProfile.criteria' is static or initialized with default values
    
    @Binding var criteria : [Criterion]
    let iconFrameSize: Double
    static var previews: some View {
        EditCriteriaView(criteria: .constant(criteria), iconFrameSize: 30,grid_style: 2)
    }
}

struct Style3_Previews: PreviewProvider {
    static var userProfile: UserProfile = UserProfile()
    static var criteria: [Criterion] = userProfile.criteria // Assuming 'userProfile.criteria' is static or initialized with default values
    
    @Binding var criteria : [Criterion]
    let iconFrameSize: Double
    static var previews: some View {
        EditCriteriaView(criteria: .constant(criteria), iconFrameSize: 30,grid_style: 3)
    }
}


