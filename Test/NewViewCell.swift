
import UIKit
import Combine
import SnapKit

class NewViewCell: UICollectionViewCell {

    static let shared = "NewViewCell"

    var article: Articles? {
        didSet {
            if let article {
                if let name = article.source.name {
                    titleLabel.text = name
                } else {
                    titleLabel.text = "Unknown"
                }
                descriptionLabel.text = article.description
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return title
    }()
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.numberOfLines = 0
        description.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return description
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        
    }
    
    private func configuration() {
        layer.borderColor =  UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
//        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        
        descriptionLabel.sizeToFit()
//        titleLabel.sizeToFit()

//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(contentView).inset(5)
//            make.leading.trailing.equalTo(contentView).inset(5)
//        }
        
        descriptionLabel.snp.makeConstraints { make in
            //make.top.top.equalTo(titleLabel.snp.bottom)
            make.top.leading.bottom.trailing.equalTo(contentView).inset(5)
        }
    }
}
