require "http/client"
require "digest"

class HTTP::Request
  def to_json()
    {
      method: method,
      host: host,
      resource: resource,
      headers: headers.to_h,
      body: body.to_s,
      query_params: query_params.to_h,
    }.to_json()
  end
end

class HTTP::Client
  private def exec_internal(request : HTTP::Request)
    tape_name = EightTrack.tape_name

    # If we do not have a tape_name, perform a normal request
    if(tape_name.nil?)
      request.to_io(socket)
      socket.flush
      return HTTP::Client::Response.from_io(socket, request.ignore_body?)
    end

    # Create an md5 for the request
    req_md5 = Digest::MD5.hexdigest(request.to_json)

    # Create path vars
    tape_dir = File.join(EightTrack.settings.tape_library_dir, tape_name)
    # Create a dir for our tape
    FileUtils.mkdir(tape_dir) unless(Dir.exists?(tape_dir))
    tape_path = File.join(tape_dir, "#{EightTrack.sequence}.#{req_md5}.vcr")

    # If it exists, load and return the data
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
