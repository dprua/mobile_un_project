# 🖥 UN HR Relocation System

## 🤔 Description
2021-1학기 모바일 앱 개발 중 외부 프로젝트로 실시된 UN 제네바 지사에서 사용할 인사과 자동 이직 시스템 입니다.<br>
현재 UN 제네바 지사의 이직 시스템은 매번 이직 시즌이 올 때마다 인사과 직원들이 수작업을 통해 이직을 희망하는 사람들의 근무지를 정하는 상황입니다.<br>
이러한 인력 낭비문제를 해결하고자 이직 알고리즘이 적용한 어플리케이션 개발을 목표로 진행된 프로젝트 입니다.<br>

- 기술 스택
  - **Android Studio**
  - **Flutter**
    - **Dart**
  - **Firebase**

> 2021.07.29 UN 제네바 지사로 프로토타입 프로그램 시연동영상 제출 및 평가 대기중
## 📌 Environment
- Win10, Mac Big Sur 11.2.3
- Android 11.0 ver
- Flutter 2.0.1 ver
  - Dart 2.12.0

## 💾 Installation

### 📍 Basic Installation method
- Flutter Install [rink](https://flutter.dev/docs/get-started/install)<br>
- Flutter 설치 후 `flutter doctor` commend 실행<br>
  ![스크린샷 2021-09-25 오전 1 39 03](https://user-images.githubusercontent.com/34247631/134710661-d04591f7-8d20-4008-93c8-a4df029be40f.png)<br>
  위의 결과가 나오도록 개발환경 구성

### 🔍 Specific Installation method
#### 1. flutter sdk 설치
- [링크](https://flutter.dev/docs/get-started/install/windows)에 있는 [파일](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_2.2.2-stable.zip) 다운로드해서 PC에 원하는 위치에 다운로드 한다.<br>
>window의 경우 `C:\Program Files\`에 설치하지 않도록 주의
- flutter sdk가 설치된 위치에서 flutter console로 `flutter doctor` commend로 설치상태 확인
#### 2. Android Studio 설치
- [링크](https://developer.android.com/studio/install?hl=ko)에서 설치
- Android Studio의 설치가 완료된 이후 프로그램을 실행하여 Flutter,Dart 플러그인을 설치한다.
#### 3. Java8 sdk 설치
- [링크](https://www.oracle.com/java/technologies/javase-downloads.html)에서 파일 다운로드 및 설치
- JAVA_HOME 환경변수 설정 
  - 설정 방법은 [링크](https://hyoje420.tistory.com/7)참조
#### 4. 라이선스 등록
- Android Studio terminal에서 `flutter doctor --android-licenses` 로 라이선스 등록
- `flutter doctor` 실행 시 안드로이드 스튜디오 미설치 됐다는 에러가 나오면<br>
`flutter config --android-studio-dir="C:\Program Files\Android\Android Studio"`로 안드로이드 스튜디오 설치 위치 재설정
#### 5. 테블릿 모델
- 10.1 WXGA (Tablet)

## 💡 Functions

|State Management|User Interface1|User Interface2|
|:--------------:|---------------|---------------|
|![스크린샷 2021-09-25 오전 2 28 08](https://user-images.githubusercontent.com/34247631/134716533-ee86dfcc-1d93-4b8d-9a93-bfdf7797b99f.png)|![스크린샷 2021-09-25 오전 2 27 47](https://user-images.githubusercontent.com/34247631/134716570-9298d6a1-fd3b-43d8-9ad4-88f8b2db0750.png)|![스크린샷 2021-09-25 오전 2 28 22](https://user-images.githubusercontent.com/34247631/134716625-9ac9fdf7-dc2d-4bfd-8481-f52bca738f6f.png)|
|프로젝트의 특성상 사용자가 여러 페이지를 드나들며 정보를 확인해야하는 상황이 많이 발생했습니다. 그래서 Sign-in페이지에서 provider를 사용하여 사용자 state를 관리함으로써 페이지 이동 간 state가 잘 유지 될 수 있도록 하였습니다.|손에 들어오는 핸드폰 환경이 아닌 테블릿 환경에서 작동하는 어플리케이션을 개발하는게 조건이었기 때문에 User Interface 구성에 많은 노력을 했습니다. 큰 테블릿 화면을 2~3개 영역으로 나눠서 사용자에게 효율적으로 정보를 제공할 수 있도록 하였습니다. 그리고 reorderable list를 구현하여 해당 포지션의 지원자간 Rank를 매겨 우선순위를 지정할 수 있도록 하였습니다. 드래그로 직관적으로 우선순위를 부여할 수 있다는 장점이 있습니다.|각 포지션별로 지원자간에 우선순위가 정해지면 이 우선순위를 통해 relocation algorithm을 적용하여 이직 가능한 경우의 수를 인사과 직원에게 제공해야했습니다. 그래서 본 프로젝트 가장 핵심인 기능을 구현하기 위해서 저희 팀이 구상한 알고리즘을 구현 및 프로그램에 적용하여 이 기능을 구현하였습니다. 알고리즘에 대한 설명은 [UX_Matching algorithm explanation Document](https://github.com/dprua/mobile_un_project/files/7227640/UX_Matching.algorithm.explanation.pdf)에서 확인 가능 합니다.

## 💽 DB Structure

본 프로젝트는 Firebase에서 DB를 구성하였고 총 3개의 collection(`post , apply, users`)로 설계되었습니다.<br>
|Post|Apply|Users|
|:--:|-----|-----|
|![스크린샷 2021-09-25 오전 2 56 44](https://user-images.githubusercontent.com/34247631/134719962-34e301e0-20e7-4fba-bec5-615c8e4bf7ee.png)|![스크린샷 2021-09-25 오전 2 56 59](https://user-images.githubusercontent.com/34247631/134719980-1df6127f-90df-4dbb-848c-d6223a3cf7d8.png)|![스크린샷 2021-09-25 오전 2 57 22](https://user-images.githubusercontent.com/34247631/134720008-e2b7d189-46e9-4dff-867d-671b3b2b9c10.png)|
|Post Collection은 현재 새로운 직원을 모집하는 포지션의 정보들이 각 포지션별로 저장되어 관리되어지는 collection 입니다. 정보로는 포지션의 위치, 필요능력, 사진 등 이직을 희망하는 사용자에게 필요한 정보들을 제공합니다.|Apply Collection은 포지션별로 지원한 지원 정보가 저장되는 collection으로 각 지원정보에 어떤 포지션에 지원했는지 포지션 ID가 자동으로 저장되도록 하여 인사 담당자에게 현재 지원현황 정보를 제공할 수 있도록 하였습니다.|Users Collection은 현재 시스템에 가입되어있는 사용자들의 정보가 저장된 Collection으로 각 사용자의 type과 개인정보들이 저장되어 있습니다. 이 정보들은 프로필 페이지에서 사용자 정보를 제공할 때 사용되어지록 하였습니다.|

## 👀 Result

### 📱 Pages
|Sign In & Up|HomePage for Staff Member|Posting(Add) page for Staff member|
|:----------:|-------------------------|----------------------------------|
|<img width="451" alt="스크린샷 2021-09-25 오후 2 18 59" src="https://user-images.githubusercontent.com/34247631/134770439-3bd61b8d-3913-4291-a8eb-0a26f25598a0.png">|![스크린샷 2021-09-25 오후 8 52 14](https://user-images.githubusercontent.com/34247631/134770571-b81a9946-9809-43a2-ac8b-0f845cda45b7.png)|![스크린샷 2021-09-25 오후 8 52 28](https://user-images.githubusercontent.com/34247631/134770581-2551535c-08aa-4525-b72f-43879c099e3b.png)|
|회사 인트라넷에서 사용될 프로그램이므로 Firebase에서 제공하는 이메일 인증 로그인 방식을 적용하여 구현되었습니다. `Remember me` 버튼을 활용해서 간편하게 로그인 할 수 있습니다.|이직을 희망하는 직원들이 자신의 포지션을 올리고 자리가 난 포지션에 지원을 할 수 있는 평직원 전용 홈페이지 화면 입니다.|이직을 희망하는 직원들이 자신의 현재 포지션을 어플리케이션에 등록하는 페이지 입니다. 포지션에 필요한 역량과 정보가 기입됩니다.|

|HM approval page|HM/HR detail page|HR homepage|
|:--------------:|-----------------|-----------|
|![스크린샷 2021-09-25 오후 8 57 19](https://user-images.githubusercontent.com/34247631/134770917-726b143a-657f-4de0-aa13-36a7ba9b893b.png)|![스크린샷 2021-09-25 오후 9 04 41](https://user-images.githubusercontent.com/34247631/134770940-a83a8950-dfc7-4288-bc55-ccaf4eb3172b.png)|![스크린샷 2021-09-25 오후 9 05 06](https://user-images.githubusercontent.com/34247631/134771040-8e465111-ebe5-4e27-b5d9-b88c35ab26d7.png)|
|인사팀관리자는 이 페이지에서 이직을 요청한 신규 포스팅을 승인해서 모든 사용자가 이 포지션 정보를 볼 수 있게 할 수 있고 이직요청을 반려할 수 있습니다.|인사팀 관리자와 직원이 현재 해당 포지션의 지원자 정보를 볼 수 있는 페이지 입니다. 인사관리자는 지원자의 정보와 drag를 통해 지원자간 순위를 매길 수 있고 인사팀 직원은 지원자의 정보만 볼 수 있습니다.|이직 알고리즘이 필요한 인사팀 직원이 사용할 홈페이지 입니다. `Generate Case`버튼을 눌러 현재 지원현황에서 가능한 이직의 경우의 수를 볼 수 있습니다.|

### 📸 Presentation
프로젝트 발표자료와 영상은 아래 링크를 통해 확인하실 수 있습니다.
- Video Rink
  - [Kor](https://youtu.be/LSlEKh-w03I), [Eng](https://youtu.be/PctKhzsiEco)
- Resources Rink
  - [Kor](https://docs.google.com/presentation/d/1RdXdpcmKTsOsRRfJfNyqB-k8X1NxXJ3Ozb7IDy6M_ao/edit?usp=sharing), [Eng](https://docs.google.com/presentation/d/1yS8-6cKfqER9V_00oiHnHGDBvchY0WMpa_4HhIFQzI0/edit?usp=sharing)

## 🙇 Contributors
|이름|분업내용|연락처|
|:-:|------|-----|
|**박예겸**|PM, HR Pages, UI design, Algorithm development|dprua@naver.com|
|**신겸**|HM Pages, UI design|21500265@handong.edu|
|**김예진**|STF Pages, DB design, Algorithm development|yj11735@naver.com|
