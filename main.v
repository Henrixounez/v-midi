module main
import vmidi
import math
import audio
import os
import time

fn main() {
	if os.args.len != 2 {
		return
	}
	file := os.args[1]
	midi := vmidi.parse(file) or {
		println('error')
		return
	}
	mut index := 0

	mut ctx := audio.new_context()

	for track_nb, track in midi.tracks {
		for event in track.data {
			if event.is_event() {
				match event {
					vmidi.NoteOn {
						time.sleep_ms(int(event.delta_time))
						println('[$track_nb $event.channel]: NoteOn  $event.note $event.delta_time')
						note := f32(440 * math.pow(2, (f32(event.note) - 69) / 12))
						ctx.play(note, 0.2)
					}
					vmidi.NoteOff {
						time.sleep_ms(int(event.delta_time))
						println('[$track_nb $event.channel]: NoteOff $event.note $event.delta_time')
						note := f32(440 * math.pow(2, (f32(event.note) - 69) / 12))
						ctx.pause(note)
					}
					else {}
				}
			}
		}
	}
}