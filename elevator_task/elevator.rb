class Elevator
  EXPERIMENTS_AMOUNT = 10000
  PASSENGER_AMOUNT = 4
  FLOOR_AMOUNT = 10

  def initialize
    @second_floor, @one_floor, @on_one, @sample, @two_on_one = 0, 0, 0, 0, 0
  end

  def lift
    EXPERIMENTS_AMOUNT.times.map { experiment(random_floors) }
    print_result
  end

  private

  def random_floors
    PASSENGER_AMOUNT.times.map { Random.rand(1..FLOOR_AMOUNT) }
  end

  def uniq_elements(experiment)
    PASSENGER_AMOUNT - experiment.uniq.count
  end

  def experiment(values)
    amount = uniq_elements(values)

    @second_floor += 1 if values.count(2) > 1
    @one_floor += 1 if amount > 0
    @sample += 1 if amount == 0
    @on_one += 1 if amount == 3
    @two_on_one += 1 if amount == 1
  end

  def print_result_for(experiment, description)
    puts "#{description}: #{experiment} / #{EXPERIMENTS_AMOUNT} = #{experiment.to_f / EXPERIMENTS_AMOUNT}"
  end

  def print_result
    print_result_for(@one_floor, "more than 1 on the same floor")
    print_result_for(@second_floor, "more than 1 on second floor")
    print_result_for(@on_one, "all on the same floor")
    print_result_for(@sample, "all on the sample floor")
    print_result_for(@two_on_one, "just two on the same floor")
  end
end

elevator = Elevator.new
elevator.lift
