require 'pry'

class CircularQueue
  attr_accessor :buffer, :next_idx, :oldest_idx

  def initialize(size)
    @buffer = [nil] * size
    @next_idx = 0
    @oldest_idx = 0
  end

  def dequeue
    old_value = buffer[oldest_idx]
    buffer[oldest_idx] = nil
    self.oldest_idx = increment(oldest_idx) unless old_value.nil?
    old_value
  end

  def enqueue(value)
    old_value = buffer[next_idx]
    buffer[next_idx] = value
    self.next_idx = increment(next_idx)
    self.oldest_idx = increment(oldest_idx) unless old_value.nil?
  end

  private

  def increment(position)
    (position + 1) % buffer.size
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue.nil?

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue.nil?

queue = CircularQueue.new(4)
puts queue.dequeue.nil?

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue.nil?
