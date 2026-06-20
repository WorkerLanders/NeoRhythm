# NeoRhythm — CLAUDE.md

## 프로젝트 개요

Windows/Web 대상 횡스크롤 리듬 게임. 노트가 우→좌 이동, 판정선(화면 좌 15%) 도달 시 단일 키 입력으로 타격. 유저 실제 인생 경험 기반 스토리 모드와 AI 음악 생성 파이프라인을 핵심으로 한다.

- **엔진**: Godot 4.2 / GDScript
- **해상도**: 1280 × 720 (canvas_items stretch, keep aspect)
- **렌더러**: GL Compatibility (WebGL2 + OpenGL 공용)
- **빌드 타겟**: Web(GitHub Pages, 개발 확인용) / Windows 64-bit(최종 배포)

---

## 기획서 위치

| 문서 | 경로 |
|------|------|
| 메인 GDD | `Documents/GDD_v0.1.md` |
| 스토리 모드 | `Documents/StoryMode_GDD.md` |
| 채보 에디터 | `Documents/BeatmapEditor_GDD.md` |
| 개발 로그 | `Documents/DevLog.md` |

---

## 개발 마일스톤 현황

| 단계 | 목표 | 상태 |
|------|------|------|
| M1 — 프로토타입 | 노트 생성·이동·판정·점수 표시 | ✅ 완료 |
| M2 — 두 번째 프로토타입 | 전체 화면 플로우, 홀드 노트, HP, 세이브 | ✅ 완료 |
| M3 — 알파 | 복수 곡, 컷씬, 스토리 스크립트 연동 | ⬜ 미착수 |
| M4 — 릴리스 | UI 완성, 사운드 이펙트, Windows 빌드 패키징 | ⬜ 미착수 |

---

## 파일 구조

```
NeoRhythm/
├── project.godot               # 메인 씬: TitleScreen, Autoload 3개
├── export_presets.cfg          # Web 빌드 → build/web/index.html
├── scenes/
│   ├── TitleScreen.tscn        # 진입점 → MainMenu
│   ├── MainMenu.tscn           # 4개 메뉴 버튼 + 레벨 바
│   ├── StoryEpisodeSelect.tscn # EP 선택 (EP.1 해금)
│   ├── StoryStageSelect.tscn   # 스테이지 선택 + 베스트 랭크
│   ├── FreePlaySelect.tscn     # 해금된 곡 자유 플레이
│   ├── SettingsScreen.tscn     # 키바인딩·배속·밝기
│   ├── GameScene.tscn          # 인게임 (채보 로드→판정→결과 전환)
│   ├── ResultScreen.tscn       # 등급·판정 상세·EXP·레벨 바
│   └── Note.tscn               # 노트 오브젝트 (Area2D)
├── scripts/
│   ├── [Autoload] GameSettings.gd   # 키/배속/밝기 설정 저장 (user://settings.json)
│   ├── [Autoload] SaveManager.gd    # 레벨·EXP·베스트 기록 (user://save.json)
│   ├── [Autoload] GameContext.gd    # 씬 간 게임 설정·결과 전달
│   ├── GameScene.gd            # 인게임 핵심 로직
│   ├── Note.gd                 # 노트 이동·홀드 상태 머신
│   ├── JudgmentSystem.gd       # PERFECT(±20ms)/GREAT(±50ms)/GOOD(±100ms)/MISS
│   ├── ScoreManager.gd         # 점수·콤보·정확도·등급 계산
│   ├── LaneManager.gd          # 직전 레인 제외 랜덤 배정 (0~3)
│   ├── ChartLoader.gd          # JSON 채보 로드 (초↔ms 자동 변환)
│   ├── TitleScreen.gd
│   ├── MainMenu.gd
│   ├── StoryEpisodeSelect.gd
│   ├── StoryStageSelect.gd
│   ├── FreePlaySelect.gd
│   ├── SettingsScreen.gd
│   └── ResultScreen.gd
├── Resources/
│   ├── First Dawn Lullaby.mp3  # EP1 Ch1 Stage1 음원 (BPM 72, 104.4초)
│   └── beatmaps/
│       └── ep1_ch1_stage1_easy.json  # 탭 33개 + 홀드 8개 (55초~)
├── tools/
│   └── beatmap_editor.html     # 독립 채보 에디터 (브라우저)
└── Documents/
    └── *.md
```

---

## 핵심 상수 & 수치

| 항목 | 값 | 위치 |
|------|----|----|
| 판정선 X | 192 px | `GameScene.gd` |
| 스폰 X | 1380 px | `GameScene.gd` |
| 기본 이동 시간 | 2.0초 (배속 1.0x) | `GameSettings.get_note_travel_time()` |
| 이동 시간 공식 | `2.0 ÷ scroll_speed` | `GameSettings.gd` |
| PERFECT 판정창 | ±20 ms | `JudgmentSystem.gd` |
| GREAT 판정창 | ±50 ms | `JudgmentSystem.gd` |
| GOOD 판정창 | ±100 ms | `JudgmentSystem.gd` |
| Miss HP 패널티 | -10 HP | `GameScene.gd` |
| HP 자동 회복 | +1 HP / 5초 | `GameScene.gd` |
| 최대 HP 공식 | `100 + (레벨-1) × 10` | `SaveManager.get_max_hp()` |
| 오디오 오프셋 | 0.0 ms (플랫폼별 조정 필요) | `GameScene.gd::AUDIO_OFFSET_MS` |

---

## 채보 JSON 스키마

```json
{
  "title": "곡 제목",
  "difficulty": "easy",
  "bpm": 72,
  "duration": 104.4,
  "audio": "Resources/파일명.mp3",
  "notes": [
    { "time": 1.667, "type": "tap" },
    { "time": 5.0,   "type": "hold", "duration": 1.667 }
  ]
}
```

- `time` / `duration`: 초(s) 또는 ms 모두 가능 (ChartLoader가 1000 기준으로 자동 판별)
- `lane` 필드 없음 — 런타임 랜덤 배정 (직전 레인 제외)
- 파일 명명 규칙: `ep{N}_ch{N}_stage{N}_{difficulty}.json`

---

## 씬 전환 플로우

```
TitleScreen
  └─(click)→ MainMenu
               ├─ 스토리 모드 → StoryEpisodeSelect → StoryStageSelect → GameScene → ResultScreen → StoryStageSelect
               ├─ 프리 플레이 → FreePlaySelect → GameScene → ResultScreen → FreePlaySelect
               ├─ 기록 (미구현, 비활성화)
               └─ 설정 → SettingsScreen → MainMenu
```

GameScene 진입 전 반드시 `GameContext.setup_game()` 호출 필요.

---

## Autoload 싱글톤

### GameSettings
- `action_key_code` / `action_is_mouse`: 키 바인딩 (기본: 마우스 좌클릭)
- `scroll_speed`: 배속 1.0x ~ 5.0x (0.5 단위)
- `bg_brightness`: 배경 밝기 0.0 ~ 1.0
- `is_action_pressed(event)` / `is_action_released(event)`: 인게임 입력 판별
- `save_settings()` / `load_settings()`: `user://settings.json`

### SaveManager
- `user_level`, `user_exp`: 유저 레벨 / 누적 EXP
- `best_scores`: `{chart_id → {grade, score}}` 딕셔너리
- `unlocked_stages`: 클리어한 chart_id 목록 (ep1_ch1_stage1_easy는 항상 해금)
- `add_exp(amount)` → bool(레벨업 여부)
- `calc_exp_gain(grade, difficulty)` → int
- `save_data()` / `load_data()`: `user://save.json`

### GameContext
- 씬 전환 전 설정: `chart_path`, `chart_id`, `game_mode`, `difficulty`, `return_scene`
- 결과 전달: `result_*` 필드 (GameScene → ResultScreen)
- `setup_game(...)`: 한 번에 설정

---

## 스토리 모드 데이터 구조

현재 `StoryStageSelect.gd`와 `StoryEpisodeSelect.gd`에 하드코딩.
신규 스테이지 추가 시 `StoryStageSelect.gd::STAGE_DATA` 딕셔너리에 항목 추가.

```gdscript
# StoryStageSelect.gd
const STAGE_DATA := {
    1: [  # episode_id
        {
            "chart_id":   "ep1_ch1_stage1_easy",
            "chart_path": "res://Resources/beatmaps/ep1_ch1_stage1_easy.json",
            "title":      "First Dawn Lullaby",
            "difficulty": "easy",
            "chapter":    1,
            "stage":      1,
        },
        # 신규 스테이지 추가 위치
    ],
}
```

---

## CI / 배포

GitHub Actions (`build-web.yml`):
- 트리거: `master` 브랜치 push 또는 `workflow_dispatch`
- Godot 4.2 headless 빌드 → `build/web/index.html`
- coi-serviceworker 주입 (SharedArrayBuffer 활성화)
- GitHub Pages 자동 배포

**웹 빌드로 테스트하려면**: `master`에 머지 후 Actions 완료 대기.

---

## 주의 사항 / Known Issues

- **오디오 레이턴시**: 웹 빌드는 50~200ms 레이턴시 가변적. `AUDIO_OFFSET_MS` 상수로 보정 (현재 0.0). 최종 튜닝은 Windows 빌드에서만 수행. (⚠ 개발 최하 우선순위 — 나중에 진행)
- **세이브 호환성**: 웹(IndexedDB) ↔ Windows(파일시스템) 세이브 공유 안 됨.
- **기록 화면**: 메인 메뉴의 "기록" 버튼은 현재 비활성화(disabled) 상태.
- **EP.2~4**: `StoryEpisodeSelect`에서 locked 표시, 선택 불가.
- **홀드 노트 끝 판정**: 현재 꼬리 도달 시 항상 PERFECT (GDD 명세 단순화 구현).
