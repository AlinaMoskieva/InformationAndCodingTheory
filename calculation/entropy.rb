class Entropy
  def calculate(n)
    result = 0
    n.count.times { |i| result -=  n[i] * Math.log2(n[i]) }
    puts result
  end
end

entropy = Entropy.new
entropy.calculate([3.0 / 8, 2.0 / 8, 3.0 / 8])
