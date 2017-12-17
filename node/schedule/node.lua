gl.setup(1920,770)

local json = require"json"

local base_time = N.base_time or 0

local next_talks = nil

local SPEAKER_SIZE = 50
local TITLE_SIZE = 60
local TIME_SIZE = 60


function prepare_talks()
  local now = sys.now() + base_time
  local lineup = {}
  for idx = 1, #talks do
    local talk = talks[idx]
      if now > talk.start_unix and now < talk.end_unix then
        lineup[#lineup+1] = talk
      end
      if talk.start_unix > now and #lineup < 8 then
        lineup[#lineup+1] = talk
      end
  end

  table.sort(lineup, function(t1, t2)
    return t1.start_unix < t2.start_unix or (t1.start_unix == t2.start_unix and t1.place < t2.place)
  end)

  print(#talks, "talks, ", #lineup, "lineups")
  next_talks = lineup
end

util.data_mapper{
  ["clock/set"] = function(time)
    base_time = tonumber(time) - sys.now()
    N.base_time = base_time
    print("UPDATED TIME", base_time, "time ", time)
    prepare_talks()
  end;
}

util.file_watch("schedule.json", function(content)
  talks = json.decode(content)
  print("SCHEDULE UPDATED, ", #talks , "talks")
  prepare_talks()
end)

font = resource.load_font("OpenSans-Regular.ttf")
bold = resource.load_font("OpenSans-Bold.ttf")
italic = resource.load_font("OpenSans-Italic.ttf")

function node.render()
  gl.clear(1,1,1,0.5)

-- Lineup is empty: No more talks for now
  if #next_talks == 0 then
    bold:write(100, 170, "Vorerst Sendepause!", 150, 0,0,0, 1)
    italic:write(100, 340, "No talks right now", 150, 0,0,0, 1)
  end
end
