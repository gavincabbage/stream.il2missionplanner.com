local streamName = ARGV[1]
local password = ARGV[2]
local code = ARGV[3]
local state = ARGV[4]

local function setupPRNG()
    math.randomseed(os.time())
    math.random(); math.random(); math.random()
end

local function buildChannelName(streamName)
    local s = streamName
    for i = 1, 16 do
        s = s .. ':' .. string.char(math.random(48, 57))
    end
    return s
end

if not streamName or not password or not code or not state then
    return 1
end

if redis.call('EXISTS', 'stream:' .. streamName) ~= 0 then
    return 2
end

setupPRNG()
local channel = buildChannelName(streamName)
if not channel then
    return 3
end

redis.call('HMSET', 'stream:' .. streamName, 'name', streamName, 'pw', password,
        'code', code, 'channel', channel, 'state', state)

return channel
