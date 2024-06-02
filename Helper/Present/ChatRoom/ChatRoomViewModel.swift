//
//  ChatRoomViewModel.swift
//  Helper
//
//  Created by youngjoo on 6/2/24.
//

import RxSwift
import RxCocoa

final class ChatRoomViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let roomList: Driver<[ChatResponse.RoomData]>
    }
    
    func transform(input: Input) -> Output {
        
        let roomList = PublishRelay<[ChatResponse.RoomData]>()
        
        input.viewWillAppearTrigger
            .flatMap { NetworkManager.shared.callAPI(type: ChatResponse.RoomList.self, router: Router.chat(.roomList)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    roomList.accept(data.data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(roomList: roomList.asDriver(onErrorJustReturn: []))
    }
    
}
