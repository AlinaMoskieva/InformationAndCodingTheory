class Calculation
  def initialize(text_name)
    alphabet = alphabet_formation(text_name)
    probabilities = calculate_propability(alphabet)
    entropy = calculate_entropy(probabilities)
    combinations = calculate_combination_amount(text_name, alphabet)
    combinations_probability = calculate_combination_probability(combinations)
    conditional_entropy = calculate_conditional_entropy(combinations_probability, probabilities, combinations)

    second_combination = calculate_second_combination_amount(text_name, alphabet)
    second_combinations_probability = calculate_second_probability(second_combination, combination_amount(combinations) - 1 )
    second_conditional_entropy = calculate_second_conditional_entropy(second_combinations_probability, combinations_probability)

    print_result(text_name, alphabet, entropy, combinations, conditional_entropy, second_conditional_entropy)
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

  def calculate_combination_amount(text_name, alphabet)
    combinations = {}
    prev = File.open(text_name).first[0]
    File.open(text_name).each_char.drop(1).each do |c|
      key = c + prev
      combinations.has_key?(key) ? combinations[key] += 1 : combinations[key] = 1
      prev = c
    end
    combinations
  end

  def calculate_second_combination_amount(text_name, alphabet)
    combinations = {}
    file = File.open(text_name)

    prev_prev = file.first[1]
    prev = file.first[0]

    file.each_char.drop(2).each do |c|
      key = c + prev + prev_prev
      combinations.has_key?(key) ? combinations[key] += 1 : combinations[key] = 1
      prev_prev = prev
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

  def calculate_second_probability(combination, amount)
    probabilities = {}

    combination.each_pair do |k, v|
      probabilities[k] = v.to_f / amount
    end

    probabilities
  end

  def calculate_conditional_entropy(combinations_probability, probabilities, combinations)
    result = 0
    combinations_probability.each_pair { |k, v| result -= v * Math.log2(v / probabilities[k[0]]) if probabilities[k[0]] }
    result
  end

  def calculate_second_conditional_entropy(second_combinations_probability, probabilities)
    result = 0
    second_combinations_probability.each_pair { |k, v| result -= v * Math.log2(v / probabilities[k[1] + k[2]]) if !k[1].nil? && !k[2].nil? && probabilities[k[1] + k[2]] }
    result
  end

  def combination_amount(combinations)
    @combinations ||= combinations.values.reduce(:+)
  end

  def symbols_amount(alphabet)
    @alphabet ||= alphabet.values.reduce(:+)
  end

  def print_result(file_name, alphabet, entropy, combinations, conditional_entropy, second_conditional_entropy)
    puts "File name is #{file_name}"
    puts "Alphabet is #{alphabet.keys}"
    puts "Alphabet power is #{alphabet.keys.count}"
    puts "Symbols amount is #{symbols_amount(alphabet)}"
    puts "Entropy is #{entropy}"
    puts "Combinations amount is #{combination_amount(combinations)}"
    puts "Uniq combinations amount is #{combinations.keys.count}"
    puts "Conditional entropy is #{conditional_entropy}"
    puts "Conditional entropy on three characters is #{second_conditional_entropy}"
  end
end

Calculation.new("souls.txt")
