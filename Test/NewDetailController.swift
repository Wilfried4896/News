
import UIKit
import SnapKit
import SafariServices

class NewDetailController: UIViewController {
    
    var article: Articles? {
        didSet {
            if let article {
                titleLabel.text = article.title
                if let author = article.author {
                    authorLabel.text = "By: " + author
                } else {
                    authorLabel.text = "By: Unknown"
                }
                descriptionLabel.text = article.description
            }
        }
    }
    
    lazy var imagePage = ImagePage(article: article)
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont(name: "Arial Hebrew", size: 18)
        description.numberOfLines = 0
        return description
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Academy Engraved LET", size: 20)
        title.numberOfLines = 0
        return title
    }()
    
    lazy var authorLabel: UILabel = {
        let author = UILabel()
        author.font = UIFont(name: "Helvetica", size: 20)
        author.numberOfLines = 0
        return author
    }()
    
    lazy var readmoreButton: UIButton = {
        let readmore = UIButton(type: .system)
        readmore.addTarget(self, action: #selector(readmoreInfomation), for: .touchUpInside)
        readmore.setTitle("Read More", for: .normal)
        readmore.setTitleColor(.systemBlue, for: .normal)
        return readmore
    }()
    
    private var originalHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 450
        default:
            return 500
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupConfigurations()
        layoutContriants()
    }
    
    fileprivate func setupConfigurations() {
        
        view.addSubview(titleLabel)
        view.addSubview(imagePage)
        view.addSubview(authorLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(readmoreButton)
        
        
        let closeAction = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeViewController))
        
        navigationItem.rightBarButtonItem = closeAction
    }
    
    fileprivate func layoutContriants() {
        imagePage.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(originalHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imagePage.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        readmoreButton.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.bottom).offset(50)
            make.trailing.equalToSuperview().inset(10)
        }
        
    }
    
    @objc private func closeViewController() {
        dismiss(animated: true)
    }
    
    @objc private func readmoreInfomation() {
        if let url = URL(string: (article?.url)!) {
            let sfSafariVC = SFSafariViewController(url: url)
            present(sfSafariVC, animated: true)
        }
    }
}
