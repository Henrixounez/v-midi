module vmidi

import os

pub fn parse(filename string) ?Midi {
	file := os.read_file(filename) or {
		return none
	}
	mut file_bytes := []byte{len: file.len}
	for i, b in file {
		file_bytes[i] = byte(b)
	}
	return read_chunks(file_bytes)
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