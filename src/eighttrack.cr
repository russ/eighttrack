require "habitat"
require "./eighttrack/*"

module EightTrack
  @@sequence = 0
  @@record = false

  Habitat.create do
    setting tape_library_dir : String = "spec/fixtures/eighttracks"
  end

  def self.record
    self.record = true
    yield
    self.record = false
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

    reset_casset(@@tape_name.not_nil!) if record?

    block.call
    reset!
  end

  def self.record=(value)
    @@record = value
  end

  def self.record?
    @@record
  end

  private def self.reset!
    @@tape_name = nil
    @@record = false
  end

  private def self.reset_casset(casset)
    casset_dir_path = File.join(EightTrack.settings.tape_library_dir, casset)

    if Dir.exists?(casset_dir_path)
      Dir.open(casset_dir_path).each do |file|
        if file =~ /\.vcr$/
          File.delete(File.join(casset_dir_path, file))
        end
      end
    end
  end
end

Habitat.raise_if_missing_settings!
