require_relative "probability"
require_relative "encode"

class ArithmeticCodingAlgorithm
  attr_accessor :file_name, :similars
  RESULT_TITLE = "Bits divided by the number of symbols ".freeze

  def initialize(file_name)
    @file_name = file_name
    @similars = "0."
    previous_results(probability)
  end

  def encode_text
    segments, range = [{}, [0, 1]]

    file.each_char do |symbol|
      segment = order_segments(range)[symbol]
      range = [segment[:right], segment[:left]]
    end

    answer(determine_range(range), file.length)
  end

  private

  def answer(range, symbols_amount)
    code = code_formition(range)
    puts "Range is #{range.inspect}"
    puts "Code is #{code}"
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
    puts "#{RESULT_TITLE} #{(out.size / symbols_amount.to_f).round(8)}"
  end

  def order_segments(range)
    right, left = determine_range(range)
    length, segments = [left - right, {}]

    probabilities.each do |key, value|
      left = right + length * value
      segments[key] = { right: right, left: left }
      right = left
    end

    segments
  end

  def determine_range(range)
    right, left = range

    return range unless (left * 10).to_i == (right * 10).to_i
    determine_range(recalculate_range(left, right))
  end

  def recalculate_range(left, right)
    similar = (left * 10).to_i
    similars << similar.to_s

    [right * 10 - similar, left * 10 - similar]
  end

  def previous_results(probability)
    puts "Entropy is #{probability.entropy}"
    Encode.new(file_name).encode("ShannonFano")
    Encode.new(file_name).encode("Haffman")
  end

  def probabilities
    @probabilities ||= probability.symbols_probabilities
  end

  def probability
    @probability ||= Probability.new(file_name)
  end

  def file
    @file ||= File.open(file_name, "r").read
  end

  def binary_code(code)
    code[2..-1].to_i.to_s(2)
  end
end

# ArithmeticCodingAlgorithm.new("../entropy/souls.txt").encode_text
ArithmeticCodingAlgorithm.new("ex.txt").encode_text
