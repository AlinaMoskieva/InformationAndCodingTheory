require_relative "probability"
require_relative "encode"

class ArithmeticCodingAlgorithm
  attr_accessor :probabilities, :file_name
  RESULT_TITLE = "Bits divided by the number of symbols "

  def initialize(file_name)
    @file_name = file_name
    probability = Probability.new(file_name)
    @probabilities = probability.symbols_probabilities
    previous_results(probability)
    puts "Arithmetic coding algorithm"
  end

  def encode_text
    segments = {}
    range = [0, 1]
    symbols_amount = 0
    File.open(file_name, "r") do |f|
      f.each_char do |symbol|
        segment = order_segments(range)[symbol]
        range = [segment[:right], segment[:left]]
        symbols_amount = symbols_amount + 1
      end
    end
    code = rand * (range.last - range.first) + range.first
    answer(determine_range(range), symbols_amount, code)
  end
  
  private
  
  def answer(range, symbols_amount, code)
    puts "Range is #{range.inspect}"
    puts "Code is #{code}"
    puts "Symbol amount is #{symbols_amount}"
    
    write_answer(symbols_amount, code)
  end
  
  def write_answer(symbols_amount, code)
    out = File.new("arithmetic_coding_algorithm.bin", "w")
    out.write(code)
    puts "#{RESULT_TITLE} #{out.size / symbols_amount.to_f }"
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
    left = left * 10 - similar
    right = right * 10 - similar
    determine_range [right, left]
  end

  def previous_results(probability)
    puts "Entropy is #{probability.entropy}"
    Encode.new(file_name).encode("ShannonFano")
    Encode.new(file_name).encode("Haffman")
  end
end

ArithmeticCodingAlgorithm.new("../entropy/souls.txt").encode_text
