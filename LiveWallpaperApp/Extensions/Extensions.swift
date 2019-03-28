import Foundation
import UIKit
import NVActivityIndicatorView

extension Date {
    var formatted: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "en_EN")
        dateFormatterPrint.dateFormat = "d MMM yyyy HH:mm"
        
        return dateFormatterPrint.string(from: self)
    }
    
    func setFromString(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: str) else {
            return nil
        }
        return date
    }
}

extension UIViewController {
    func setActivityIndicatorFor(view: UIView) -> NVActivityIndicatorView {
        let sizeActivity = CGFloat(30)
        let xActivity = view.center.x - sizeActivity / 2
        let yActivity = view.center.y - sizeActivity / 2
        let activity = NVActivityIndicatorView(frame: CGRect(x: xActivity, y: yActivity, width: sizeActivity, height: sizeActivity), type: .circleStrokeSpin, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), padding: 2)
        view.addSubview(activity)
        activity.startAnimating()
        return activity
    }
    
    func createActivityIndicator() -> NVActivityIndicatorView {
        let activity = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), padding: 2)
        return activity
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
