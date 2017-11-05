require_relative "shannon_fano"

class Encode
  OUTPUT_FILE_NAME = "encode.txt"
  attr_accessor :code_tree, :file_name, :out

  def initialize(file_name)
    @code_tree = ShannonFano.new(file_name).tree
    @file_name = file_name
    @out = File.new(OUTPUT_FILE_NAME, "w")
  end

  def encode
    File.open(file_name, "r") do |input|
      input.each_char do |symbol|
        out.write(code_tree[symbol])
      end
    end
    puts code_tree
  end

  def comparison
    puts "__"
    puts File.size(file_name)
    puts out.size
  end
end

encode = Encode.new("ex.txt")
encode.encode
encode.comparison
