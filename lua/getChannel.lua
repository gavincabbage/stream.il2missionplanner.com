local streamName = ARGV[1]
local password = ARGV[2]

if not streamName or not password then
    return {'ERROR', 'All fields are required. Please try again.'}
end

local streamKey = 'stream:' .. streamName

local expectedPassword = redis.call('HGET', streamKey, 'pw')
if not expectedPassword then
    return {'ERROR', 'Problem retrieving stored password. Please try again.'}
end

if expectedPassword ~= password then
    return {'ERROR', 'Incorrect password.'}
end

local streamInfo = redis.call('HMGET', streamKey, 'channel', 'state')

return {'SUCCESS', streamInfo[1], streamInfo[2]}
