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
	var itemsVariable: Variable<[WantedListModel]> { get } //FIXME:
	var pushWantedDetailViewController: Driver<WantedListModel> { get }
	var isLoading: Variable<Bool> { get }
}

class WantedListViewModel: WantedListViewModelType {
	var items: Driver<[WantedListModel]> = .never()
	let itemsVariable: Variable<[WantedListModel]> = Variable([])
	var isLoading: Variable<Bool>
	var pushWantedDetailViewController: Driver<WantedListModel> = .never()
	let disposeBag = DisposeBag()
	
	private let page: BehaviorRelay<Int>
	
	enum Event {
		case refresh([WantedListModel])
		case append([WantedListModel])
	}
	
	init(searchingText: Driver<String>, selectedIndexPath: Driver<IndexPath>, reachedToBottom: Driver<Void>) {
		page = BehaviorRelay(value: 0)
		
		let repository = WantedListRepository()
		self.isLoading = Variable(false)
		
		searchingText
			.debounce(0.3)
			.asObservable()
			.subscribe {
				if case .next(_) = $0.event {
					self.page.accept(0)
				}
			}
			.disposed(by: disposeBag)
		
		items = Driver
			.combineLatest(searchingText.asDriver(), page.asDriver())
			.debounce(0.2)
			.flatMap { [unowned self] (query, page) -> Driver<Event> in
				// TODO: error handing
				self.isLoading.value = true
				return repository.findAll(query: query, page: page).asDriver(onErrorDriveWith: .empty())
					.flatMap { Driver.from(optional: $0.model) }
					.map { models -> Event in
						self.isLoading.value = false
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
		
		page
			.subscribe {
				if case .next(let v) = $0.event {
					print("[PAGE]\(v)")
				}
			}
			.disposed(by: disposeBag)
		
		reachedToBottom
			.debounce(0.05)
			.asObservable()
			.subscribe {
				if case .next(_) = $0.event {
					self.page.accept(self.page.value+1)
				}
			}
			.disposed(by: disposeBag)
	}
}
