module main
import vmidi
import math
import audio
import os
import time
import sync

fn play_track(track_nb int, track vmidi.Track, mut ctx audio.Context, mut wg sync.WaitGroup) {
	for event in track.data {
		if event.is_event() {
			match event {
				vmidi.NoteOn {
					note := f32(440 * math.pow(2, (f32(event.note) - 69) / 12))
					time.sleep_ms(int(event.delta_time))
					if event.velocity != 0 {
						ctx.play(note, 0.2)
					} else {
						ctx.pause(note)
					}
				}
				vmidi.NoteOff {
					note := f32(440 * math.pow(2, (f32(event.note) - 69) / 12))
					time.sleep_ms(int(event.delta_time))
					ctx.pause(note)
				}
				else {}
			}
		}
	}
	wg.done()
}

fn main() {
	if os.args.len != 2 {
		return
	}
	file := os.args[1]
	midi := vmidi.parse(file) or {
		println('error')
		return
	}
	mut ctx := audio.new_context()
	mut wg := sync.new_waitgroup()
	wg.add(midi.tracks.len)

	for track_nb, track in midi.tracks {
		go play_track(track_nb, track, mut ctx, mut wg)
	}
	wg.wait()
}