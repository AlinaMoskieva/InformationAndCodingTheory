require_relative "probability"

class Haffman
  attr_accessor :probabilities, :code_tree

  def initialize(file_name)
    puts "Haffman"
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

  def hash_formation(probabilities)
    Hash[probabilities.sort_by{ |k, v| v }.reverse]
  end

  def copy_keys_and_set_default
    code_tree = {}
    probabilities.each_key { |key| code_tree[key] = "" }
    code_tree
  end

  def code_tree_formation(prob)
    return if prob.length < 2

    elems_value = lats_two_elements(prob)
    elem = compare_min_elems(elems_value.values, elems_value.keys)
    prob = destroy_and_add_last_elems(elem, elems_value.keys, prob)
    code_tree_formation(hash_formation(prob))
  end

  def lats_two_elements(prob)
    prob.to_a.last(2).to_h
  end

  def compare_min_elems(values, keys)
    new_key = ""

    codes = values[0] >= values[1] ? ["1", "0"] : ["0", "1"]

    new_key = update_code_tree(keys[0], codes[0])
    new_key << update_code_tree(keys[1], codes[1])
    { new_key => values.reduce(:+) }
  end

  def update_code_tree(keys, symbol)
    new_key = ""

    keys.each_char do |key|
      code_tree[key] = code_tree[key] + symbol
      new_key << key
    end
    new_key
  end

  def destroy_and_add_last_elems(elem, removed_keys, prob)
    prob.delete(removed_keys[0])
    prob.delete(removed_keys[1])
    prob.merge!(elem)
  end
end

# Haffman.new("ex.txt").tree
