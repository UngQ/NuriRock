
# 🇰🇷 NuriROCK(樂) - 한국을 즐기자!

- 프로젝트 기간: 2024. 03. 08. ~ 2024. 03. 24.
- App Store 출시작 [(링크)](https://apps.apple.com/kr/app/nurirock-%E6%A8%82-%ED%95%9C%EA%B5%AD%EC%9D%84-%EC%A6%90%EA%B8%B0%EC%9E%90/id6479728531)

![nurirock](https://github.com/UngQ/NuriRock/assets/106305918/86597b10-e6ba-442d-864c-bc587e8da5f7)

## 🗒️ Introduction

- 한국의 주요 도시들의 관광지, 맛집 등을 쉽게 검색하고 북마크에 저장하여 여행에 도움을 줄 수 있는 어플
- Configuration: iOS 16.0+
- 다국어(한국어, 영어) 적용
- 다크모드 지원

## 🗒️ Features

- 한국 주요 도시별, 관광 카테고리별 검색 기능
- 원하는 날짜에 진행하는 축제, 공연, 행사 검색 기능
- 키워드로 관광지 검색 및 기록 저장 기능
- 관광지 북마크 저장 기능
- 관광지 디테일 정보 확인 기능
- 자신의 위치와 선택한 관광지의 거리 확인 기능

## 🗒️ Technology Stack

- Framework
    - **Code Base UIKit**
      
- Pattern
    - **MVVM**
      - UI와 비즈니스 로직을 분리하여 유지보수와 테스트가 용이하도록 하기 위해 MVVM 패턴을 사용
    
- Library
  - **데이터베이스**
    - **Realm**
      - 데이터와 UI간의 동기화 및 앱의 응답 속도를 향상시키를 위해 사용

  - **백엔드 서비스**
    - **Firebase**
      - 메시징 및 오류 보고를 수집하기 위해 사용 

  - **네트워크**
    - **Alamofire**
      - 네트워크 요청을 간편하고 효율적으로 처리하기 위해 사용
        
  - **이미지 처리**     
    - **Kingfisher**
      - 이미지를 다운로드하고 캐싱하는 작업을 간편하게 처리하기 위해 사용

  - **UI 구성**
    - **Tabman**
      - 직관적이고 사용하기 쉬운 탭 인터페이스를 제공하기 위해 사용
    - **Snapkit**
      - 오토 레이아웃을 코드로 쉽게 작성하고 관리하기 위해 사용
    - **Toast**
      - 사용자에게 간단한 팝업 메시지를 표시하여 인터페이스를 직관적으로 만들기 위해 사용
    - **SVProgressHUD**
      - 더 직관적으로 로딩에 대한 HUD 표시를 위해 사용
    - **FSCalendar**
      - Customize가 용이한 캘린더를 위해 사용
    
## 💬 Description
### 1. ImageView에 RxGesture 적용, Double Tapped시 좋아요👍🏻/싫어요👎🏻
   
https://github.com/UngQ/BuyOrNot/assets/106305918/6496eae7-2f06-47cd-b9ce-7ce43137842d
- 이미지의 가운데 x좌표를 0으로 가정, 왼쪽 영역(x < 0)을 더블탭하면 "좋아요", 오른쪽 영역(x > 0)을 더블탭하면 "싫어요" 기능이 동작하도록 구현
- 동일한 영역에 다시 투표할 경우 기존 투표를 취소
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  cell.postImageView.rx.tapGesture(configuration: { gestureRecognizer, delegate in
				gestureRecognizer.numberOfTapsRequired = 2 })
			.when(.recognized)
			.subscribe(onNext: { [weak self] gesture in
				let touchPoint = gesture.location(in: gesture.view)
				if let width = gesture.view?.bounds.width {
					if touchPoint.x < width / 2 {
						likeButtonTapped.onNext(row)
						self?.playAppropriateAnimation(for: "like", likeCondition: cell.like, dislikeCondition: cell.dislike)
					} else {
						disLikeButtonTapped.onNext(row)
						self?.playAppropriateAnimation(for: "dislike", likeCondition: cell.like, dislikeCondition: cell.dislike)
					}
				}
			})
			.disposed(by: cell.disposeBag)
  ```
    
</details>

### 2. MVVM의 효과적인 활용도를 높이기 위한 `ViewModel` Protocl 정의
- ViewModel의 인터페이스를 명확하게 정의하여 일관된 구조 유지
- Input, Output 타입을 통하여 입, 출력 명확
- RxSwift의 disposeBag을 사용한 메모리 관리
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  protocol ViewModelType {

	associatedtype Input
	associatedtype Output

	var disposeBag: DisposeBag { get set }

	func transform(input: Input) -> Output
  }
  ```
    
</details>

### 3. Router Pattern 적용하여, 효과적으로 30개 이상의 API 통신 관리
- TargetType 프로토콜과 Router 열거형을 사용하여 다양한 API 엔드포인트를 정의하고, 각 요청의 세부 사항을 설정
- 네트워크 요청을 하나의 Router 열거형으로 관리함으로써 코드의 모듈화와 재사용성을 높임
- 새로운 API 엔드포인트를 추가할 때 Router 열거형에 새로운 케이스를 추가하고 필요한 속성을 정의하면 되므로, 확장성이 뛰어남
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  protocol TargetType: URLRequestConvertible {
	var baseURL: String { get }
	var method: HTTPMethod { get }
	var path: String { get }
	var header: [String: String] { get }
	var parameters: String? { get }
	var queryItems: [URLQueryItem]? { get }
	var body: Data? { get }
  }

  enum Router {
	case tokenRefresh
  }

  extension Router: TargetType {
      ...
  }

  ```
    
</details>

### 4. RxSwift의 retry(when:)을 이용한 토큰 갱신 및 통신 재시도
- 네트워크 요청이 AccessToken 만료 오류인 HTTP 상태 코드 419로 실패할 경우, RefreshToken을 이용하여 토큰을 갱신하고 원래의 요청을 다시 시도
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  static func performRequest<T: Decodable>(route: Router, decodingType: T.Type?) -> Single<T> {
    return Single<T>.create { single in
        do {
            let urlRequest = try route.asURLRequest()

            AF.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let result):
                        single(.success(result))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
        } catch {
            single(.failure(error))
        }

        return Disposables.create()
    }
    .retry(when: { errors in
        errors.flatMap { error -> Single<Void> in
            guard let afError = error as? AFError, afError.responseCode == 419 else {
                throw error
            }
            return refreshToken().flatMap { _ in
                performRequest(route: route, decodingType: T.self).map { _ in Void() }
            }
        }
    })
  }
  ```

    - performRequest<T: Decodable>: 주어진 라우트에 따라 네트워크 요청을 수행하고, 결과를 Single<T>로 반환합니다.
    - 요청이 실패하면 retry(when:) 연산자가 실행되어 오류를 검사합니다.
    - 오류가 HTTP 419 상태 코드인 경우 refreshToken() 메서드를 호출하여 토큰을 갱신합니다.
    - 토큰이 갱신되면 원래의 요청을 다시 시도합니다.
    - refreshToken(): 토큰 갱신을 처리하는 메서드로, 성공적으로 토큰이 갱신되면 Single<Void>를 반환하여 재시도를 허용합니다. 실패하면 오류를 발생시켜 재시도를 중단하고 로그인 창으로 이동하도록 합니다.

    
</details>

### 5. SocketIO 활용한 실시간 채팅 구현
- 소켓 연결 상태를 일관되게 유지하기 위하여 Singleton Pattern 적용
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  final class SocketIOManager {

	static var shared: SocketIOManager = SocketIOManager()

	var manager: SocketManager?
	var socket: SocketIOClient?

	let baseURL = URL(string: "\(APIKey.baseURL.rawValue)/v1")!

	var receivedChatData = PassthroughSubject<ChatContentModel, Never>()

	private init() {}

	func fetchSocket(roomId: String) {
		manager = SocketManager(socketURL: baseURL, config: [.log(true), .compress])

		socket = manager?.socket(forNamespace: "/chats-\(roomId)")

		socket?.on(clientEvent: .connect) { data, ack in
			print("socket connected", data, ack)
		}

		socket?.on(clientEvent: .disconnect) { data, ack in
			print("socket disconnected", data, ack)
		}

		socket?.on("chat") { dataArray, ack in
			print("chat received", dataArray, ack )

			if let data = dataArray.first {
				 do {
  					let result = try JSONSerialization.data(withJSONObject: data)
         				let decodedData = try JSONDecoder().decode(ChatContentModel.self, from: result)
  					self.receivedChatData.send(decodedData)
      				} catch {
            				print(error.localizedDescription)
       				}
			}
		}
	}

	func establishConnection() {
		socket?.connect()
	}

	func leaveConnection() {
		socket?.disconnect()
	}
  
  }
  ```
    
</details>

### 6. @propertyWrapper를 활용한 UserDefaults 캡슐화
- 자주 사용되는 UserDefaults 의 상용구 코드를 줄이고 가독성을 높이기 위하여 구현
- @propertyWrapper 속성을 적용한 MyDefaults 구조체 생성 후 UserDefaultsManager 정의
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  @propertyWrapper
  struct MyDefaults<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
  }

  enum UserDefaultsManager {

    enum Key: String {
        case userId
        ...
    }

    @MyDefaults(key: Key.userId.rawValue, defaultValue: "")
    static var userId: String
    ...
  }

  //기존 사용법
  UserDefaults.standard.string(forKey: UserDefaultsKey.userId.key) ?? ""

  //개선된 사용법
  let myId = UserDefaultsManager.userId //get
  UserDefaultsManager.userId = "변경된닉네임" //set
  ```
    
</details>

### 7. Reactive를 extension하여, Cursor-based Pagination 구현
- Base가 UIScrollView 타입인 경우, UIScrollView가 바닥에서 400 포인트에 도달할 때마다 이벤트를 방출하는 reachedBottom 프로퍼티를 정의
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  extension Reactive where Base: UIScrollView {
	var reachedBottom: Observable<Void> {
		return contentOffset
			.debounce(.milliseconds(100), scheduler: MainScheduler.instance)
			.flatMap { [weak base] _ -> Observable<Void> in
				guard let scrollView = base else { return .empty() }
				let contentHeight = scrollView.contentSize.height
				let scrollViewHeight = scrollView.bounds.size.height
				let scrollPosition = scrollView.contentOffset.y + scrollViewHeight
				let threshold = contentHeight - 400
				if scrollPosition >= threshold {
					return .just(())
				} else {
					return .empty()
				}
			}
	}
  }

  ```
    
</details>

## 🎮 주요기능 UI

|![회원가입-탈퇴](https://github.com/UngQ/BuyOrNot/assets/106305918/bf3eac4e-b716-4d4a-a7a8-4d834992be02)|![자동로그인](https://github.com/UngQ/BuyOrNot/assets/106305918/7e1bb436-695b-4c23-ba44-a97a26b29437)|![프로필수정](https://github.com/UngQ/BuyOrNot/assets/106305918/4063fbf8-b3bc-40b1-a723-f7ec3e379997)|![게시글작성-삭제](https://github.com/UngQ/BuyOrNot/assets/106305918/6abe442d-5266-4b6c-a485-2f33f7d16d1a)|
|:--:|:--:|:--:|:--:|
|회원가입 ~ 탈퇴|Keychain 활용한 자동로그인|프로필 수정|포스트 CRUD|

|![Simulator Screen Recording - iPhone 15 Pro - 2024-05-05 at 11 05 03](https://github.com/UngQ/BuyOrNot/assets/106305918/1b06e0a5-432c-483b-8684-9a5f1dfc976a)|![내프로필](https://github.com/UngQ/BuyOrNot/assets/106305918/5cdcfa4e-f32a-4230-922a-38666f0f9891)|![다른프로필](https://github.com/UngQ/BuyOrNot/assets/106305918/6d5e2610-a853-4ca8-9da3-99c80a76dd61)|![팔로우](https://github.com/UngQ/BuyOrNot/assets/106305918/c0d82806-0adb-46dc-95de-a3bd31c045e7)|
|:--:|:--:|:--:|:--:|
|포스트 좋아요/싫어요|내 프로필 조회<br>(내 게시글, 좋아요/싫어요한 게시글, 결제내역 조회)|다른 유저 프로필 조회|팔로우|

|![카테고리조회-사용자별조회](https://github.com/UngQ/BuyOrNot/assets/106305918/fa9d0656-0ee1-4a96-87ff-9bcaa4cdb411)|![댓글](https://github.com/UngQ/BuyOrNot/assets/106305918/13d22eb9-6ff6-4a4a-8e19-6a536a1e7209)|![Simulator Screen Recording - iPhone 15 Pro - 2024-05-05 at 20 07 20](https://github.com/UngQ/BuyOrNot/assets/106305918/c98d45f5-a6be-44a0-aa6f-3272005e1947)|
|:--:|:--:|:--:|
|게시물 조회|댓글 작성, 삭제, 수정|결제 기능|

### - 채팅 기능 ( Updated at 2024. 05. 24. )

|![Simulator Screen Recording - iPhone 15 Pro - 2024-05-24 at 12 38 06](https://github.com/UngQ/BuyOrNot/assets/106305918/611aa623-8a7c-48b6-b583-c4cb8e27cdeb)|![Simulator Screen Recording - iPhone 15 Pro - 2024-05-24 at 12 38 45](https://github.com/UngQ/BuyOrNot/assets/106305918/fa615597-3659-403b-821c-4577c289fee8)|
|:--:|:--:|
|내 채팅방 목록|다른유저 프로필에서 채팅방 진입|



![20240402_123148_1](https://github.com/UngQ/NuriRock/assets/106305918/6e012976-2ecf-48c7-b651-93d10ebc6471)


