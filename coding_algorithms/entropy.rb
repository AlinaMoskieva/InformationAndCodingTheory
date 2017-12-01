class Calculation
  def initialize(text_name)
    alphabet = alphabet_formation(text_name)
    probabilities = calculate_propability(alphabet)
    entropy = calculate_entropy(probabilities)
    
    combinations = calculate_combination_amount(text_name, alphabet)
    combinations_probability = calculate_combination_probability(combinations)
    conditional_entropy = calculate_conditional_entropy(combinations_probability, probabilities, combinations)
    [combinations_probability, conditional_entropy]
  end

  private

  def alphabet_formation(text_name)
    alphabet = {}

    File.open(text_name, "r") do |f|
      f.each_char do |symbol|
        alphabet.key?(symbol) ? alphabet[symbol] += 1 : alphabet[symbol] = 1
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

  def calculate_combination_amount(text_name, alphabet)
    combinations = {}
    prev = File.open(text_name).first[0]
    File.open(text_name).each_char.drop(1).each do |c|
      key = c + prev
      combinations.key?(key) ? combinations[key] += 1 : combinations[key] = 1
      prev = c
    end
    combinations
  end

  def calculate_combination_probability(combinations)
    probabilities = {}
    combinations.each_pair do |k, v|
      probabilities[k] = v.to_f / combination_amount(combinations)
    end

    probabilities
  end

  def calculate_conditional_entropy(combinations_probability, probabilities, combinations)
    result = 0
    combinations_probability.each_pair { |k, v| result -= v * Math.log2(v / probabilities[k[0]]) if probabilities[k[0]] }
    result
  end

  def combination_amount(combinations)
    @combinations ||= combinations.values.reduce(:+)
  end

  def symbols_amount(alphabet)
    @alphabet ||= alphabet.values.reduce(:+)
  end

  def print_result(file_name, alphabet, entropy, combinations, conditional_entropy)
    puts "File name is #{file_name}"
    puts "Alphabet is #{alphabet.keys}"
    puts "Alphabet power is #{alphabet.keys.count}"
    puts "Symbols amount is #{symbols_amount(alphabet)}"
    puts "Entropy is #{entropy}"
    puts "Combinations amount is #{combination_amount(combinations)}"
    puts "Uniq combinations amount is #{combinations.keys.count}"
    puts "Conditional entropy is #{conditional_entropy}"
  end
end

Calculation.new("ex.txt")
