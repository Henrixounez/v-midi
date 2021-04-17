module vmidi

fn byte_to_int(bytes []byte) int {
	mut res := 0
	for i in 0 .. bytes.len {
		res += bytes[bytes.len - (i + 1)] << ((i) * 8)
	}
	return res
}

fn get_variable_length_value(bytes []byte, mut shift_index &int) u64 {
	mut value := u64(0)
	mut index := 0

	for {
		value += bytes[index + (*shift_index)] & 0x7f
		if int(bytes[index + (*shift_index)] >> 7) == 0 {
			break
		}
		value <<= 7
		index++
	}
	(*shift_index) += (index + 1)
	return value
}

fn subarray(arr []byte, start int, end int) []byte {
	mut res := []byte{len: end - start}
	for i in 0 .. (end - start) {
		res[i] = arr[start + i]
	}
	return res
}