module vmidi

struct NoteOff {
pub:
	delta_time u64
	channel byte
	note byte
	velocity byte
}
struct NoteOn {
pub:
	delta_time u64
	channel byte
	note byte
	velocity byte
}
struct NoteAftertouch {
pub:
	delta_time u64
	channel byte
	note byte
	amount byte
}
struct Controller {
pub:
	delta_time u64
	channel byte
	controller_type byte
	value byte
}
struct ProgramChange {
pub:
	delta_time u64
	channel byte
	program_number byte
}
struct ChannelAftertouch {
pub:
	delta_time u64
	channel byte
	amount byte
}
struct PitchBend {
pub:
	delta_time u64
	channel byte
	lsb byte
	msb	byte
}

fn read_midi_event(file []byte, mut index_track &int, delta_time u64) TrkData {
	mut index := (*index_track)

	event_type := byte(file[index] & 0xf0) >> 4
	midi_channel := byte(file[index] & 0x0f)
	index++
	mut event := TrkData{}
	match event_type {
		0x08 {
			event = NoteOff {
				delta_time: delta_time
				channel: midi_channel
				note: file[index]
				velocity: file[index + 1]
			}
		}
		0x09 {
			event = NoteOn {
				delta_time: delta_time
				channel: midi_channel
				note: file[index]
				velocity: file[index + 1]
			}
		}
		0x0a {
			event = NoteAftertouch {
				delta_time: delta_time
				channel: midi_channel
				note: file[index]
				amount: file[index + 1]
			}
		}
		0x0b {
			event = Controller {
				delta_time: delta_time
				channel: midi_channel
				controller_type: file[index]
				value: file[index + 1]
			}
		}
		0x0c {
			event = ProgramChange {
				delta_time: delta_time
				channel: midi_channel
				program_number: file[index]
			}
		}
		0x0d {
			event = ChannelAftertouch {
				delta_time: delta_time
				channel: midi_channel
				amount: file[index]
			}
		}
		0x0e {
			event = PitchBend {
				delta_time: delta_time
				channel: midi_channel
				lsb: file[index]
				msb: file[index + 1]
			}
		}
		else {
			println('UNKNOWN EVENT: ${int(event_type).hex()} ${file[index - 1]}')
			return TrkData{}
		}
	}
	index++
	if event_type != 0x0c && event_type != 0x0d {
		index++
	}
	(*index_track) = index
	return event
}