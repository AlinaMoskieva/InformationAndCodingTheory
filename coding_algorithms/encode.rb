require_relative "shannon_fano"
require_relative "haffman"

class Encode
  OUTPUT_FILE_NAME = "encode.txt"
  RESULT_TITLE = "Bits divided by the number of symbols in the source text"

  attr_accessor :file_name, :input, :out

  def initialize(file_name)
    @file_name = file_name
    @out = File.new(OUTPUT_FILE_NAME, "w")
    @input = File.open(file_name, "r")
  end

  def encode(algorithm)
    chars_amount = 0
    code_tree = determie_tree(algorithm, file_name)

    input.each_char do |symbol|
      chars_amount = chars_amount + 1
      out.write(code_tree[symbol])
    end

    puts "#{RESULT_TITLE} #{out.size / chars_amount.to_f }"
  end

  private

  def determie_tree(algorithm, file_name)
    return Haffman.new(file_name).tree if algorithm == "Haffman"
    ShannonFano.new(file_name).tree
  end
end

encode = Encode.new("../entropy/souls.txt")
encode.encode("ShannonFano")

encode = Encode.new("../entropy/souls.txt")
encode.encode("Haffman")


