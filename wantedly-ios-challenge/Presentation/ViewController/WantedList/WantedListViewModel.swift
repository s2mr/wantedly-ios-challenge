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
	var items: Variable<[WantedListModel]> { get }
	var occuredError: Variable<Error?> { get }
	var pushWantedDetailViewController: Driver<WantedListModel> { get }
	var isLoading: Variable<Bool> { get }
}

final class WantedListViewModel: WantedListViewModelType {
	let items: Variable<[WantedListModel]>
	var occuredError: Variable<Error?>
	var pushWantedDetailViewController: Driver<WantedListModel>
	var isLoading: Variable<Bool>
	private let page: BehaviorRelay<Int>
	private let disposeBag = DisposeBag()
	
	private enum Event {
		case refresh([WantedListModel])
		case append([WantedListModel])
	}
	
	init(searchingText: Driver<String>, selectedIndexPath: Driver<IndexPath>, reachedToBottom: Driver<Void>) {
		let repository = WantedListRepository()
		
		self.page = BehaviorRelay(value: 0)
		self.items = Variable([])
		self.isLoading = Variable(false)
		self.occuredError = Variable(nil)
		self.pushWantedDetailViewController = .never()
		
		searchingText
			.debounce(0.3)
			.asObservable()
			.subscribe {
				if case .next(_) = $0.event {
					self.page.accept(0)
				}
			}
			.disposed(by: disposeBag)
		
		Observable.combineLatest(searchingText.asObservable(), page.asObservable())
			.debounce(0.2, scheduler: SerialDispatchQueueScheduler(qos: .default))
			.flatMap { [unowned self] (query, page) -> Driver<Event> in
				self.isLoading.value = true
				return repository.findAll(query: query, page: page)
					.do { self.isLoading.value = false }
					.asDriver(onErrorRecover: { error -> Driver<WantedListAPIResult> in
						self.occuredError.value = error
						return .empty()
					})
					.flatMap {
						Driver.from(optional: $0.model)
					}
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
			.bind(to: items)
			.disposed(by: disposeBag)
		
		self.pushWantedDetailViewController = selectedIndexPath
			.withLatestFrom(items.asDriver()) { $1[$0.row] }
		
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
