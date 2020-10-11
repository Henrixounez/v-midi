module vmidi

type TrkData =
	SequenceNumber | TextEvent | CopyrightNotice |
	TrackName | InstrumentName | Lyrics | Marker |
	CuePoint | MidiChannelPrefix | EndOfTrack |
	SetTempo | SMPTEOffset | TimeSignature |
	KeySignature | SequencerSpecific |
	
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
	tempo 	int = 120
	data	[]TrkData
}

struct Midi {
pub mut:
	format_type int
	number_tracks int
	time_division int
	tracks []Track
}