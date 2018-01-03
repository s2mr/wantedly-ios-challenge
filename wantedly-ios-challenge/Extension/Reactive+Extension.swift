//
//  Reactive+Extension.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2018/01/03.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
	var reachedBottom: ControlEvent<Void> {
		let observable = contentOffset
			.flatMap { [weak base] contentOffset -> Observable<Void> in
				guard let scrollView = base else {
					return Observable.empty()
				}
				
				let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
				let y = contentOffset.y + scrollView.contentInset.top
				let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
				
				return y > threshold ? Observable.just(Void()) : Observable.empty()
		}
		
		return ControlEvent(events: observable)
	}
}
