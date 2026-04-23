<div align="center">

<img src="BanguCruise/Assets.xcassets/Logo.imageset/BanguCruise_LaunchScreen.png" width="180" alt="BanguCruise Logo" />

# 방구크루즈 (BanguCruise)
### 방사능에서 구해 주는 크루즈 — 국내 수산물 방사능 검사 결과 조회 iOS 앱

![Swift](https://img.shields.io/badge/Swift-5.0-FA7343?logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-16.4+-000000?logo=apple&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-14.0+-1575F9?logo=xcode&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-blue)
![License](https://img.shields.io/badge/License-MIT-green)

</div>

---

## 목차 (Table of Contents)

- [프로젝트 소개](#1-프로젝트-소개)
- [주요 기능](#2-주요-기능-features)
- [기술 스택](#3-기술-스택-tech-stack)
- [아키텍처](#4-아키텍처-architecture)
- [폴더 구조](#5-폴더-구조-project-structure)
- [기술적 고민 / 트러블 슈팅](#6-기술적-고민--트러블-슈팅)
- [컨벤션](#7-컨벤션-convention)
- [라이브러리 의존성](#8-라이브러리-의존성)

---

## 1. 프로젝트 소개

### 배경 및 동기

일본 후쿠시마 오염수 방류 이슈 이후, 국내 수산물의 안전성에 대한 소비자의 관심과 불안감이 크게 높아졌습니다. **국립수산물품질관리원(NFQS)** 은 수산물 방사능 검사 결과를 공공 API로 제공하고 있지만, 원본 데이터는 정부 사이트의 표 형식으로만 노출되어 일반 사용자가 빠르게 확인하기 어렵다는 문제가 있었습니다.

**방구크루즈**는 *"방사능에서 구해 주는 크루즈"* 라는 이름 그대로, 최근 2주간의 방사능 검사 결과를 **품목별로 빠르게 조회**할 수 있도록 만든 iOS 애플리케이션입니다.

### 핵심 가치

- **한 손으로 확인 가능한 단일 화면 UX** — 복잡한 메뉴 없이 조회 → 품목 선택 → 결과 확인까지 1-step
- **신뢰 가능한 1차 출처 (NFQS 공공 API)** 를 그대로 사용하여 가공/왜곡 없는 원본 검사 결과 제공
- **검출/미검출 시각적 구분** — "검출" 항목은 빨간색, "불검출"은 초록색으로 즉시 판별 가능

---

## 2. 주요 기능 (Features)

| 기능 | 설명 |
|------|------|
| 최근 2주 검사 결과 조회 | 앱 실행 시점을 기준으로 **-14일부터 오늘까지**의 검사 결과를 NFQS API에서 자동 조회 |
| 수산물 품목 필터링 | UIPickerView를 통해 조회된 품목 중 원하는 수산물만 선택하여 필터링 |
| 분석 장소 / 시료 수거지 / 검사 결과 표시 | 각 검사 건별로 3가지 핵심 정보를 테이블 뷰로 제공 |
| 검출 여부 색상 구분 | `검출` → 빨간색, `불검출` → 초록색으로 즉각적 판별 |

> 각 기능의 스크린샷은 추후 추가 예정입니다. (아래 자리 표시자에 이미지 파일을 넣어주세요.)
>
> | 로딩 화면 | 메인 화면 | 결과 조회 |
> |:---:|:---:|:---:|
> | *(screenshot)* | *(screenshot)* | *(screenshot)* |

---

## 3. 기술 스택 (Tech Stack)

| 카테고리 | 사용 기술 |
|---|---|
| **Language** | Swift 5.0 |
| **Minimum iOS** | iOS 16.4+ |
| **UI** | UIKit (Programmatic, No Storyboard\*) |
| **Architecture** | MVVM |
| **Reactive** | RxSwift 6.0+, RxCocoa 6.0+ |
| **Networking** | URLSession + XMLParser |
| **Dependency Manager** | Swift Package Manager (SPM) |
| **DI** | - (추후 도입 예정) |
| **CI/CD** | - (추후 도입 예정) |

\* `LaunchScreen.storyboard` 만 Storyboard 사용, 그 외 모든 화면은 SnapKit 기반 프로그래밍 방식 레이아웃

---

## 4. 아키텍처 (Architecture)

### 의존성 흐름

```
┌────────────────────┐       ┌────────────────┐       ┌──────────────────────┐
│ MainViewController │ ───▶  │  MainViewModel │ ───▶  │        Parser        │
│   (Presentation)   │       │  (Business)    │       │ (URLSession + XML)   │
└────────────────────┘       └────────────────┘       └──────────────────────┘
        ▲                            │                          │
        │ RxSwift bind               │ BehaviorSubject /        │ XMLParserDelegate
        │ (isParsed, isDataCheked)   │ PublishSubject           ▼
        │                            │              ┌──────────────────────┐
        └────────────────────────────┘              │ BanguCruiseResponseDTO│
                                                    └──────────────────────┘
```

### 레이어별 역할

- **Presentation (View / ViewController)**
  `MainView`, `DetailCell`, `HeaderView`, `MainViewController` 로 구성. UIPickerView/UITableView의 delegate·dataSource를 `MainViewController`가 담당하며, ViewModel이 노출한 `PublishSubject`를 RxSwift로 구독해 UI를 갱신합니다.
- **ViewModel (MainViewModel)**
  날짜 범위 계산, API 호출 트리거, 응답 데이터 가공(품목 중복 제거, 선택 품목 기준 필터링)을 담당. 화면에 필요한 상태는 `isParsed`, `isDataCheked` 두 개의 Subject를 통해 이벤트로 전달합니다.
- **Util (Parser)**
  URLSession으로 XML 응답을 받고, `XMLParserDelegate` 를 구현해 `BanguCruiseResponseDTO` 리스트로 변환합니다.

### 왜 MVVM인가?

- UIPickerView 선택 → 필터링 → 테이블 재갱신으로 이어지는 **상태 흐름이 반응형(reactive) 으로 표현하기 적합**하여 RxSwift와 궁합이 좋은 MVVM을 선택했습니다.
- ViewController에서 비즈니스 로직(날짜 계산, 품목 중복 제거, 필터링)을 분리하여 테스트/재사용 가능성을 확보했습니다.
- 단일 화면 앱의 규모상 Clean Architecture(Presentation/Domain/Data)는 과한 추상화로 판단, MVVM으로 시작 후 필요 시 점진적으로 레이어를 분리하는 전략을 택했습니다.

---

## 5. 폴더 구조 (Project Structure)

```
BanguCruise/
├── BanguCruise/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── LoadingViewController.swift       # 스플래시/로딩 화면
│   ├── Info.plist
│   ├── environment.xcconfig              # API_URL 환경변수 관리
│   │
│   ├── ViewController/
│   │   └── MainViewController.swift      # 메인 화면 컨트롤러 (Rx 바인딩)
│   │
│   ├── ViewModel/
│   │   └── MainViewModel.swift           # 상태·비즈니스 로직
│   │
│   ├── View/
│   │   ├── MainView.swift                # 메인 화면 레이아웃 (SnapKit)
│   │   ├── DetailCell.swift              # 검사 결과 셀
│   │   └── HeaderView.swift              # 테이블 헤더
│   │
│   ├── Util/
│   │   └── Parser.swift                  # URLSession + XMLParser
│   │
│   ├── Properties/
│   │   └── ExtensionUIColor.swift        # HEX 컬러 확장
│   │
│   ├── Assets.xcassets/                  # 앱 아이콘, 로고 이미지
│   └── Base.lproj/
│       └── LaunchScreen.storyboard
│
└── BanguCruise.xcodeproj
```

---

## 6. 기술적 고민 / 트러블 슈팅

### 6-1. XMLParser의 `foundCharacters`가 문자열을 잘라서 전달하는 이슈

#### 문제 상황
NFQS API는 XML로 응답을 내려주는데, 검사 장소명 같은 특정 필드에서 **일부 데이터가 중간에 잘려서 표시**되는 현상이 있었습니다. 예를 들어 `"국립수산물품질관리원 부산지원"` 이 `"부산지원"` 으로만 표시되는 식이었습니다.

#### 원인 분석
`XMLParserDelegate.parser(_:foundCharacters:)`는 **하나의 엘리먼트 내용이라도 내부 버퍼 크기나 특수문자 이스케이프 처리에 따라 여러 번 호출될 수 있다**는 점이 원인이었습니다.
즉 `<analMchnNm>국립수산물품질관리원 부산지원</analMchnNm>` 하나를 파싱할 때도, 파서 내부적으로 `"국립수산물품질관리원 "` → `"부산지원"` 처럼 두 번에 걸쳐 `foundCharacters`가 불릴 수 있습니다.

초기 구현은 `foundCharacters`가 호출될 때마다 프로퍼티에 **대입(`=`)** 을 했기 때문에, 마지막 호출 값으로 **이전 조각이 덮어써져** 앞부분이 손실되고 있었습니다.

```swift
// ❌ 문제 코드 (개념)
case "analMchnNm":
    banguCruiseDomain?.analysisLocation = string   // 호출될 때마다 덮어씀
```

#### 해결 방법
대입 대신 **누적(`+=`)** 하고, `didStartElement` 에서 해당 필드를 빈 문자열로 초기화하도록 바꾸는 것이 정석적인 해법입니다. 본 프로젝트의 `Parser.swift`는 `didStartElement` 시점에 DTO를 모든 필드가 `""` 인 상태로 새로 만들기 때문에, `foundCharacters` 에서 `+=` 로 누적하도록 변경하면 됩니다.

```swift
// ✅ 개선 방향
case "analMchnNm":
    banguCruiseDomain?.analysisLocation += string  // 조각을 이어붙임
```

#### 결과 & 배운 점
- 긴 문자열이나 특수문자가 포함된 필드에서 데이터 누락이 사라지는 개선 효과를 확인했습니다.
- **델리게이트 메서드가 몇 번 호출되는가**는 런타임/버전/데이터에 따라 달라질 수 있으므로, "한 번 호출된다"고 가정하지 말고 **멱등(idempotent) 하거나 누적 가능한 형태로 구현**해야 한다는 점을 체득했습니다.

> 향후 측정 가능한 성능/메모리 지표(예: 파싱 시간, 검출 오탐률)는 계측 코드를 도입한 뒤 정량 수치로 업데이트할 예정입니다.

---

## 7. 컨벤션 (Convention)

### Git Flow / Branch 전략

- `main` — 배포(출시) 브랜치
- `release` — 릴리즈 후보 브랜치
- `develop` — 통합 개발 브랜치
- `feature_*` — 기능 단위 브랜치 (예: `feature_API`, `feature_UI/UX`, `feature_ListPickerView`)

> 기능 구현은 `feature_*` → `develop` PR 머지 → 릴리즈 시 `release` → `main` 순으로 진행합니다.

### Commit 메시지 규칙

`[prefix]: [내용]` 형식을 사용합니다.

| Prefix | 용도 |
|---|---|
| `feature` | 새로운 기능 추가 |
| `Update` | 기존 기능/리소스 수정 |
| `fix` | 버그 수정 |
| `refactor` | 리팩터링 (동작 변경 없음) |
| `docs` | 문서 변경 |
| `chore` | 빌드·설정 등 기타 변경 |

예) `feature: view design`, `Update: title Font, Label Font`

### 코드 컨벤션

- **네이밍**: Swift API Design Guidelines 준수 (타입: UpperCamelCase, 메서드/프로퍼티: lowerCamelCase)
- **파일 구조**: 기능별로 `ViewController / ViewModel / View / Util / Properties` 디렉터리로 분리
- **Access Control**: 외부 노출이 필요 없는 멤버는 `private` / `final class` 를 기본으로 적용
- **레이아웃**: SnapKit DSL로 프로그래밍 방식 작성, Storyboard는 LaunchScreen에 한해 사용

---

## 8. 라이브러리 의존성

| 라이브러리 | 버전 | 선택 이유 |
|---|---|---|
| [**RxSwift**](https://github.com/ReactiveX/RxSwift) | 6.0+ | ViewModel의 상태 변경(파싱 완료, 데이터 필터링 완료)을 `PublishSubject`로 노출하여 ViewController가 선언적으로 구독할 수 있도록 함. Delegate 기반 흐름보다 상태 전파 코드가 간결해짐 |
| [**RxCocoa**](https://github.com/ReactiveX/RxSwift) | 6.0+ | `UIButton.rx.tap` 등 UIKit 이벤트를 Observable로 변환하여 Rx 스트림과 자연스럽게 결합 |
| [**SnapKit**](https://github.com/SnapKit/SnapKit) | 5.0+ | NSLayoutConstraint API 대비 간결한 DSL로, 프로그래밍 방식 오토레이아웃의 가독성과 작성 속도를 확보. Storyboard 없이도 레이아웃이 한눈에 읽히도록 함 |

---

<div align="center">

Made with ❤️ in Korea — 국내 수산물의 안전한 소비를 응원합니다.

</div>
