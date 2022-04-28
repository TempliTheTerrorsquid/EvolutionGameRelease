extends Node

var target
var growth_per_second

func setup(new_target, growth_rate):
	target = new_target
	growth_per_second = growth_rate
	add_to_group("Channels")
	
func next_turn(time_per_turn):
	target.second_next_turn_nutrition += growth_per_second * time_per_turn
