require_relative "shannon_fano"

class Encode
  OUTPUT_FILE_NAME = "encode.txt"
  RESULT_TITLE = "Bits divided by the number of symbols in the source text"

  attr_accessor :code_tree, :file_name, :out, :input

  def initialize(file_name)
    @code_tree = ShannonFano.new(file_name).tree
    @file_name = file_name
    @out = File.new(OUTPUT_FILE_NAME, "w")
    @input = File.open(file_name, "r")
  end

  def encode
    chars_amount = 0

    input.each_char do |symbol|
      chars_amount = chars_amount + 1
      out.write(code_tree[symbol])
    end
    puts "#{RESULT_TITLE} #{chars_amount.to_f / out.size}"
  end
end

encode = Encode.new("ex.txt")
encode.encode

