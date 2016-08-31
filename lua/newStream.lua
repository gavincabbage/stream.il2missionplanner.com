local streamName = ARGV[1]
local password = ARGV[2]
local code = ARGV[3]

function buildChannelName(streamName)
    local s = streamName
    for i = 1, 8 do
        s = s .. string.char(math.random(48, 57))
    end
    return s

if not streamName or not password or not code then
    return 1
end

if redis.call('EXISTS', 'stream:' .. streamName) then
    return 2
end

local channel = buildChannelName(streamName)

redis.call('HMSET', 'stream:' .. streamName, 'name', streamName, 'pw', password,
        'code', code, 'channel', channel, 'state', '')

return channel
