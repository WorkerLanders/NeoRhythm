import json
import random
import os

BPM = 72
DURATION = 104.4
BEAT_INTERVAL = 60 / BPM        # 0.833초
NOTE_EVERY_N_BEATS = 2          # 2비트마다 노트 1개 (느린 곡)
LANES = 4
AUDIO = "Resources/First Dawn Lullaby.mp3"
OUTPUT = "Resources/beatmaps/ep1_ch1_stage1.json"

def generate_beatmap():
    notes = []
    lane = 0
    time = BEAT_INTERVAL * 2    # 인트로 2비트 여백

    while time < DURATION - BEAT_INTERVAL:
        notes.append({
            "time": round(time, 3),
            "lane": lane,
            "type": "tap"
        })
        lane = (lane + 1) % LANES
        time += BEAT_INTERVAL * NOTE_EVERY_N_BEATS

    beatmap = {
        "title": "First Dawn Lullaby",
        "episode": 1,
        "chapter": 1,
        "stage": 1,
        "bpm": BPM,
        "duration": DURATION,
        "audio": AUDIO,
        "notes": notes
    }

    os.makedirs(os.path.dirname(f"D:/NeoRhythm/{OUTPUT}"), exist_ok=True)
    out_path = f"D:/NeoRhythm/{OUTPUT}"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(beatmap, f, ensure_ascii=False, indent=2)

    print(f"생성 완료: {out_path}")
    print(f"총 노트 수: {len(notes)}")
    print(f"첫 노트: {notes[0]}")
    print(f"마지막 노트: {notes[-1]}")

if __name__ == "__main__":
    generate_beatmap()
