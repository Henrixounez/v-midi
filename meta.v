module vmidi

struct SequenceNumber {
	delta_time u64
	msb byte
	lsb byte
}
struct TextEvent {
	delta_time u64
	text string
}
struct CopyrightNotice {
	delta_time u64
	text string
}
struct TrackName {
	delta_time u64
	text string
}
struct InstrumentName {
	delta_time u64
	text string
}
struct Lyrics {
	delta_time u64
	text string
}
struct Marker {
	delta_time u64
	text string
}
struct CuePoint {
	delta_time u64
	text string
}
struct MidiChannelPrefix {
	delta_time u64
	channel byte
}
struct EndOfTrack {
	delta_time u64
}
struct SetTempo {
	delta_time u64
	microseconds int
}
struct SMPTEOffset {
	delta_time u64
	hour	byte
	min		byte
	sec		byte
	fr		byte
	subfr	byte
}
struct TimeSignature {
	delta_time u64
	numer	byte
	denom	byte
	metro	byte
	nds		byte
}
struct KeySignature {
	delta_time u64
	key		byte
	scale	byte
}
struct SequencerSpecific {
	delta_time u64
	data	[]byte
}

fn read_meta(file []byte, mut index_track &int, delta_time u64) TrkData {
	mut index := (*index_track) + 1

	meta_type := file[index]
	index++
	length := get_variable_length_value(file, mut &index)
	data := subarray(file, index, index + int(length))
	index += int(length)
	mut meta := TrkData{}
	match meta_type {
		0x00 {
			meta = SequenceNumber {
				delta_time: delta_time
				msb: data[0]
				lsb: data[1]
			}
		}
		0x01 {
			meta = TextEvent {
				delta_time: delta_time
				text: data.bytestr()
			}
		}
		0x02 {
			meta = CopyrightNotice {
				delta_time: delta_time
				text: data.bytestr()
			}
		}
		0x03 {
			meta = TrackName {
				delta_time: delta_time
				text: data.bytestr()
			}
		}
		0x04 {
			meta = InstrumentName {
				delta_time: delta_time
				text: data.bytestr()
			}
		}
		0x05 {
			meta = Lyrics {
				delta_time: delta_time
				text: data.bytestr()
			}
		}
		0x06 {
			meta = Marker {
				delta_time: delta_time
				text: data.bytestr()
			}
		}
		0x07 {
			meta = CuePoint {
				delta_time: delta_time
				text: data.bytestr()
			}
		}
		0x20 {
			meta = MidiChannelPrefix {
				delta_time: delta_time
				channel: data[0]
			}
		}
		0x2f {
			meta = EndOfTrack {}
				delta_time: delta_time
		}
		0x51 {
			meta = SetTempo {
				delta_time: delta_time
				microseconds: byte_to_int(data)
			}
		}
		0x54 {
			meta = SMPTEOffset {
				delta_time: delta_time
				hour: data[0]
				min: data[1]
				sec: data[2]
				fr: data[3]
				subfr: data[4]
			}
		}
		0x58 {
			meta = TimeSignature {
				delta_time: delta_time
				numer: data[0]
				denom: data[1]
				metro: data[2]
				nds	: data[3]
			}
		}
		0x59 {
			meta = KeySignature {
				delta_time: delta_time
				key: data[0]
				scale: data[1]
			}
		}
		0x7f {
			meta = SequencerSpecific {
				delta_time: delta_time
				data: data
			}
		}
		else {
			println('UNKNOWN META ${meta_type.hex()}')
		}
	}
	(*index_track) = index
	return meta
}