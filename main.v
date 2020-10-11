module main
import vmidi
import os

fn main() {
	if os.args.len != 2 {
		return
	}
	file := os.args[1]
	midi := vmidi.parse(file) or {
		println('error')
		return
	}
	midi.play()
}