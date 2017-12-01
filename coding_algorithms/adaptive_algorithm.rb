class AdaptiveAlgorithm
  attr_accessor :input, :alphabet, :weight, :probabilities, :file_name, :similars
  RESULT_TITLE = "Bits divided by the number of symbols ".freeze

  def initialize(file_name)
    @file_name = file_name
    @input = File.open(file_name, "r")
    @alphabet = determine_alphabet.freeze
    @weight = init_weight
    @probabilities = recalculate_probabilities
    @similars = "0."
    @symbols_amount = 0
  end

  def encode_text
    segment = {}
    range = [0, 1]

    File.open(file_name, "r") do |f|
      f.each_char do |symbol|
        segment = order_segments(range)[symbol]
        range = [segment[:right], segment[:left]]
        update_weight(symbol)
        recalculate_probabilities
        increment_symbols_amount
      end
    end
    write_answer(range)
  end

  private

  def increment_symbols_amount
    @symbols_amount += 1
  end

  def write_answer(range)
    code = code_formition(range)
    puts "Range is #{range}"
    puts "Code is #{code}"
    puts_answer_in_a_file(range, code)
  end

  def puts_answer_in_a_file(range, code)
    out = File.new("adaptive_coding_algorithm.bin", "w")
    out.write(binary_code(code))
    puts "#{RESULT_TITLE} #{(out.size / @symbols_amount.to_f).round(8)}"
  end

  def code_formition(range)
    code = (rand * (range.last - range.first) + range.first).to_s
    similars << code[2..code.length]
  end

  def update_weight(symbol)
    weight[symbol] = weight[symbol] + 1
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
    return range unless (left * 10).to_i == (right * 10).to_i

    determine_range(recalculate_range(left, right))
  end

  def recalculate_range(left, right)
    similar = (left * 10).to_i
    similars << similar.to_s

    [right * 10 - similar, left * 10 - similar]
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

  def binary_code(code)
    code[2..-1].to_i.to_s(2)
  end
end

# AdaptiveAlgorithm.new("../entropy/souls.txt").encode_text
AdaptiveAlgorithm.new("ex.txt").encode_text
