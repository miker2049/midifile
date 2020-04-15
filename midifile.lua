--midifile lib/script for norns
--loop sections of midifile, transpose and alter time wise
--can parse the midi file by ticks to get measure info
--
local midi = require "MIDI"
local inspect = require "inspect"

local function parseMidi(midifile)
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

local file = parseMidi("test.mid")
io.output('midiout.txt')
io.write(inspect(file))

local clip ={
  --pg1
  start=nil,
  length=nil,
  speedmod=0,
  --pg2
  tracks=-1, -- -1 is all tracks
  channels=-1, -- all channels by default
  chance=1,
  --pg3
  velmod=0,
  transpose=0,
  transchance=1,
  --pg4
  harm=0,
  harmchance=1,
  --pg5,
  stutter=1, --by default, is stutterrable
  stuttermod=1, --local stutter mod
  --pg6
  loop=1, --loop by default
  looptimes=-1, --infinite loop by default
  latch=1, --default latch, else gate
}
local global_config = {
  bpm=120,
  tquant={}, --global time quant
  pquant={}, --global pitch quant
  mutegroups={"none"}, --none, row, col, all... that is, you can set it up that row neighbors block each other, column neighbors, or all of them, or none
  stutterdiv=1/8,

}
--5x5 grid of clips, 2x3 grid of parameters for each one, 1 "trig" key, 1 stutter key, 1 global latch, 1 clip copy, 4 pattern record keys
-- {
-- {{c},{c},{c},{c},{c},{ },{ },{p}},
-- {{c},{c},{c},{c},{c},{ },{ },{p}},
-- {{c},{c},{c},{c},{c},{ },{ },{p}},
-- {{c},{c},{c},{c},{c},{ },{ },{p}},
-- {{c},{c},{c},{c},{c},{ },{ },{ }},
-- {{ },{ },{ },{ },{ },{x},{ },{ }},
-- {{p},{p},{p},{ },{ },{ },{ },{l}},
-- {{p},{p},{p},{ },{ },{ },{s},{t}},
-- }
