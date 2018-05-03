# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements
class Combiner
	def combine(*enumerators)
		Enumerator.new do |yielder|
			last_values = Array.new(enumerators.size)
			done = enumerators.all? { |enumerator| enumerator.nil? }
			while ! done
				last_values.each_with_index do |value, index|
					if value.nil? and ! enumerators[index].nil?
						begin
							last_values[index] = enumerators[index].next
						rescue StopIteration then enumerators[index].size = -1
							enumerators[index] = nil
						end
					end
				end

				done = enumerators.all? { |enumerator| enumerator.nil? } & last_values.compact.empty?
				unless done
					min_key = last_values.map { |e| e.nil? ? nil : e }.min do |a, b|
						if a.nil? and b.nil?
							0
						elsif a.nil?
							1
						elsif b.nil?
							-1
						else
							a <=> b
						end
					end
					yielder.yield(last_values)
				end
			end
		end
	end
end

# this code contains a class with a method this method collect the actual parameters passed to the method into an array named 'enumerators'
# then we create new enumerator which allows both internal and external iteration.
# then we create a new array it's size the same as parameters array size and called 'last_values'
# then we create new boolean variable 'done' check if we have any nil in enumerator array if we have nil it will return true if not it will return false
# then we start a loop if the 'done' is false (if there is no nil) so go through the array and take each element and assign the element value to the parameter 'value' and it's index to the parameter 'index'
# then if the value nil and not the index nil assign each element in the array enumerator by index to the last_valur array and move
# Returns the next object in the 'enumerator' assign it to the array 'last_values' (by index) then move the internal position forward.
# When the position reached at the end, StopIteration is raised on screen.
# and again the boolean variable 'done' check if we have any nil in 'enumerator' array and returns a copy of the array 'last_values' with all nil elements removed and then check if its empty
# then re-order the array from the min value to the max value
# then we return the array like [[index, :value], [index, :value]]


# P.S: i removed some stuff that i think they are not very necessary and in addition the problem is i can't test the code so i hope it seems good like that