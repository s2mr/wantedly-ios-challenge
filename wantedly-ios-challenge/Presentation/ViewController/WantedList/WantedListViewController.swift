//
//  WantedListViewController.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WantedListViewController: UIViewController {
	var viewModel: WantedListViewModel?
	let disposeBag = DisposeBag()
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	
	private var incrementalText: Driver<String> {
		return rx
			.methodInvoked(#selector(self.searchBar(_:shouldChangeTextIn:replacementText:)))
			.debounce(0.2, scheduler: MainScheduler.instance)
			.flatMap { [weak self] _ -> Observable<String> in Observable.just(self?.searchBar.text ?? "") }
			.distinctUntilChanged()
			.asDriver(onErrorJustReturn: "")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		bind()
//		viewModel?.fetchWantedList(query: "", shouldReset: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupUI() {
		self.title = "募集一覧"
		self.view.backgroundColor = UIColor(hexString: "#191D1FFF")
		
		searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 14)], for: UIControlState.normal)
		searchBar.barTintColor = UIColor(hexString: "#49A2B8FF")
		if let field: UITextField = searchBar.value(forKey: "_searchField") as? UITextField {
			field.font = UIFont.systemFont(ofSize: 12)
			field.backgroundColor = UIColor(hexString: "#FFFFFF33")
			field.textColor = UIColor.white
			field.attributedPlaceholder = NSAttributedString(string: "地域や特徴など条件を追加",
															 attributes: [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#FFFFFFAA")!])
		}
		
		let nib = R.nib.wantedListCollectionViewCell()
		collectionView.register(nib, forCellWithReuseIdentifier: R.reuseIdentifier.wantedListCollectionViewCell.identifier)
		
		collectionView.keyboardDismissMode = .onDrag
	}
	
	func bind() {
		viewModel = WantedListViewModelImpl()
		
		viewModel?
			.wantedListItems
			.drive()
			.disposed(by: disposeBag)
			
//			.asObservable()
//			.bind(to: self.collectionView.rx.items(cellIdentifier: R.reuseIdentifier.wantedListCollectionViewCell.identifier,
//												   cellType: WantedListCollectionViewCell.self)) {(row, model, cell) in
//				cell.updateCell(viewCount: model.pageView ?? 0,
//								imageUrl: model.imageUrl ?? "",
//								companyLogoUrl: model.companyLogoUrl ?? "",
//								companyName: model.companyName ?? "",
//								title: model.title ?? "",
//								description: model.description ?? "",
//								role: model.lookingFor ?? "")
			}
//			.disposed(by: disposeBag)
	
//		incrementalText
//			.asObservable()
//			.subscribe(onNext: {
//				self.viewModel.fetchWantedList(query: $0, shouldReset: true)
//			},
//					   onError: nil, onCompleted: nil, onDisposed: nil)
//			.disposed(by: disposeBag)
//	}
}

extension WantedListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return true
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}

/*
extension WantedListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel?.wantedListItems.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		UIView.animate(withDuration: 0.4, animations: {
			cell.contentView.alpha = 1
		})
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.row == viewModel.wantedListItems.count - 1 {
			viewModel.fetchWantedList(query: searchBar.text ?? "", shouldReset: false)
		}
		
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.wantedListCollectionViewCell.identifier, for: indexPath) as? WantedListCollectionViewCell
		guard let cell = c else {
			return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.wantedListCollectionViewCell.identifier, for: indexPath)
		}
		let item = viewModel.wantedListItems[indexPath.row]
		cell.updateCell(viewCount: item.pageView ?? 0,
						imageUrl: item.imageUrl ?? "",
						companyLogoUrl: item.companyLogoUrl ?? "",
						companyName: item.companyName ?? "",
						title: item.title ?? "",
						description: item.description ?? "",
						role: item.lookingFor ?? "")
		cell.contentView.alpha = 0
		
		if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available { // For 3DTouch
			registerForPreviewing(with: self, sourceView: cell.contentView)
		}
		
		return cell
	}
}

*/

extension WantedListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		let model = viewModel?.wantedListItems[indexPath.row]
//		let vc = R.storyboard.wantedDetailViewController.instantiateInitialViewController()!
//		vc.viewModel = WantedDetailViewModelImpl(vc, model: model)
//		self.navigationController?.pushViewController(vc, animated: true)
	}
}

extension WantedListViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.bounds.width, height: 300)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
	}
}

//extension WantedListViewController: UIViewControllerPreviewingDelegate {
//	@available(iOS 9.0, *)
//	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//		let point = collectionView.convert(location, from: collectionView.superview!)
//		guard let indexPath = collectionView.indexPathForItem(at: point) else {
//			return nil
//		}
//
//		let vc = R.storyboard.wantedDetailViewController.instantiateInitialViewController()!
//		vc.viewModel = WantedDetailViewModelImpl(vc, model: viewModel.wantedListItems[indexPath.row])
//		return vc
//	}
//
//	@available(iOS 9.0, *)
//	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//		self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
//	}
//}
