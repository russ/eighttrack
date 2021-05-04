require "./spec_helper"

describe EightTrack do
  it "..." do
    EightTrack.use_tape("weather") do
      response = HTTP::Client.get(URI.parse("https://ipapi.co/8.8.8.8/json"), headers: headers)

      json = JSON.parse(response.body)
      json["ip"].should eq "8.8.8.8"
    end
  end
end

private def headers
  HTTP::Headers{
    "Content-Type" => "application/json;",
  }
end
