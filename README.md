# naverShoppingList
2차 Recap NaverShoppingList 

# NaverShoppingList

> Realm과 네이버 shopping API를 활용한 프로젝트 

<br> 

# 목차

[1-프로젝트 소개](#1-프로젝트-소개)

- [1-1 개요](#1-1-개요)
- [1-2 주요목표](#1-2-주요목표)
- [1-3 개발환경](#1-3-개발환경)
- [1-4 구동방법](#1-4-구동방법)


[3-프로젝트 특징](#3-프로젝트-특징)

[4-프로젝트 세부과정](#4-프로젝트-세부과정)

[5-업데이트 및 리팩토링 사항](#5-업데이트-및-리팩토링-사항)


--- 

## 1-프로젝트 소개

### 1-1 개요
`Realm과 API 활용 프로젝트`
- Realm과 API를 활용하여 데이터 베이스 구조 파악 및 활용

### 1-2 주요목표
`과제 전형 미리 경험해보기`
- 데이터 스키마 설계
- 재사용성을 고려한 UI
- 기능과 역할에 따른 코드 구조

### 1-3 개발환경
- 활용기술 외 키워드
  - iOS : iOS 13.0
  - Network: 네이버 API 
  - UI : CodeUI
  - Layout : SnapKit
- 라이브러리
  - SnapKit
  - Alamofire
  - Kingfisher
  - Realm
  - RealmDatabase

<br>

### 4-1 [Feature 1] 어떤 앱을 만들 것인가? (+ UI Design, Prototype)
[프로토타입 링크(Figma)](https://www.figma.com/file/kZjgckc8czM4CzLhEZpibK/Dangle-Design?type=design&node-id=1%3A115&mode=design&t=jfIsB0Y4aNJl82xV-1)
> 앱 컨셉 설정과 App Prototyping  
- 앱 컨셉 설정 사용자의 일상, 그리고 주변의 다양한 이슈와 이벤트를 제공하는 `하이퍼 로컬 뉴스 앱`을 목표로 설정
- 본격적인 앱을 구현하기에 앞서, `사용자 친화적인 UX`를 제공하기 위해 Figma를 통한 프로토타입 생성
- 디자인-개발-수정 단계를 반복적으로 수행함으로서 `애자일 개발방식` 실천

![image](https://github.com/onthelots/dangle/assets/107039500/06ee2adb-f992-47dd-903a-57a0c622fc2c)

<br>

--- 

<br>

🚫 Trouble Shooting

순서  | 내용  | 비고
----| ----- | -----
1| 디바이스 위치서비스 활성/비활성화 확인 메서드 실행에 따른 UI 불응성(unresponsiveness)문제 | https://github.com/onthelots/dangle/issues/8
2| UITabBarViewController 중첩 문제 | https://github.com/onthelots/dangle/issues/22

<br>

--- 

<br>

### 4-3 [Feature 3] Home, Map, Profile 탭 별 UI 구현 및 데이터 나타내기

#### 4-3-1 Home Tab
> 서울시의 분야별 새 소식과, 자치구 내 문화행사, 강좌(서울시 공공데이터) 등 유용한 정보 제공
- 로그인 한 사용자의 `UID`를 기반으로 서버(FireStore)에서 위치값을 활용, 서울시 공공 API 데이터를 필터링하여 화면에 나타냄
- Paging 기능을 비롯하여 Section 별 상이한 레이아웃을 구성하기 위해, `Compositional Layout`을 활용함
- 각각의 이벤트를 선택 » 세부 정보 뷰를 확인 » 예약 혹은 더욱 자세한 정보를 앱웹으로 확인하기 위해 `SFSafariViewController`를 활용

<br>

#### 4-3-2 Dangle Map Tab
> 작성중
- 작성중

🚫 Trouble Shooting

순서  | 내용  | 비고
----| ----- | -----
1| 특정 API를 JSON으로 파싱 시, HTML 형식으로 내려오는 문제 | https://github.com/onthelots/dangle/issues/31
2| 사용자의 현재 위치를 기반으로 인근에 있는 카테고리 별 데이터를 받아오지 못하는 문제 | https://github.com/onthelots/dangle/issues/39

<br>


#### 4-3-3 Profile Tab 
> 작성중
- 작성중

<br>

🚫 Trouble Shooting

순서  | 내용  | 비고
----| ----- | -----
1| 작성중 | 작성중
2| 작성중 | 작성중

<br>


## 5-업데이트 및 리팩토링 사항
### 5-1 우선 순위별 개선항목
1) Issue
- [] 
  
<br>
