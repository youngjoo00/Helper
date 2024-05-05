# **Helper**

### 잃어버린 것들을 찾거나 찾아주며, 도움을 주고 받는 앱 “Helper”

### 스크린샷

<img width="1500" alt="사진" src="https://github.com/youngjoo00/Helper/assets/90439413/87c02794-6d73-466c-b09e-ffd1c76dabad">

### **앱 기능**

1. 사람/동물/물품 분실, 목격 게시판
    - 찾고 있거나, 찾은 대상을 게시판에 작성하여 제보할 수 있습니다.
2. 피드 게시판
    - 찾는 것과 관련된 주요 기능 목적 이외에도 일상과 관련된 게시물을 작성할 수 있습니다.
3. 사용자 팔로우
    - 다른 사용자와 팔로우 관계를 맺고, 최근 일주일간 작성한 게시물을 확인할 수 있습니다.
4. 사례금
    - 결제 기능을 이용하여 찾았어요 게시판에 사례금을 전송 할 수 있습니다.

### **개발환경**

- 개발 기간: 2024.04.09 - 05.05 (약 4주)
- 기획/디자인/개발 - 1인
- 최소 버전: iOS 16.0
- 지원 모드: Light 모드 지원
- IDE: Xcode 15.3

### **Dependency Manager**

- Swift-Package-Manager

## 기술 스택

### **FrameWork**

- UIKit
- NWPathMonitor
- WebKit

### **Library**

- Alamofire
- Kingfisher
- Tabman
- Snapkit
- Then
- Toast
- RxSwift
- IQKeyBoardManagerSwift
- Hero
- iamport-ios

## **고려사항**

**Alamofire**

- Router Pattern 을 통해 네트워크 통신을 위한 Endpoint 생성 로직 추상화
- Singleton pattern, Generic, Result Type 을 통해 네트워크 

**NWPathMonitor**

- 애플 프레임워크
- Monitoring 을 통해 전역적으로 네트워크 상태 감지

**RxSwift + MVVM Input/Output Pattern**

- Model, View, ViewModel 역할 분리
- 비동기성 처리 및 데이터 스트림 처리

**Search**

- Cursor 기반 무한스크롤

## 트러블슈팅
