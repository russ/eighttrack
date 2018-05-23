require "habitat"
require "./eighttrack/*"

module EightTrack
  Habitat.create do
    setting tape_library_dir : String = "spec/fixtures/eighttracks"
  end

  @@channel = Channel(String).new

  def self.channel
    @@channel
  end

  def self.use_tape(tape_name : String, &block)
    spawn { EightTrack.channel.send(tape_name) }
    block.call
  end
end

Habitat.raise_if_missing_settings!
