require_relative "probability"
require_relative "encode"

class ArithmeticCodingAlgorithm
  attr_accessor :probabilities, :file_name

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
    File.open(file_name, "r") do |f|
      f.each_char do |symbol|
        segment = order_segments(range)[symbol]
        range = [segment[:right], segment[:left]]
      end
    end
    puts "Answer is #{range.inspect}"
  end
  
  private

  def order_segments(range)
    right, left = range
    length = left - right
    segments = {}
    
    probabilities.each do |key, value|
      left = right + length * value
      segments[key] = { right: right, left: left }
      right = left
    end
    puts segments.inspect
    
    segments
  end

  def previous_results(probability)
    puts "Entropy is #{probability.entropy}"
    Encode.new(file_name).encode("ShannonFano")
    Encode.new(file_name).encode("Haffman")
  end
end

ArithmeticCodingAlgorithm.new("ex.txt").encode_text
