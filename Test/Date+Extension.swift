
import Foundation

extension String {
    var stringToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var time = String()
        let format = dateFormatter.date(from: self)
        if let format {
            dateFormatter.dateFormat = "EEEE, HH:mm"
            time = dateFormatter.string(from: format)
        }
        return time
    }
}
