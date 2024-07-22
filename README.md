
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
### 1. Optimistic UI 적용



|![Simulator Screen Recording - iPhone 15 Pro - 2024-03-30 at 11 30 43](https://github.com/user-attachments/assets/f9809f88-bee7-49e6-b78f-d9523eb5ea24)|!![Simulator Screen Recording - iPhone 15 Pro - 2024-03-31 at 17 20 56](https://github.com/user-attachments/assets/1d94bc50-3784-40ce-a854-b6a7b95dbcf1)|
|:--:|:--:|
|적용 전|적용 후|

- 사용자 입장을 고려하여 북마크시 Incidator를 구현하였지만, 오히려 너무 잦은 Indicator 남용으로 인해 사용자에게 스트레스를 줄 것
- 게다가 이번 프로젝트에 사용한 한국관광공사 API 는 가끔 서버통신이 잘 안될때가 있어서 잦은 Indicator 는 사용자 입장에서 더 답답함
- [관련 개인 포스팅](https://ungq.tistory.com/6)
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  @objc private func bookmarkButtonClickedInBottomCV(\_ sender: UIButton) {

    guard let data = viewModel.outputFestivalData.value?.response.body.items?.item?[sender.tag] else {
        return }
    // 북마크 상태 확인
    let isBookmarked = viewModel.repository.isBookmarked(contentId: data.contentid)

    // Optimistic UI 업데이트
    sender.setImage(UIImage(systemName: isBookmarked ? "bookmark" : "bookmark.fill"), for: .normal)

    // 북마크 상태에 따라 북마크 추가 또는 삭제
    if isBookmarked {
        viewModel.repository.deleteBookmark(data: data)
        // 삭제 후 UI 업데이트 필요 없음
    } else {
        viewModel.repository.addBookmark(id: data.contentid) { success in
            DispatchQueue.main.async {
                if !success {
                    // 요청 실패 시 UI 되돌리기
                    sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    // 실패 피드백 제공
                }
            }
        }
    }
  ```
    
</details>

### 2. accessibilityIdentifier을 활용한 DiffableDatasource + Realm 구현
- 북마크 삭제시 Button.tag들은 기존 tag 값들을 그대로 가지고 있어서 Item들의 row 값과 tag 값의 불일치 발생
- indexPath 기반이 아닌, identifier을 이용하여 셀 삭제 기능을 구현하니, tag 불일치, 애니메이션 효과 등 모든 문제점이 해결 되었으며 DiffableDatasource에 더 효율적
  <details>
  <summary><b>주요코드</b></summary>

  ```swift

    //기존 코드
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ResultCollectionViewCell, Bookmark> { (cell, indexPath, identifier) in
            cell.updateUIInBookmarkVC(identifier)

            cell.bookmarkButton.tag = indexPath.item
            cell.bookmarkButton.addTarget(self, action: #selector(self.bookmarkButtonClicked), for: .touchUpInside)
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)

            ...
    }

    @objc private func bookmarkButtonClicked(_ sender: UIButton) {
        viewModel.repository.deleteBookmarkInBookmarkView(data: Array(viewModel.outputBookmarks.value ?? [])[sender.tag])

    }

    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Bookmark>()

        snapshot.appendSections([.main])

        let bookmarks = viewModel.outputBookmarks.value ?? []

        snapshot.appendItems(bookmarks, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: true) //reloadData
        self.updateMapView(with: bookmarks)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.bookmarkCollectionView.reloadData()
        }
    }

    //변경 코드
    cell.bookmarkButton.accessibilityIdentifier = identifier.contentid
  ```
    
</details>

### 3. 한국관광공사 API 서버 상태 불안정으로 인한 네트워크 통신 실패시, 재호출 구현
- 서버가 불안정하여 시간대에 따라, 같은 Parameter로 호출을 하여도 네트워크 통신이 실패하는 경우가 잦음 (평균 새벽에는 3번 호출시 1번 실패, 오후에는 100번 호출시 1번 실패)
- Error확인 결과, Routing Error 로 확인되었으며 제가 아닌 Server에서 해결해줘야 하는 문제 (한국관광공사 API를 제공해주는 공공데이터포털에 문의해보았지만, 이 문제를 인지하고 있으나 당장은 해결하지 못 한다는 답변)
- 호출시, 재시도 횟수를 설정 (retryCount) 
- 실패할 경우, 3초의 간격을 두고 retryCount를 1씩 차감하며 재호출하게 구현
- retryCount를 모두 차감하고도 실패할 경우는 서버가 작동이 안되는 시점으로 간주하여, completionHandler를 활용하여 View에서 나중에 재시도 하라는 Alert을 띄우도록 구현
  <details>
  <summary><b>주요코드</b></summary>

  ```swift
  	func request<T: Decodable>(type: T.Type, api: API, retryCount: Int = 2, completionHandler: @escaping (T?, AFError?) -> Void) {

		session.request(api.endPoint,
					 method: api.method,
					 parameters: api.parameter,
					 encoding: api.encoding).responseDecodable(of: T.self) { response in
			switch response.result {
			case .success(let success):
				print("네트워크 통신 성공!")
				completionHandler(success, nil)
			case .failure(let failure):
				print("에러")
				if retryCount > 0 {

					DispatchQueue.main.asyncAfter(deadline: .now()) {
						self.request(type: type, api: api, retryCount: retryCount - 1, completionHandler: completionHandler)
						print(retryCount)
					}
				} else {
					print("여기로오나")
					completionHandler(nil, failure)
				}

			}
		}
	}
  ```
    
</details>


## 🎮 주요기능 UI

|![nurirock-launchscreen](https://github.com/user-attachments/assets/6e3deacc-b9aa-4a5b-aa41-a66725413e5f)|![nurirock-citychange](https://github.com/user-attachments/assets/c50c8699-90e5-4326-802c-369eef503544)|![nurirock-contentchange](https://github.com/user-attachments/assets/dddf256a-d16c-405d-9697-c7f4aadb8f88)|![nurirock-event](https://github.com/user-attachments/assets/f1a69541-6c26-4788-a474-55496eac9a24)|
|:--:|:--:|:--:|:--:|
|animate 활용한 런치스크린|도시별 검색|컨텐츠별 검색|날짜별 행사 검색|

|![nurirock-keyword](https://github.com/user-attachments/assets/3be76476-63bc-4046-8e17-521a74f504aa)|![nurirock-bookmark](https://github.com/user-attachments/assets/6fe4446c-251e-4fa9-acea-1e2840ef62c1)|![nurirock-detail](https://github.com/user-attachments/assets/da5ec4f0-b0ee-4b4b-b371-a368b541264e)|
|:--:|:--:|:--:|
|키워드 검색|북마크 저장|세부사항 조회|


## 프로젝트 소개 및 발표
![20240402_123148_1](https://github.com/UngQ/NuriRock/assets/106305918/6e012976-2ecf-48c7-b651-93d10ebc6471)


