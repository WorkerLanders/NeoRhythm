# NeoRhythm — 스토리모드 기획서

> 게임 전체 기획서: [GDD_v0.1.md](GDD_v0.1.md)

---

## 구조 개요

```
게임
└── 에피소드 (4개)
    └── 챕터 (여러 개, 각각 하나의 사건을 단편적으로 표현)
        └── 스테이지 (챕터당 4개 고정 — 기·승·전·결)
            └── 음악 1곡 (스테이지 1개 = 음악 1개)
```

---

## 에피소드 목록

| 에피소드 | 주인공 | 상태 |
|----------|--------|------|
| [EP1. 그의 이야기](#ep1-그의-이야기) | 남성 인물 | 진행 중 |
| [EP2. 그녀의 이야기](#ep2-그녀의-이야기) | 여성 인물 | 미정 |
| [EP3. 고양이의 이야기](#ep3-고양이의-이야기) | 고양이 | 미정 |
| [EP4. 가족의 이야기](#ep4-가족의-이야기) | 가족 전체 | 미정 |

---

## EP1. 그의 이야기

### 챕터 1 — 탄생, 그리고 소중함

#### 스토리
인천의 어느 평범한 날, 한 생명이 세상에 첫발을 내딛었다.
그는 어려서부터 눈빛이 반짝였다. 또래보다 빠르게 말을 배우고, 주변을 살피며 세상을 흡수했다.

걸음마를 배우던 무렵, 부모님은 그를 데리고 집 근처 대학교 운동장을 자주 찾았다.
넓은 잔디밭 위에서 그는 작은 다리를 움직여 앞으로 나아갔다 — 넘어지고, 일어서고, 또 나아갔다.

그 모습을 지나치던 대학생들이 하나둘 발걸음을 멈췄다.
그들은 쪼그려 앉아 그에게 손을 내밀었고, 그는 낯선 이들의 눈을 피하지 않고 웃어 보였다.
"어머, 너무 귀엽다." "참 똘똘하게 생겼네."

모르는 사람의 따뜻한 손길과 웃음이 그를 감쌌다.
그 사랑이 어떤 언어보다 먼저 그의 몸속에 스며들었고,
그는 그렇게 — 세상은 따뜻하다는 것을 알며 — 무럭무럭 자라났다.

---

#### 스테이지 구성

| 스테이지 | 서사 역할 | 장면 | 음악 방향 | 곡 제목 |
|----------|----------|------|----------|---------|
| Stage 1 | **기** — 탄생 | 인천, 한 생명이 세상에 태어나다. 반짝이는 눈빛, 새로운 세계와의 첫 만남. | 조용하고 따뜻한 피아노. 새벽빛 같은 서정적 분위기 | **Daybreak Lullaby** |
| Stage 2 | **승** — 첫 걸음 | 대학교 운동장의 넓은 잔디밭. 작은 두 발로 앞을 향해 나아가는 연습. 넘어지고 일어서기를 반복. | 조심스럽고 귀여운 리듬. 점차 발걸음처럼 경쾌해지는 전개 | **Tiny Footsteps** |
| Stage 3 | **전** — 사랑을 받다 | 지나가던 대학생들이 멈춰 서서 그에게 손을 내민다. 낯선 이들의 따뜻한 시선과 웃음. | 따뜻하고 포근하게 고조. 여러 악기가 합류하며 풍성해지는 느낌 | **Warm Hands** |
| Stage 4 | **결** — 소중함 | 사랑 속에서 무럭무럭 자라나는 그. 세상이 따뜻하다는 것을 온몸으로 배운 시간. | 잔잔하고 여운 있는 마무리. 희망적이고 포근한 엔딩 | **The World Is Warm** |

#### Suno AI 프롬프트

> Suno AI **Custom Mode** 기준. **Style of Music** 칸에 스타일 태그를, **Lyrics** 칸에 구조 메타태그를 입력하세요. 목표 길이: 2:00~2:30.

##### Stage 1 — 탄생

**Title:** Daybreak Lullaby
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
tender piano, soft strings, lullaby, cinematic, serene, slow tempo, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Solo piano, quiet and intimate, like a first breath of life

[Verse]
Soft strings join, warm flowing melody, simple tender main theme

[Chorus]
Piano and strings together, full main melody blooms, heartfelt and serene

[Bridge]
Gentle arpeggios, twinkling and innocent, lighter texture

[Chorus]
Warm reprise, full orchestration, emotional peak, heartfelt

[Outro]
Solo piano returns, final notes linger softly, peaceful fade to silence
```

##### Stage 2 — 첫 걸음

**Title:** Tiny Footsteps
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
playful piano, light percussion, innocent, cheerful, gradually upbeat, light orchestral, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Hesitant piano notes, tentative like first steps, sweet and light

[Verse]
Light staccato rhythm builds, bouncy and childlike, curious energy

[Chorus]
Cheerful main melody, energetic and joyful, like running on grass

[Bridge]
Brief stumble rhythm, playful pause, then recovery and return

[Chorus]
Full joyful reprise, confident and bright, upbeat peak

[Outro]
Upbeat and confident resolution, small triumphant finish, bright fade
```

##### Stage 3 — 사랑을 받다

**Title:** Warm Hands
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
warm orchestral, heartfelt, emotional build, rich strings, piano, woodwinds, sweeping cinematic, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Gentle piano and violin duet, intimate and warm, quiet opening

[Verse]
More strings layer in, rich warm texture expands, gentle forward motion

[Chorus]
Full orchestra sweeps in, soaring main melody, emotional and heartfelt peak

[Bridge]
Woodwinds carry a softer inner melody, intimate moment of warmth

[Chorus]
Grand orchestral reprise, all instruments united, sweeping and full

[Outro]
Gradual warm resolution, instruments gently fade, final strings linger
```

##### Stage 4 — 소중함

**Title:** The World Is Warm
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
tender piano, soft strings, nostalgic, hopeful, peaceful resolution, lullaby, cinematic, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Piano plays the main theme, familiar and comforting, like a memory

[Verse]
Gentle strings accompany softly, serene and peaceful warmth

[Chorus]
Soft orchestral swell, nostalgic and hopeful, full but gentle

[Bridge]
Quiet reflection, single piano note held, stillness before the end

[Chorus]
Warm full reprise, poignant and tender, all instruments together

[Outro]
Solo piano, final few notes, long pause, silence
```

---

### 챕터 2 — 꿈의 탄생

#### 스토리
초등학교 2학년이 되던 해 생일날, 할머니께서 커다란 상자를 들고 오셨다.
당시로서는 꽤 큰 금액이 드는 PC였다 — 그럼에도 할머니는 망설임 없이 그의 앞에 내려놓으셨다.
그날부터 그는 컴퓨터 앞에서 살기 시작했다.

난생 처음 보는 것들이 넘쳐났다. 화면 너머의 세계는 한없이 넓었고,
그는 더 알고 싶어서 컴퓨터 학원의 문을 두드렸다.
학원에서 그는 마치 물 만난 고기였다. 가르쳐주는 것마다 200%로 흡수했고,
얼마 지나지 않아 친구들 사이에서 '컴퓨터 제일 잘하는 애'가 되어 있었다.

그리고 게임과 마주했다.
화면 속 세계에 빠져들수록 한 가지 생각이 머릿속을 떠나지 않았다.
'나도 이런 걸 만들고 싶다.'

그 순간, 꿈이 태어났다.
그는 그 꿈을 향해, 처음으로 스스로 달려나가기 시작했다.

---

#### 스테이지 구성

| 스테이지 | 서사 역할 | 장면 | 음악 방향 | 곡 제목 |
|----------|----------|------|----------|---------|
| Stage 1 | **기** — 선물 | 생일날, 할머니께서 PC를 선물하시다. 커다란 상자가 열리고 — 화면에 처음으로 불이 켜지는 순간. | 설레고 경이로운 분위기. 반짝이는 소리와 함께 호기심 가득한 가벼운 멜로디 | **Power On** |
| Stage 2 | **승** — 몰입 | 컴퓨터 학원에서 모든 것을 빨아들이듯 배우는 그. 친구들 사이에서 단연 돋보이는 존재가 되다. | 활기차고 집중적인 리듬. 점점 자신감 있게 진행되는 경쾌한 전개 | **Full Immersion** |
| Stage 3 | **전** — 각성 | 컴퓨터 게임에 깊이 빠져드는 그. '나도 이걸 만들고 싶다'는 생각이 머릿속을 가득 채우다. | 감정이 고조되며 웅장해지는 전환. 무언가 각성하는 듯한 드라마틱한 상승 | **Awakening.exe** |
| Stage 4 | **결** — 꿈의 시작 | 꿈이 태어난 순간. 그는 처음으로 스스로의 방향을 정하고 그 길을 향해 달리기 시작한다. | 희망차고 결의에 찬 마무리. 앞으로 나아가는 여정을 예고하는 힘 있는 엔딩 | **Dream Ignition** |

#### Suno AI 프롬프트

> Suno AI **Custom Mode** 기준. **Style of Music** 칸에 스타일 태그를, **Lyrics** 칸에 구조 메타태그를 입력하세요. 목표 길이: 2:00~2:30.

##### Stage 1 — 선물

**Title:** Power On
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
electronic wonder, sparkly synth, magical discovery, playful, light and bright, chiptune-inspired, curious, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Single synth note blooms into cascading sparkles, like a screen turning on for the first time

[Verse]
Light curious melody wanders, full of wonder, exploring every corner of the sound

[Chorus]
Bright cheerful main theme bursts in, magical discovery, joyful and shimmering

[Bridge]
Playful arpeggios dance, each note a new surprise, light and bubbly

[Chorus]
Full joyful reprise, sparkling and excited, peak wonder

[Outro]
Melody winds down gently, satisfied and glowing, soft fade
```

##### Stage 2 — 몰입

**Title:** Full Immersion
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
energetic electronic, chiptune, driving beat, focused, confident, upbeat, 8-bit influenced, synth melody, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Driving beat hits from the first second, focused and sharp, no hesitation

[Verse]
Synth melody cuts over the steady rhythm, determined and precise, building fast

[Chorus]
Full electronic arrangement explodes in, high energy, unstoppable momentum

[Bridge]
Beat breaks down briefly, tension holds, then explosive return

[Chorus]
Peak energy, layered synths and beat at full power, relentless drive

[Outro]
Confident resolution, beat pulses down, ends with a sharp final note
```

##### Stage 3 — 각성

**Title:** Awakening.exe
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
epic orchestral electronic hybrid, dramatic awakening, cinematic, powerful build, intense, triumphant, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Low strings and subtle electronics, quiet tension, something stirs underneath

[Build Up]
Gradual layering — strings, then synth, then percussion — rising intensity, inevitable

[Chorus]
Full epic climax, orchestra and electronics united, overwhelming and triumphant

[Bridge]
A single moment of stillness, held breath, the realization crystallizes

[Drop]
Explosive return of full arrangement, unstoppable force, maximum energy

[Outro]
Power fades but never dies, a steady pulse remains, determined ending
```

##### Stage 4 — 꿈의 시작

**Title:** Dream Ignition
**Duration:** 2:00 ~ 2:30

**Style of Music**
```
triumphant orchestral, hopeful, determined, inspiring, march-like drive, soaring melody, cinematic epic, instrumental, no lyrics
```

**Lyrics**
```
[Intro]
Bold main theme stated clearly and confidently, no hesitation, forward motion

[Verse]
Full orchestra with driving rhythm, purposeful and marching ahead, strong melody

[Chorus]
Soaring epic melody takes flight, the dream made real, unstoppable and glorious

[Bridge]
Brief reflective pause, strings alone, then renewed determination ignites

[Chorus]
Grand finale sweep, all instruments at full, magnificent and powerful

[Outro]
Final notes ring out boldly, then silence — the journey has just begun
```

---

## EP2. 그녀의 이야기

> 미정

---

## EP3. 고양이의 이야기

> 미정

---

## EP4. 가족의 이야기

> 미정
