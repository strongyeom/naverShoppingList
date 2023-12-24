# 누네띠네
#### 네이버 쇼핑에서 찜하고 구매까지 연결되는 오픈 마켓 프로젝트
![네이버 쇼핑 피그마 작업](https://github.com/strongyeom/Best_Moment_SNS_Project/assets/101084872/f396b42b-1b80-4a4d-9f6b-1b7c1721b492)

# 개발 기간 및 인원
- 2023.09.07 ~ 2023.09.1
- 최소 버전: iOS 15.0
- 1인 개발

# 사용 기술
- **UIKit, CodeBaseUI, MVC, MVVM, SnapKit, Alamofire, Kingfisher, Realm**
------



# 기능 구현 
- `UINavigationBarAppearance`를 이용한 Custom NavigationBar 적용
- 화면별 "좋아요" 동기화
 - Realm의 id와 비교하여 id 유무에 따른 좋아요 표시 및 삭제 메서드 구현
- `CustomView`를 통한 효율적 로직 구현
- API를 직접적으로 사용하지 않고 Enum을 통한 `API 추상화` 구현
- 상품 리스트 `OffSet - based Pagination` 구현 
- `Kingfisher DownSampling`을 통한 리소스 최적화
- `MVVM` 아키텍쳐를 사용하여 코드 재사용성 향상
------





# Trouble Shooting
### A. 앱 종료시 "좋아요"한 상품 Reset되는 문제점 Realm 동기화로 이슈 해결 


```swift
    func settupCell(item: Item) {
        imageDownSizingToKingFisher(item: item)
        self.malNameLabel.text =  "[\(item.mallName)]"
        self.productName.text = item.title.encodingText()
        self.priceLabel.text =  "\(item.lprice.numberToThreeCommaString())원"
        
        if realmRepository.fetch().contains(where: { $0.id == item.productID}) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
}
```

### B. 스크롤시 재사용 매커니즘으로 인한 Cell에 여러 이미지 중복되는 문제 Kingfisher의 Cache를 활용하여 이슈 해결
Kingfisher의 Cache와 DownSampling을 활용하여 재사용 매커니즘으로 인한 이미지 중복 현산을 해결 할 수 있었고, Kingfisher 라이브러리를 사용함으로써 효율적으로 공수산정을 통해 프로젝트를 구현 할 수 있었습니다.

```swift
// 핵심 메서드
    func imageDownSizingToKingFisher(item: Item) {
        let url = URL(string: item.image)!
        let processor = DownsamplingImageProcessor(size: .init(width: 150, height: 150))
            self.shoppingImage.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            )
    }
```


### 회고
- 이번 프로젝트는 Kingfisher와 부분적 MVVM, Realm을 중점적으로 사용하여 구현하였고, 라이브러리를 효율적으로 사용 했을때 프로젝트의 공수산정이 효과적으로 이뤄질 수 있다는 것을 느꼈습니다. 또한 데이터 및 코드 추상화를 MVVM을 통해 왜 MVVM을 사용해야 하는지에 대해 이해할 수 있는 프로젝트였습니다. 현재 프로젝트에는 부분적 MVVM을 사용하고 있지만 다음 프로젝트에서는 MVVM 아키텍쳐에 대해 깊이 이해하고 익숙해져 코드를 효율적으로 작성하는 것을 목표로 잡고 공부해 나갈 것입니다.

