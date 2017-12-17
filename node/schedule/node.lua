gl.setup(1920,770)

local json = require"json"


local next_talks = nil

local SPEAKER_SIZE = 50
local TITLE_SIZE = 80
local NX_SIZE = 50
local NXS_SIZE = 30
local LEADING = 10
local TAB_WIDTH = 250


local clock = (function()
  local base_time = N.base_time or 0
  local unix_time = N.base_time or 0

  local function set(time)
    base_time = tonumber(time) - sys.now()
    prepare_talks()
  end

  local function uset(utime)
    unix_time = tonumber(utime) - sys.now()
  end

  util.data_mapper{
    ["clock/set"] = function(time)
      set(time)
    end;
    ["clock/unixtime"] = function (utime)
      print("time updated, base ", base_time, " epoch ", unix_time)
      uset(utime)
    end;
  }

  local left = 0

  local function get()
    local time = (base_time + sys.now()) % 86400
    return string.format("%d:%02d", math.floor(time / 3600), math.floor(time % 3600 / 60))
  end

  local function unixtime()
    local utime = unix_time + sys.now()
    return tonumber(utime)
  end

  return {
    get = get;
    set = set;
    unixtime = unixtime;
    uset = uset;
  }
end)()


function prepare_talks()
  local now = clock.unixtime()
  local lineup = {}
  for idx = 1, #talks do
    local talk = talks[idx]
      if now > talk.start_unix and now < talk.end_unix then
        print("Now: ", now, " start ", talk.start_unix, " end ", talk.end_unix)
        lineup[#lineup+1] = talk
      end
      if talk.start_unix > now and #lineup < 10 then
        lineup[#lineup+1] = talk
print("Filler Now: ", now, " start ", talk.start_unix, " end ", talk.end_unix)
      end
  end

  table.sort(lineup, function(t1, t2)
    return t1.start_unix < t2.start_unix or (t1.start_unix == t2.start_unix and t1.place < t2.place)
  end)

  print(#talks, "talks, ", #lineup, "lineups")
  next_talks = lineup
end


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

  local y = 60
  local x = 100

-- Lineup is empty: No more talks for now
  if next_talks == nil or #next_talks == 0 then
    bold:write(100, 170, "Vorerst Sendepause!", 150, 0,0,0, 1)
    italic:write(100, 340, "No talks right now", 150, 0,0,0, 1)
  else
    for idx = 1, #next_talks do
      local talk = next_talks[idx]
      local x_cursor = x

      -- check whether the current talk still fits onto the screen
      if y + TITLE_SIZE + SPEAKER_SIZE > HEIGHT then
        break
      end

      -- prepare local time for comparison with the start time of
      -- the current talk
      local now = clock.unixtime()
      local time
      local time_sub
      local until_start = talk.start_unix - now
      local until_end = now - talk.end_unix
      local title = talk.title
      local sub = talk.place .. " · von/mit "
      for i, speaker in ipairs(talk.speakers) do
        sub = sub .. speaker .. "; "
      end
      if until_start > 0 and until_start < 60*60 then
        time = talk.start
        time_sub = string.format("in %d min", math.floor(until_start/60))
        font:write(x_cursor, y, time, TITLE_SIZE, 0,0,0, 1)
        italic:write(x_cursor, y + SPEAKER_SIZE, time_sub, SPEAKER_SIZE, 0,0,0, 1)
        x_cursor = x_cursor + TAB_WIDTH
        font:write(x_cursor, y, title, TITLE_SIZE, 0,0,0, 1)
      elseif talk.start_unix > now then
        time = talk.start
        font:write(x_cursor, y, time, NX_SIZE, 0,0,0, 1)
        x_cursor = x_cursor + 250
        font:write(x_cursor, y, title, NX_SIZE, 0,0,0, 1)
        y = y + NX_SIZE + LEADING
        italic:write(x_cursor, y, sub, NXS_SIZE, 0,0,0, 1)
        y = y + NXS_SIZE + LEADING
      else
        time = "Jetzt"
        time_sub = string.format("noch %d\'", math.ceil(-until_end/60))
        font:write(x_cursor, y, time, TITLE_SIZE, 0,0,0, 1)
        italic:write(x_cursor, y + TITLE_SIZE, time_sub, SPEAKER_SIZE, 0,0,0, 1)
        x_cursor = x_cursor + TAB_WIDTH
        font:write (x_cursor, y, title, TITLE_SIZE, 0,0,0, 1)
        italic:write(x_cursor, y +  TITLE_SIZE, sub, SPEAKER_SIZE, 0,0,0, 1)
        y = y + TITLE_SIZE + SPEAKER_SIZE + 2 * LEADING
      end
     
    end
  end
end
