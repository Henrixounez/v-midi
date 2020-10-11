module vmidi

fn read_track(file []byte, index int, chunk_size int) ?Track {
	mut track := Track{}
	mut index_track := index
	mut divide_sysex := []byte{}
	mut last_status := byte(0)

	for index_track < index + chunk_size {
		delta_time := get_variable_length_value(file, mut &index_track)
		match file[index_track] {
			0xF0, 0xF7 { // SYSEX
				sysex := read_sysex(file, mut &index_track, delta_time, mut divide_sysex)
				if sysex.data.len != 0 {
					track.data << sysex
				}
			}
			0xFF { // META EVENT
				meta := read_meta(file, mut &index_track, delta_time) or {
					return none
				}
				track.data << meta
			}
			else {
				event := read_midi_event(file, mut &index_track, delta_time, mut &last_status) or {
					return none
				}
				track.data << event
			}
		}
	}
	return track
}

fn read_chunks(file []byte) ?Midi {
	mut midi := Midi{}
	mut index := 0
	for index < file.len {
		chunk_name := [file[index], file[index + 1], file[index + 2], file[index + 3]].bytestr()
		index += 4
		chunk_size := byte_to_int(subarray(file, index, index + 4))
		index += 4
		match chunk_name {
			'MThd' {
				midi.format_type = byte_to_int(subarray(file, index, index + 2))
				midi.number_tracks = byte_to_int(subarray(file, index + 2, index + 4))
				midi.time_division_ = byte_to_int(subarray(file, index + 4, index + 6))
			}
			'MTrk' {
				track := read_track(file, index, chunk_size) or {
					return none
				}
				midi.tracks << track
			}
			else {
				println('Unknown chunk $chunk_name')
				return none
			}
		}
		index += chunk_size
	}
	return midi
}