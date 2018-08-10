require "habitat"
require "./eighttrack/*"

module EightTrack
  @@sequence = 0

  Habitat.create do
    setting tape_library_dir : String = "spec/fixtures/eighttracks"
  end

  # The name of the tape
  def self.tape_name
    @@tape_name
  end

  # The current sequence, calling this will increment the value
  def self.sequence
    @@sequence += 1
  end

  def self.use_tape(tape_name : String, &block)
    @@tape_name = tape_name
    @@sequence = 0
    block.call
    @@tape_name = nil
  end
end

Habitat.raise_if_missing_settings!
