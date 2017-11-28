class AdaptiveAlgorithm
  attr_accessor :input, :alphabet, :weight, :probabilities, :file_name

  def initialize(file_name)
    @file_name = file_name
    @input = File.open(file_name, "r")
    @alphabet = determine_alphabet.freeze
    @weight = init_weight
    @probabilities = recalculate_probabilities
  end

  def encode_text
    segment = {}
    range = [0, 1]

    File.open(file_name, "r") do |f|
      f.each_char do |symbol|
        segment = order_segments(range)[symbol]
        range =  determine_range(segment)
        update_weight(symbol)
        recalculate_probabilities
      end
    end
    code = rand * (range.last - range.first) + range.first
    write_answer(range, code)
    
  end

  private
  def write_answer(range, code)
    puts "Range is #{range}"
    puts "Code id #{code}"
  end
  
  def determine_range(segment)
    [segment[:right], segment[:left]]
  end
  
  def update_weight(symbol)
    weight[symbol] = weight[symbol] + 1
  end

  def order_segments(range)
    right, left = range
    length = left - right
    segments = {}
    
    probabilities.each do |key, value|
      left = right + length * value
      segments[key] = { right: right, left: left }
      right = left
    end
    
    segments
  end

  def recalculate_probabilities
    probabilities = {}
    summary_weight = weight.values.reduce(:+)
    alphabet.each { |symbol| probabilities[symbol] = weight[symbol] / summary_weight.to_f }
    probabilities
  end

  def determine_alphabet
    input.read.split(//).uniq
  end

  def init_weight
    weight = {}
    alphabet.each { |symbol| weight[symbol] = 1 }
    weight
  end
end

AdaptiveAlgorithm.new("ex.txt").encode_text
