require "http/client"

class HTTP::Client
  private def exec_internal(request : HTTP::Request)
    tape_name = EightTrack.channel.receive
    tape_path = EightTrack.settings.tape_library_dir + "/#{tape_name}"

    if File.exists?(tape_path)
      HTTP::Client::Response.from_io(File.open(tape_path))
    else
      request.to_io(socket)
      socket.flush
      response = HTTP::Client::Response.from_io(socket, request.ignore_body?)

      tape_file = File.open(tape_path, "w+")
      response.to_io(tape_file)
      tape_file.flush

      response
    end
  end
end
