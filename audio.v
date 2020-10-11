// © spaceface
// Not mine

module audio

import math
import sokol.audio as saudio

const (
	tau    = 2 * math.pi
)

pub struct Note {
mut:
	freq f32
	vol  f32
}

[inline]
fn (note &Note) next(time f32) f32 {
    return math.sinf(tau * time * note.freq) * note.vol
}

pub struct Context {
mut:
	notes []Note
	t     f32
}

pub fn (mut ctx Context) play(freq, volume f32) {
	ctx.notes << Note{ freq, volume }
}

pub fn (mut ctx Context) pause(freq f32) {
	ctx.notes = ctx.notes.filter(it.freq != freq)
}

fn audio_cb(mut buffer &f32, num_frames, num_channels int, ctx_ voidptr) {
	mut ctx := &Context(ctx_)
	unsafe {
		for frame in 0 .. num_frames {
			for ch in 0 .. num_channels {
				idx := frame * num_channels + ch
				buffer[idx] = 0
				for note in ctx.notes {
					buffer[idx] += note.next(ctx.t)
				}
			}
			ctx.t += 1 / f32(C.saudio_sample_rate())
		}
	}
}

pub fn new_context() &Context {
	mut ctx := &Context{
		notes: []
		t: 0
	}
	saudio.setup({
		user_data: ctx
		stream_userdata_cb: audio_cb
	})
	return ctx
}
