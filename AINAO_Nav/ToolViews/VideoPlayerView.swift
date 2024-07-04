//
//  VideoPlayerView.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//
import SwiftUI
import AVKit

struct VideoPlayerView: View {
    var name : String
    var myPlayer: AVPlayer

    init(name : String) {
        self.name = name
        let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: self.name, ofType: "mp4")!)
        myPlayer = AVPlayer(url: videoURL)
        myPlayer.isMuted = true // Si vous voulez que la vidéo soit muette
        myPlayer.play()
    }

    var body: some View {
        VideoPlayer(player: myPlayer)
            .aspectRatio(contentMode: .fill) // .fit
            .onAppear {
                self.myPlayer.play() // This will start playing the video as soon as the view appears
                self.loopVideo(self.myPlayer)
            }
            .ignoresSafeArea()
    }
    
    func loopVideo(_ player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
}

// Preview
struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(name : "SplashNaturePortrait")
    }
}
