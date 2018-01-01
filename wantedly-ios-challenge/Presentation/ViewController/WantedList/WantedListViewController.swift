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
	var viewModel: WantedListViewModel!
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
		viewModel.fetchWantedList(query: "", shouldReset: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupUI() {
		self.title = "募集一覧"
		
		let nib = R.nib.wantedListCollectionViewCell()
		collectionView.register(nib, forCellWithReuseIdentifier: R.reuseIdentifier.wantedListCollectionViewCell.identifier)
		
		collectionView.keyboardDismissMode = .onDrag
	}
	
	func bind() {
		incrementalText
			.asObservable()
			.subscribe(onNext: {
				self.viewModel.fetchWantedList(query: $0, shouldReset: true)
			},
					   onError: nil, onCompleted: nil, onDisposed: nil)
			.disposed(by: disposeBag)
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

extension WantedListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.wantedListItems.count
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
		return cell
	}
}

extension WantedListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let model = viewModel.wantedListItems[indexPath.row]
		let vc = R.storyboard.wantedDetailViewController.instantiateInitialViewController()!
		vc.viewModel = WantedDetailViewModelImpl(vc, model: model)
		self.navigationController?.pushViewController(vc, animated: true)
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
