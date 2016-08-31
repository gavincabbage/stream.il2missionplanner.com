local streamName = ARGV[1]
local password = ARGV[2]
local code = ARGV[3]
local state = ARGV[4]

if not streamName or not password or not code or not state then
    return 1
end

if redis.call('EXISTS', 'stream:' .. streamName) == 0 then
    return 2
end

local streamKey = 'stream' .. streamName
local fields = redis.call('HMGET', streamKey, 'pw', 'code', 'channel')

if password ~= fields[1] or code ~= fields[2] then
    return 3
end

redis.call('HSET', streamKey, 'state', state)
redis.call('PUBLISH', channel, state)

return 0
