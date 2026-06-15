import librosa
import sys

def analyze_bpm(filepath):
    print(f"분석 중: {filepath}")
    y, sr = librosa.load(filepath)
    tempo, beats = librosa.beat.beat_track(y=y, sr=sr)
    bpm = float(tempo[0]) if hasattr(tempo, '__len__') else float(tempo)
    duration = librosa.get_duration(y=y, sr=sr)
    minutes = int(duration // 60)
    seconds = int(duration % 60)
    print(f"BPM     : {bpm:.1f}")
    print(f"길이    : {minutes}분 {seconds}초 ({duration:.1f}초)")
    print(f"박자 수 : {len(beats)}")

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else r"D:\NeoRhythm\Resources\First Dawn Lullaby.mp3"
    analyze_bpm(path)
