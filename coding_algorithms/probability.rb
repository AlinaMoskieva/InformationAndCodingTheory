class Probability
  attr_accessor :probabilities, :entropy

  def initialize(text_name)
    @probabilities = calculate_propability(alphabet_formation(text_name))
    @entropy = calculate_entropy(probabilities)
  end

  def symbols_probabilities
     probabilities

    {
      "a1" => 0.36,
      "a2" => 0.18,
      "a3" => 0.18,
      "a4" => 0.12,
      "a5" => 0.09,
      "a6" => 0.07
    }
  end

  def text_entropy
    entropy
  end

  private

  def alphabet_formation(text_name)
    alphabet = {}

    File.open(text_name, "r") do |f|
      f.each_char do |symbol|
        alphabet.has_key?(symbol) ? alphabet[symbol] += 1 : alphabet[symbol] = 1
      end
    end

    alphabet
  end

  def calculate_propability(alphabet)
    probabilities = {}
    alphabet.map { |k, v| probabilities[k] = v.to_f / symbols_amount(alphabet) }
    probabilities
  end

  def calculate_entropy(probabilities)
    result = 0
    probabilities.values.each { |v| result -= Math.log2(v) * v }
    result
  end

  def symbols_amount(alphabet)
    @alphabet ||= alphabet.values.reduce(:+)
  end
end
