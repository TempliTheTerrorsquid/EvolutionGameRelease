extends Node

var threshold = 30
var count = 0.0
var connection
var change_per_second = 0
var type = "Nutrition"
var backwards = false

func _ready():
	pass

func setup(con, direction_backwards, new_change_per_second, new_type):
	type = new_type
	connection = con
	backwards = direction_backwards
	change_per_second = new_change_per_second

func next_turn(time_per_turn):
	count += change_per_second * time_per_turn
	if connection == null:
		print("null connection detected")
	if count > threshold:
		if type == "Nutrition":
			count -= threshold
			connection.spawn_new_nutrition_node(backwards, threshold, type)
		elif type == "Spreading":
			var source = connection.end_species_node if backwards else connection.origin_species_node
			connection.spawn_new_nutrition_node(backwards, source.type, type)
			connection.delete_channel(self)
