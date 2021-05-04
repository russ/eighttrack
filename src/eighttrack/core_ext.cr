require "http/client"
require "digest"
require "file_utils"

class HTTP::Request
  def data_for_hash_digest
    {
      method:       method,
      hostname:     hostname,
      resource:     resource,
      headers:      headers.to_h,
      body:         body.to_s,
      query_params: query_params.to_h,
    }.to_s
  end
end

class HTTP::Client
  private def exec_internal_single(request)
    tape_name = EightTrack.tape_name

    if (tape_name.nil?)
      # If we do not have a tape_name, perform a normal request
      decompress = send_request(request)
      HTTP::Client::Response.from_io?(io, ignore_body: request.ignore_body?, decompress: decompress)
    else
      # Create an md5 for the request
      req_md5 = Digest::MD5.hexdigest(request.data_for_hash_digest)

      # Create path vars
      tape_dir = File.join(EightTrack.settings.tape_library_dir, tape_name)

      # Create a dir for our tape
      FileUtils.mkdir_p(tape_dir) unless (Dir.exists?(tape_dir))
      tape_path = File.join(tape_dir, "#{EightTrack.sequence}.#{req_md5}.vcr")

      if File.exists?(tape_path)
        # If it exists, load and return the data
        HTTP::Client::Response.from_io(File.open(tape_path))
      else
        # Doesn't exist, fetch and save the data
        tape_file = File.open(tape_path, "w+")
        decompress = send_request(request)

        if response = HTTP::Client::Response.from_io?(io, ignore_body: request.ignore_body?, decompress: decompress)
          response.to_io(tape_file)
          tape_file.flush
          response
        end
      end
    end
  end
end
