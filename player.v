module vmidi

import audio
import sync
import time
import math

fn (track Track)play(mut ctx audio.Context, mut wg sync.WaitGroup, micros_per_tick int) {
	for event in track.data {
		if event.is_event() {
			match event {
				NoteOn {
					note := f32(440 * math.pow(2, (f32(event.note) - 69) / 12))
					sleep := event.delta_time * u64(micros_per_tick)
					time.sleep_ms(int(sleep / 1000))
					if event.velocity != 0 {
						ctx.play(note, 0.2)
					} else {
						ctx.pause(note)
					}
				}
				NoteOff {
					note := f32(440 * math.pow(2, (f32(event.note) - 69) / 12))
					sleep := event.delta_time * u64(micros_per_tick)
					time.sleep_ms(int(sleep / 1000))
					ctx.pause(note)
				}
				else {}
			}
		}
	}
	wg.done()
}

pub fn (midi Midi)play() {
	mut ctx := audio.new_context()
	mut wg := sync.new_waitgroup()
	wg.add(midi.tracks.len)

	for track in midi.tracks {
		go track.play(mut ctx, mut wg, midi.micros_per_tick)
	}
	wg.wait()
}