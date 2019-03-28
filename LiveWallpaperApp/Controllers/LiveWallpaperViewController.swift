import UIKit
import SDWebImage
import SwiftyJSON

class LiveWallpaperViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var rowForPaggination: Int {
        return liveWallpapersList.count - 3
    }
    
    var liveWallpapersList: [LiveWallpaper] = []
    var links: LWLinks!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLivePhotos()
    }

    // MARK: - methods
    
    func getLivePhotos() {
        APIManager.shared.getLivePhotos { (success, json, error) in
            if success {
                self.parseJSON(json)
                print(self.liveWallpapersList)
                self.collectionView.reloadData()
            } else {
                print("error: \(error)")
            }
        }
    }
    
    func getMorePhotos() {
        if let links = links, let next = links.next, let url = URL(string: next) {
            APIManager.shared.getLivePhotoWith(url: url) { (success, json, error) in
                self.parseJSON(json)
                self.collectionView.reloadData()
            }
        }
    }
    
    func parseJSON(_ json: JSON) {
        if let json = json["data"].array {
            json.forEach({ (item) in
                if let dict = item.dictionaryObject {
                    let liveWallPaper = LiveWallpaper(JSON: dict)
                    if let liveWallPaper = liveWallPaper {
                        self.liveWallpapersList.append(liveWallPaper)
                    }
                }
            })
        }
        
        if let dict = json["links"].dictionaryObject {
            print(dict)
            self.links = LWLinks(JSON: dict)
        }
    }
}

// MARK: - extensions

extension LiveWallpaperViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveWallpapersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiveWallpaperCell
        
        if let date = Date().setFromString(str: liveWallpapersList[indexPath.row].created ?? "")?.formatted {
            cell.labelDate.text = "Created: " + date
        }
        
        if let path = liveWallpapersList[indexPath.row].imagePath, let url = URL(string: path) {
            cell.imageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == rowForPaggination {
            getMorePhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthForSpacing = CGFloat(30)
        let height = CGFloat(300)
        return CGSize(width: (collectionView.bounds.size.width - widthForSpacing) / 2, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "LivePhotoVC") as! LivePhotoViewController
        controller.liveWallpaper = liveWallpapersList[indexPath.row]
        present(controller, animated: true, completion: nil)
    }
}
