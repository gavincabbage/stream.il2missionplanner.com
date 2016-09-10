local streamName = ARGV[1]
local password = ARGV[2]
local code = ARGV[3]
local state = ARGV[4]

if not streamName or not password or not code or not state then
    return {'ERROR', 'All fields are required. Please try again'}
end

if redis.call('EXISTS', 'stream:' .. streamName) == 0 then
    return {'ERROR', 'Stream does not exist.'}
end

local streamKey = 'stream:' .. streamName
local fields = redis.call('HMGET', streamKey, 'pw', 'code', 'channel')

if password ~= fields[1] or code ~= fields[2] then
    return {'ERROR', 'Password or leader code incorrect.'}
end

redis.call('HSET', streamKey, 'state', state)
redis.call('PUBLISH', fields[3], state)
redis.call('EXPIRE', streamKey, 10800)

return {'SUCCESS'}
