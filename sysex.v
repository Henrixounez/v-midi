module vmidi

struct SysEx {
	delta_time u64
	data	[]byte
}

fn read_sysex(file []byte, mut index_track &int, delta_time u64, mut divide_sysex []byte) SysEx {
	mut index := (*index_track)

	// sysex_type := file[index]
	index++
	length := get_variable_length_value(file, mut &index)
	data := subarray(file, index, index + int(length))

	unsafe {
		divide_sysex.push_many(data, data.len)
	}
	if data[data.len - 1] != 0xF7 {
		return SysEx {
			data: []byte{}
		}
	}
	index += int(length)
	(*index_track) = index
	sysex := SysEx {
		data: divide_sysex
	}
	divide_sysex.clear()
	return sysex
}
