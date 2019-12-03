import SwiftUI

struct SongCell: View {
    @ObservedObject
    private var imageDownloader = ImageDownloader(defaultImageName: "shuffle", dataTask: ImageDataTask())
    let songViewModel: SongViewModel
    
    var body: some View {
        HStack {
            imageDownloader.storedImage
               .resizable()
               .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .padding()
            VStack(alignment: .leading) {
                Text(songViewModel.title)
                .font(.title)
                Text(songViewModel.artist)
                .font(.headline)
            }.lineSpacing(16)
           Spacer()
        }.onAppear {
            if let url = self.songViewModel.photoUrl {
                self.imageDownloader.getImageFrom(url: url)
            }
        }
    }
}
