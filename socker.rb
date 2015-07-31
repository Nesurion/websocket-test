require 'sinatra'
require 'sinatra-websocket'
require 'logger'

set :server, 'thin'
set :sockets, []
set :bind, "0.0.0.0"
set :port, 80

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

api_key = 'FAA7A16539B96341D2BB81F724F43'

get '/' do
  if !request.websocket?
    erb :index
  else
    request.websocket do |ws|
      ws.onopen do
        ws.send("Hello World!")
        settings.sockets << ws
        logger.info("new socket opened: #{ws}")
      end
      ws.onmessage do |msg|
        logger.info("message: #{msg} [socket: #{ws}]")
        EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
      end
      ws.onclose do
        logger.info("websocket #{ws} closed")
        settings.sockets.delete(ws)
      end
    end
  end
end

get '/api/sockets/close' do
  # if headers["X-AUTH"] == api_key
    settings.sockets.each do |socket|
      socket.close_connection(1000)
    end
    return "closed all sockets"
  # else
  #   status 403
  # end
end

get '/api/sockets/list' do
  # if headers["X-AUTH"] == api_key
    settings.sockets.each do |socket|
      puts socket
    end
    return "logged sockets"
  # else
  #   status 403
  # end
end
