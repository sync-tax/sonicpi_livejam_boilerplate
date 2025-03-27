"_- {TrackTitle_v.X} ~ [chaotic_algorithms] by TRIBΞHOLZ -_'
_-_-__--_-_--__-_--__-___--_-_--_--_-_-_-__--_-_--__-_--_-."
#---------------------------------------------------------
#PRESETS
use_bpm 140
use_debug false
use_real_time

#---------------------------------------------------------
#SAMPLES
track_title = "TrackTitle"
s = "C:/Users/rober/Desktop/TRIBΞHOLZ/!SonicPi/Tracks/#{track_title}/samples"

#---------------------------------------------------------
#METRONOME
live_loop :metro do
  sleep 1
end

#---------------------------------------------------------
#PATTERNS
define :pattern do |p|
  return p.ring.tick == "x" # if specifc char equals "x" -> hit on that beat
end

p = ("xxx-xxx-")

#---------------------------------------------------------
#MIDI MIXER
define :scale_midi do |val, min, max|
  return min + (val.to_f / 127) * (max - min) # Allows for setting a specific range to MIDI-controls
end

$midi_values ||= Hash.new(0.0) # Avoid "nil"-Error by setting each MIDI-control value to 0.0 ONCE

live_loop :midi_controls do
  key, value = sync "/midi:midi_mix_1:1/control_change" # MIDI Device
  
  case key
  when 19
    $midi_values[19] = scale_midi(value, 0, 0.5)
    
  when 62
    $MASTER = scale_midi(value, 0, 1)
  end
end

#---------------------------------------------------------
#LOOPS
live_loop :example, sync: :metro do
  if pattern(p)
    sample :bd_haus,
      amp: $midi_values[19] * $MASTER
  end
  sleep 1
end