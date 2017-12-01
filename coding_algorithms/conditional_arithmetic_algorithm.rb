require_relative "probability"
require_relative "encode"
require_relative "entropy"

class ArithmeticCodingAlgorithm
  attr_accessor :probabilities, :file_name, :similars
  RESULT_TITLE = "Bits divided by the number of symbols "

  def initialize(file_name)
    @file_name = file_name
    calc = Calculation.new(file_name).conditional_entropy
    puts "Conditional entropy is #{calc.last}"
    @probabilities = calc.first
    @similars = "0."
    puts "Arithmetic coding algorithm"
  end

  def encode_text
    segments = {}
    range = [0, 1]
    symbols_amount = 0
    file = File.open(file_name, "r")
    file.read.scan(/../).each do |symbol|
      segment = order_segments(range)[symbol.reverse]
      range = [segment[:right], segment[:left]]
      symbols_amount = symbols_amount + 1
    end

    answer(determine_range(range), symbols_amount * 2)
  end

  private

  def answer(range, symbols_amount)
    code = code_formition(range)
    puts "Range is #{range.inspect}"
    # puts "Code is #{code}"
    puts "Symbols amount is #{symbols_amount}"
    puts "Code length is #{code.length}"

    write_answer(symbols_amount, code)
  end

  def code_formition(range)
    code = (rand * (range.last - range.first) + range.first).to_s
    similars << code[2..code.length]
  end

  def write_answer(symbols_amount, code)
    out = File.new("arithmetic_coding_algorithm.bin", "w")
    out.write(binary_code(code))
    puts "#{RESULT_TITLE} #{(out.size /   symbols_amount.to_f).round(8) }"
  end

  def order_segments(range)
    right, left = determine_range(range)
    length = left - right
    segments = {}

    probabilities.each do |key, value|
      left = right + length * value
      segments[key] = { right: right, left: left }
      right = left
    end

    segments
  end

  def determine_range(range)
    right, left = range

    return range unless (left * 10 ).to_i == (right * 10 ).to_i
    similar = (left * 10 ).to_i
    similars << similar.to_s
    left = left * 10 - similar
    right = right * 10 - similar
    determine_range [right, left]
  end

  def previous_results(probability)
    puts "Entropy is #{probability.entropy}"
    Encode.new(file_name).encode("ShannonFano")
    Encode.new(file_name).encode("Haffman")
  end

  def binary_code(code)
    code[2..-1].to_i.to_s(2)
  end
end

# ArithmeticCodingAlgorithm.new("../entropy/souls.txt")#.encode_text
ArithmeticCodingAlgorithm.new("ex.txt").encode_text
