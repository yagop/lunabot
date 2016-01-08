import p from require "moon"
redis = require "redis"

class Redis
  new: (@robot) =>
    params =
      host: os.getenv('REDIS_HOST') or '127.0.0.1'
      port: tonumber(os.getenv('REDIS_PORT') or 6379)
      database: os.getenv('REDIS_DB')
      password: os.getenv('REDIS_PASSWORD')

    --@robot.logger\debug "Redis host: #{params.host}"
    --@robot.logger\debug "Redis port: #{params.port}"
    @client = redis.connect params
    @client\auth params.password if params.password
    -- TODO: fake redis
