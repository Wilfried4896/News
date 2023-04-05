
import UIKit
import Combine
import SnapKit

class ImagePage: UIView {
    
    var cancelled = Set<AnyCancellable>()
    var newViewModel = NewService()
    
    var article: Articles? {
        didSet {
            if let article {
                activityIndicator.startAnimating()
                titleLabel.text = article.source.name
                if let time = article.publishedAt {
                    yearLabel.text = time.stringToTime
                }
                
                if let image = article.urlToImage {
                    newViewModel.getImageFromServer(urlImage: image)
                        .sink { completion in
                            switch completion {
                            case .failure(_):
                                self.activityIndicator.stopAnimating()
                            default:
                                break
                            }
                        } receiveValue: { data in
                            self.activityIndicator.stopAnimating()
                            self.imageNew.image = UIImage(data: data)
                            self.filmBackgroundImageView.image = UIImage(data: data)
                        }
                        .store(in: &cancelled)
                }
            }
        }
    }
    
    lazy var filmBackgroundImageView: UIImageView = {
        let filmBackgroundImage = UIImageView()
        filmBackgroundImage.backgroundColor = .systemGray6
        filmBackgroundImage.contentMode = .scaleAspectFill
        filmBackgroundImage.clipsToBounds = true
        return filmBackgroundImage
    }()
    
    lazy var filmBackgroundBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let filmBackgroundBlur = UIVisualEffectView(effect: blurEffect)
        return filmBackgroundBlur
    }()
    
    lazy var imageNew: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.backgroundColor = .systemGray5
        
        image.layer.shadowOffset = CGSize.zero
        image.layer.shadowOpacity = 0.5
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.adjustsFontForContentSizeCategory = true
        title.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2 ).pointSize, weight: .semibold)
        title.textColor = .secondaryLabel
        return title
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    required init(article: Articles?) {
        
        super.init(frame: .zero)
        defer {
            self.article = article
        }
        setupCOnfigurations()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCOnfigurations() {
        
        addSubview(filmBackgroundImageView)
        filmBackgroundImageView.addSubview(filmBackgroundBlurView)
        
        addSubview(imageNew)
        addSubview(titleLabel)
        addSubview(yearLabel)
        
        imageNew.addSubview(activityIndicator)
        
        filmBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filmBackgroundBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageNew.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25 + 44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageNew.snp.bottom).offset(30)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(imageNew)
        }
    }
}
