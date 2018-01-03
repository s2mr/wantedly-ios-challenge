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

final class WantedListViewController: UIViewController {
	static func make() -> WantedListViewController {
		return R.storyboard.wantedListViewController.instantiateInitialViewController()!
	}
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var viewModel: WantedListViewModelType!
	let disposeBag = DisposeBag()
	
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
		viewModel = WantedListViewModel(
			searchingText: searchBar.rx.text.orEmpty.asDriver(),
			selectedIndexPath: collectionView.rx.itemSelected.asDriver()
		)
		
		setupUI()
		bind()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
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
		let cellIdentifier = R.reuseIdentifier.wantedListCollectionViewCell.identifier
		viewModel.items
			.drive(collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: WantedListCollectionViewCell.self)) { row, model, cell in
				if row == self.viewModel.itemsVariable.value.count-1 {
					self.viewModel.reachedToBottom()
				}
				cell.contentView.alpha = 0
				cell.updateCell(listModel: model)
				if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available { // For 3DTouch
					self.registerForPreviewing(with: self, sourceView: cell.contentView)
				}
			}
			.disposed(by: disposeBag)
		
		viewModel.pushWantedDetailViewController
			.drive(onNext: { [weak self] listModel in
				self?.pushWantedDetailViewController(with: listModel)
			})
			.disposed(by: disposeBag)
		
//		incrementalText
//			.asObservable()
//			.subscribe(onNext: {
//				self.viewModel.fetchWantedList(query: $0, shouldReset: true)
//			},
//					   onError: nil, onCompleted: nil, onDisposed: nil)
//			.disposed(by: disposeBag)
	}
	
	private func pushWantedDetailViewController(with listModel: WantedListModel) {
		let viewController = WantedDetailViewController.make(listModel: listModel)
		navigationController?.pushViewController(viewController, animated: true)
	}
}

extension WantedListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		UIView.animate(withDuration: 0.4, animations: {
			cell.contentView.alpha = 1
		})
	}
}

extension WantedListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return true
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
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

extension WantedListViewController: UIViewControllerPreviewingDelegate {
	@available(iOS 9.0, *)
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		let location = CGPoint(x:location.x, y:location.y)
		let point = collectionView.convert(location, from: self.view)
		guard let indexPath = collectionView.indexPathForItem(at: point) else {
			return nil
		}

		guard let model = viewModel?.itemsVariable.value[indexPath.row] else {
			return nil
		}
		
		let vc = WantedDetailViewController.make(listModel: model)
		
		return vc
	}

	@available(iOS 9.0, *)
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
	}
}
