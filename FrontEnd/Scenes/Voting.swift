import SwiftUI

struct Voting: View {
    @State private var lastVote: String = "None"

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top half (Song1)
                
             
                
                
                var Song1 = "Song1";
                ZStack {
                    Color.red
                        .ignoresSafeArea()
                        .onTapGesture {
                            lastVote = Song1
                        }
                    
                    Text(Song1)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(height: geometry.size.height / 2)
                .contentShape(Rectangle()) // Ensure the entire area is tappable

                // Middle section (Last vote display)
                //This is just for tesitng to make sure it counts votes obvioulsy better ways
                Text("Last Vote: \(lastVote)")
                    .font(.title)
                    .foregroundColor(.yellow)
                    .background(Color.black)
                    .frame(maxWidth: .infinity)

                // Bottom half (Song2)
                ZStack {
                    Color.blue
                        .ignoresSafeArea()
                        .onTapGesture {
                            lastVote = "song2"
                        }

                    var song2 = "Song2"
                    Text(song2)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(height: geometry.size.height / 2)
                .contentShape(Rectangle())
            }
        }
    }
}

struct Voting_Previews: PreviewProvider {
    static var previews: some View {
        Voting()
    }
}
