require 'sinatra'
require 'sinatra-websocket'

set :server, 'thin'
set :sockets, []

get '/' do
  if !request.websocket?
    erb :index
  else
    request.websocket do |ws|
      ws.onopen do
        ws.send("Hello World!")
        settings.sockets << ws
        puts "new socket opened"
      end
      ws.onmessage do |msg|
        EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  end
end

get '/api/sockets/close' do
  settings.sockets.each do |socket|
    socket.close_connection(1000)
  end
  return "closed all sockets"
end

get '/api/sockets/list' do
  settings.sockets.each do |socket|
    puts socket
  end
  return "logged sockets"
end
