require_relative "probability"

class ShannonFano
  attr_accessor :probabilities, :code_tree

  def initialize(file_name)
    puts "Shannon Fano"
    probability = Probability.new(file_name)
    @probabilities = hash_formation(probability.symbols_probabilities)
    @code_tree = copy_keys_and_set_default
    probability.text_entropy
  end

  def tree
    code_tree_formation(probabilities)
    puts "Code tree is #{code_tree}"
    code_tree
  end

  private

  def copy_keys_and_set_default
    code_tree = {}
    probabilities.each_key { |key| code_tree[key] = "" }
    code_tree
  end

  def hash_formation(probabilities)
    Hash[probabilities.sort_by{ |k, v| v }]
  end

  def code_tree_formation(prob)
    return if prob.length < 2

    middle = prob.values.reduce(:+) / 2
    first_node, second_node = {}, {}
    sum = 0

    prob.map do |key, value|
      sum = sum + value
      hash_name = sum <= middle ? first_node : second_node
      hash_name[key] = value
    end

    organize_recursive(first_node, second_node)
  end

  def organize_recursive(first_node, second_node)
    add_code_to_tree(first_node, "1")
    add_code_to_tree(second_node, "0")

    code_tree_formation(first_node)
    code_tree_formation(second_node)
  end

  def add_code_to_tree(node, symbol)
    node.map { |key, value| code_tree[key] = code_tree[key] + symbol }
  end
end

# ShannonFano.new("ex.txt").tree
