# V MIDI Files Parser / Player

#### Thank you @spaceface777 and @spytheman for the help with the sinewave Audio Generator :heart:

<br/>

## How to use :
You have easy access interface for parsing and playing the midi file :
```v
import vmidi

midi := vmidi.parse(file) or { return }
midi.play()
```

<br/>

## Methods
|Method|use|
|-|-|
|`.parse(filename string) ?Midi`| Returns an optional `Midi` structure with the parsed `filename` file|
|`.play(midi Midi)`| Plays the tunes of the `Midi` file|