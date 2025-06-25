"_- MIDI-JAM ~ [boilerplate] by TRIBΞHOLZ -_'
_-_-__--_-_--__-_--__-___--_-_--_--_-_-_-__-."
#---------------------------------------------------------
#PRESETS
use_bpm 146
use_debug false
use_real_time

#---------------------------------------------------------
#SAMPLES
#Define your samples inside the hash map
#Use by calling s[:sample_name]

s_path = "C:/your/sample/path/here/sample.wav"

s = {
  kick: "#{s_path}/kicks/kick (99).wav",
}

#---------------------------------------------------------
#METRONOME
#Use for syncing
#Allows changig sleep values without getting out of sync

live_loop :metro do
  sleep 1
end

#---------------------------------------------------------
#PATTERNS
#Define patterns by passing a string
#Each character represents one beat tick
#Hits whenever the current char equals "x"

define :pattern do |p|
  return p.ring.tick == "x"
end

p = ("xxx-xxx-")

#---------------------------------------------------------
#MIDI MIXER
#Define MIDI controls inside the Switch & map to desired range

#Allows for setting a specific range to MIDI-controls
define :scale_midi do |val, min, max|
  return min + (val.to_f / 127) * (max - min)
end

#Avoid "nil"-error by setting each MIDI-control value to 0.0 ONCE
$midi_values ||= Hash.new(0.0)

live_loop :midi_controls do
  key, value = sync "/midi:midi_mix_1:1/control_change" #Your MIDI Device
  
  case key
  when 19
    $midi_values[19] = scale_midi(value, 0, 1)
  when 23
    $midi_values[23] = scale_midi(value, 0, 0.4)
  end
end


#---------------------------------------------------------
#MIXER
#Use either as fallback or instead of the MIDI MIXER section

kick_amp = 0.0
snare_amp = 0.0


#---------------------------------------------------------
#LOOPS

live_loop :example_kick, sync: :metro do
  sample s[:kick],
    amp: $midi_values[19] != 0 ? $midi_values[19] : kick_amp
  sleep 1
end
