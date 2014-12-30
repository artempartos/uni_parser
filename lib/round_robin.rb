module RoundRobin
  def next!(arry)
    value = arry.shift
    arry << value
    value
  end
end
