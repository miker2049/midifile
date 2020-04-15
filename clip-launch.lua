--norns script to launch midi clips from grid

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
