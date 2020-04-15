--midifile lib/script for norns
--loop sections of midifile, transpose and alter time wise
--can parse the midi file by ticks to get measure info
--
local midi = require "MIDI"
local inspect = require "inspect"

local midifile = {}

--returns a midifile object from
function midifile.parseMidi(midifile)
  local mididata = assert(io.open(midifile,'rb')) --opening binary
  local midistring = mididata:read('*all') --reading into string
  local file = {}
  local mainscore = midi.midi2score(midistring)
  -- {'note', start_time, duration, channel, note, velocity} -- in a score
  file.stats = midi.score2stats(mainscore)
  file.ppq = mainscore[1]  --assigning ppq

  --initialize our big play table
  file.playtable ={}

  for i=0,file.stats.nticks do
    file.playtable[i]={}
  end

  for itrack = 2,#mainscore do  -- skip 1st element, which is ticks
    for k,event in ipairs(mainscore[itrack]) do
      local trackevent = event
      event.track = itrack
      table.insert(file.playtable[event[2]],event)
    end
  end
  return file
end

--testing so far
local file = midifile.parseMidi("test.mid")
io.output('midiout.txt')
io.write(inspect(file))

