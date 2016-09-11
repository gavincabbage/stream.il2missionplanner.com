local scriptName = 'getReconnect'

local streamName = ARGV[1]
local password = ARGV[2]
local code = ARGV[3]

if not streamName or not password or not code then
    return {'ERROR', 'All fields are required. Please try again.'}
end

local streamKey = 'stream:' .. streamName

local expected = redis.call('HMGET', streamKey, 'pw', 'code')
if not expected[1] or not expected[2] then
    return {'ERROR', 'Problem retrieving stored code or password. Please try again.'}
end

if expected[1] ~= password or expected[2] ~= code then
    return {'ERROR', 'Incorrect code or password.'}
end

local streamInfo = redis.call('HMGET', streamKey, 'channel', 'state')

return {'SUCCESS', streamInfo[1], streamInfo[2]}
