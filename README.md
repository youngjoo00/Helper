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
- Singleton pattern, Generic 을 통해 네트워크
- RequestInterceptor 를 활용한 refreshToken 갱신 로직 구현

**NWPathMonitor**

- Monitoring 을 통해 네트워크 상태 감지
- 네트워크 재연결 시 일부 화면 NotificationCenter 를 이용한 API 재호출

**RxSwift + MVVM Input/Output Pattern**

- Model, View, ViewModel 역할 분리
- 비동기성 처리 및 데이터 스트림 처리

**iamport-ios**

- 아임포트를 활용한 WebViewMode 카드 결제 구현

**커서 기반 무한스크롤**

## 트러블슈팅

### NetworkManager  로직 개선

- 다양한 API 가 존재함에 따라 매번 다른 API 호출 메서드를 생성해서 사용해야하는 문제점 발생
- 제네릭, 열거형을 이용하여 하나의 메서드로 Request, Response Model 사용
- Custom APIError 열거형 생성, LocalizedError + Server Error Response 디코딩

### 컨테이너뷰를 통해 자식 VC 생성 시 viewDidLoad 순서

<img width="950" alt="image" src="https://github.com/youngjoo00/Helper/assets/90439413/40d3780d-6b31-4859-a91a-9237c0bae055">

라이브러리 Tabman 을 사용하는 경우, ContaineView 내부에 자식VC 을 생성하며 구현하는 도중 맞닥뜨린 이슈

- 컨테이너뷰로 자식VC 을 넣어서 사용하는 경우, ViewDIdLoad 는 가장 내부에 있는 자식이 먼저 실행됨을 확인

