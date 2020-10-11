module vmidi

import os

pub fn (mut midi Midi)time_division() {
	mut mpqn := 500000
	mut tick := 0

	for event in midi.tracks[0].data {
		match event {
			SetTempo {
				mpqn = event.microseconds
			}
			else {}
		}
	}
	if midi.time_division_ & 0x8000 == 0 {
		ticks_per_beat := midi.time_division_ & 0x7FFFF
		tick = mpqn / ticks_per_beat
	} else {
		fps := midi.time_division_ & 0x7F00
		tpf := midi.time_division_ & 0x00FF
		tick = 1000000 / (fps * tpf)
	}
	midi.micros_per_tick = tick
}

pub fn parse(filename string) ?Midi {
	file := os.read_file(filename) or {
		return none
	}
	mut file_bytes := []byte{len: file.len}
	for i, b in file {
		file_bytes[i] = byte(b)
	}
	mut midi := read_chunks(file_bytes)
	midi.time_division()
	for i in 0..midi.tracks.len {
		midi.tracks[i].nb = i
	}
	return midi
}

pub fn (data TrkData) is_event() bool {
	if data is NoteOff ||
	   data is NoteOn ||
	   data is NoteAftertouch ||
	   data is Controller ||
	   data is ProgramChange ||
	   data is ChannelAftertouch ||
	   data is PitchBend
	 {
		return true
	}
	return false
}