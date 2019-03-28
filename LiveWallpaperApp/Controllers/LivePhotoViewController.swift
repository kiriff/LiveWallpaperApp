
import UIKit
import Photos
import PhotosUI
import MobileCoreServices

class LivePhotoViewController: UIViewController, PHLivePhotoViewDelegate {

    typealias Completion = (Bool, URL?, URL?) -> ()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var liveWallpaper: LiveWallpaper!
    var livePhotoIsAnimating = Bool()
    var resourcesForSave: LivePhoto.LivePhotoResources!
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - methods
    
    func initialSetup() {
        if let imageUrl = liveWallpaper.imagePath, let videoUrl = liveWallpaper.moviePath {
            let activityIndicator = setActivityIndicatorFor(view: mainView)
            saveToDocuments(imageUrl: imageUrl, videoImageUrl: videoUrl) { (success, imagePath, videoPath)  in
                if success {
                    self.initLivePhotoView(imagePath: imagePath!, videoPath: videoPath!)
                    activityIndicator.stopAnimating()
                } else {
                    activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func saveToDocuments(imageUrl: String, videoImageUrl: String, completion: @escaping Completion){
        DispatchQueue.global(qos: .background).async {
            if let videoUrl = URL(string: videoImageUrl),
                let imageUrl = URL(string: imageUrl),
                let urlVideoData = NSData(contentsOf: videoUrl),
                let urlImageData = NSData(contentsOf: imageUrl) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let videoFilePath="\(documentsPath)/tempVideoFile.mov"
                let imageFilePath="\(documentsPath)/tempImageFile.jpg"
                
                let photoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("tempImageFile.jpg")
                let videoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("tempVideoFile.mov")
                
                print(photoURL, videoURL)
                
                DispatchQueue.main.async {
                    urlVideoData.write(toFile: videoFilePath, atomically: true)
                    urlImageData.write(toFile: imageFilePath, atomically: true)
                    print("Video and image is saved!")
                    completion(true, photoURL, videoURL)
                }
            } else {
                completion(false, nil, nil)
            }
        }
    }
    
    func initLivePhotoView(imagePath: URL, videoPath: URL) {
        let photoView: PHLivePhotoView = PHLivePhotoView.init(frame: self.mainView.bounds)
        photoView.contentMode = .scaleAspectFit
        
        self.mainView.addSubview(photoView)
        self.mainView.sendSubviewToBack(photoView)
        
        LivePhoto.generate(from: imagePath, videoURL: videoPath, progress: { (percent) in }) { (livePhoto, resources) in
            photoView.livePhoto = livePhoto
            self.resourcesForSave = resources
            photoView.startPlayback(with: .full)
        }
    }

    // MARK: - IBActions
    
    @IBAction func tapBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSave(_ sender: UIButton) {
        if resourcesForSave != nil {
            LivePhoto.saveToLibrary(resourcesForSave) { (success) in
                self.showAlert(title: "Save to library", message: "Save completed!")
            }
        }
    }
    
    // MARK: - PHLivePhotoViewDelegate
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        self.livePhotoIsAnimating = true
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        self.livePhotoIsAnimating = false
    }
}
