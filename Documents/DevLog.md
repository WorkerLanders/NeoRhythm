# NeoRhythm — 개발 로그

---

## 2026-06-16

### 기획서 정비

- `GDD_v0.1.md`, `StoryMode_GDD.md` → `Documents/` 폴더로 이동
- 4레인 고정 확정, 레인 수 확장 방식 삭제
- 입력 방식 명확화: 단일 마우스 좌클릭, 클릭 타이밍만 판정에 영향
- 동시 다중 레인 노트 없음 원칙 명시
- 슬라이드 노트 성공 조건 공식 추가: `floor((duration_sec × BPM) / 60 × 0.5) + 1`
- 채보 JSON 스키마 확정: ms 절대값 기반, lane 필드 제거(런타임 랜덤 배정)
- 점수 계산식 확정: 만점 1,000,000점 (기본 800k + 콤보 보너스 200k), 등급 S+~D
- 결과 화면 레이아웃 명세 추가 (좌측 랭크, 우측 판정 상세, 하단 EXP/레벨 바)
- 유저 레벨 & HP 시스템 명세 추가
  - 레벨 상한 50, EXP 공식, 레벨업 필요량 정의
  - 최대 HP = 100 + (레벨-1) × 10
  - MISS -10 HP 고정, 5초당 +1 HP 자동 회복

### 프로토타입 M1 구현 (Step 1~6)

**생성 파일**
- `project.godot` — Godot 4, 1280×720, GameScene 메인 씬
- `scenes/GameScene.tscn` — 메인 게임 씬
- `scenes/Note.tscn` — 노트 오브젝트 (Area2D + ColorRect)
- `scripts/ChartLoader.gd` — JSON 로드, 초→ms 변환, lane 필드 무시
- `scripts/JudgmentSystem.gd` — PERFECT(±20ms) / GREAT(±50ms) / GOOD(±100ms) / MISS
- `scripts/LaneManager.gd` — 직전 레인 제외 랜덤 배정
- `scripts/ScoreManager.gd` — 점수·콤보·정확도·등급 계산
- `scripts/Note.gd` — 노트 이동, 자동 Miss 처리 (class_name Note)
- `scripts/GameScene.gd` — 전체 게임 흐름 (채보 로드, 노트 스폰, 입력, HUD)

**수정 이력**
- GDScript 타입 추론 오류 일괄 수정 (Variant → 명시적 타입)
  - `PackedFloat32Array`로 LANE_Y 타입 확정
  - Dictionary 접근값 전부 명시적 캐스팅
  - `abs()` → `absi()` (int 전용 함수)
- `AudioServer` 레이턴시 보정 추가 (`get_time_since_last_mix - get_output_latency`)
- `AUDIO_OFFSET_MS` 상수로 수동 오프셋 조정 포인트 추가

### 현재 상태

- M1 프로토타입 플레이 가능 확인
- 사용 음원: `First Dawn Lullaby.mp3` (EP1 Ch1 Stage1)
- 사용 채보: `ep1_ch1_stage1.json` (tap 노트만, BPM 72, 자동 생성)
- 결과 화면 미구현 (M3 예정)
- 컷씬 미구현 (프로토타입 이후 검토 예정)

### 다음 스텝 (M2)

- [ ] Step 8: Hold / Slide 노트 구현
- [ ] 결과 화면 구현
- [ ] 메인 메뉴 / 곡 선택 화면 추가
