module vmidi

type TrkData =
	SequenceNumber | TextEvent | CopyrightNotice |
	TrackName | InstrumentName | Lyrics | Marker |
	CuePoint | DeviceName | MidiChannelPrefix |
	EndOfTrack | SetTempo | SMPTEOffset | 
	TimeSignature | KeySignature | SequencerSpecific |
	
	SysEx |
	
	NoteOff | NoteOn | NoteAftertouch | Controller |
	ProgramChange | ChannelAftertouch | PitchBend

type Meta = SequenceNumber | TextEvent | CopyrightNotice |
	TrackName | InstrumentName | Lyrics | Marker |
	CuePoint | MidiChannelPrefix | EndOfTrack |
	SetTempo | SMPTEOffset | TimeSignature |
	KeySignature | SequencerSpecific

struct Track {
pub mut:
	nb int
	data	[]TrkData
}

struct Midi {
mut:
	time_division_ int
pub mut:
	format_type int
	number_tracks int
	tracks []Track
	micros_per_tick int
}