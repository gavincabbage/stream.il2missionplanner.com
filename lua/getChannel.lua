local streamName = ARGV[1]
local password = ARGV[2]

if not streamName or not password then
    return 1
end

local streamKey = 'stream:' .. streamName

local expectedPassword = redis.call('HGET', streamKey, 'pw')
if not password then
    return 2
end

if expectedPassword ~= password then
    return 3
end

return redis.call('HMGET', streamKey, 'channel', 'state')
