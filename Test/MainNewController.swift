
import UIKit
import Combine
import SnapKit

class MainNewController: UIViewController {

    private var cancelled = Set<AnyCancellable>()
    private var articles: [Articles] = []
    private var newViewModel: NewViewModel!
        
    lazy var collectionNewView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        
        collectionview.register(NewViewCell.self, forCellWithReuseIdentifier: NewViewCell.shared)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
    }()
    
    lazy var activatorIndice: UIActivityIndicatorView = {
        let activator = UIActivityIndicatorView(style: .medium)
        activator.translatesAutoresizingMaskIntoConstraints = false
        return activator
    }()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "Helvetica", size: 20)
        text.text = "Search what you want"
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configuration()
        layoutContraintes()
    }
    
    private func subPublished() {
        
        newViewModel.$state
            .sink {[weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    self.activatorIndice.startAnimating()
                case .success(articles: let articles):
                    self.activatorIndice.stopAnimating()
                    self.articles = articles
                    self.collectionNewView.reloadData()
                case .failed(error: let error):
                    self.activatorIndice.stopAnimating()
                    self.alertMessage(error.localizedDescription)
                case .none:
                    break
                }
            }
            .store(in: &cancelled)
    }
    
    private func configuration() {
        view.addSubview(collectionNewView)
        collectionNewView.addSubview(activatorIndice)
        view.addSubview(textLabel)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func layoutContraintes() {

        collectionNewView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activatorIndice.snp.makeConstraints { make in
            make.centerX.equalTo(collectionNewView.snp.centerX)
            make.centerY.equalTo(collectionNewView.snp.centerY)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
    }
}

extension MainNewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewViewCell.shared, for: indexPath) as! NewViewCell
        cell.article = articles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = NewDetailController()
        detail.article = articles[indexPath.item]
        let navigationFull = UINavigationController(rootViewController: detail)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationFull.modalPresentationStyle = .fullScreen
        }
        self.present(navigationFull, animated: true)
    }
}

extension MainNewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {

        let textHeight = requiredHeight(text: articles[indexPath.item].content ?? "", cellWidth: (cellWidth))

        return (textHeight + 10)
    }
    
    func requiredHeight(text: String , cellWidth : CGFloat) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: 17)
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension MainNewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            newViewModel = NewViewModel(textSearch: searchBarText)
            textLabel.isHidden = true
            collectionNewView.isHidden = false
            subPublished()
        } else {
            collectionNewView.isHidden = true
            textLabel.isHidden = false
        }
    }
}
