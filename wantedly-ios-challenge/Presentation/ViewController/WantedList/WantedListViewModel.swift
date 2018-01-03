//
//  WantedListViewModel.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WantedListViewModelType {
	var items: Driver<[WantedListModel]> { get }
	var itemsVariable: Variable<[WantedListModel]> { get }
	var pushWantedDetailViewController: Driver<WantedListModel> { get }
}

class WantedListViewModel: WantedListViewModelType {
	let items: Driver<[WantedListModel]>
	let itemsVariable: Variable<[WantedListModel]> = Variable([])
	let pushWantedDetailViewController: Driver<WantedListModel>
	let disposeBag = DisposeBag()
	
	private let page: BehaviorRelay<Int>
	
	enum Event {
		case refresh([WantedListModel])
		case append([WantedListModel])
	}
	
	init(searchingText: Driver<String>, selectedIndexPath: Driver<IndexPath>) {
		page = BehaviorRelay(value: 0)
		
		let repository = WantedListRepository()
		
		items = searchingText
			.distinctUntilChanged()
			.withLatestFrom(page.asDriver()) { ($0, $1) }
			.flatMap { (query, page) -> Driver<Event> in
				// TODO: error handing
				return repository.findAll(query: query, page: page).asDriver(onErrorDriveWith: .empty())
					.flatMap { Driver.from(optional: $0.model) }
					.map { models -> Event in
						if page == 0 {
							return Event.refresh(models)
						} else {
							return Event.append(models)
						}
				}
			}
			.scan([]) { previousModels, event -> [WantedListModel] in
				switch event {
				case .refresh(let models):
					return models
					
				case .append(let models):
					return previousModels + models
				}
		}
		
		pushWantedDetailViewController = selectedIndexPath
			.withLatestFrom(items) { $1[$0.row] }
		
		items.asObservable().bind(to: itemsVariable).disposed(by: disposeBag)
	}
}
