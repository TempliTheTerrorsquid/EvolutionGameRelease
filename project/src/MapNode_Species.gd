extends Node2D

var species_name
export var type = ""

var initial_nutrition = 200

var nutrition = 0
var death_rate_per_second = 5 #add death rate channel without connection(or some looped connection)
var connections = {}
var size = 0
var max_nutrition = 400

var color

#I need this becouse godot cant center text automatically, like WTF.
var name_lentgh
var enviroment_name_length

#variables updated every turn. Displayed variables to player interpolate between these values,
#so it seems continuous.
var previous_turn_nutrition = 0
var previous_turn_size = 0
var next_turn_nutrition = 0
var second_next_turn_nutrition = 0
var next_turn_size = 0

var grow_channel

var closest_nodes = []
var prey = []

#enviroment
#TODO: these veriables dont do anythig yet. display enviroment slot name like name label.
var enviroment
var enviroment_slot_type
var enviroment_slot_type_name

func _ready():
	grow_channel = preload("res://src/Grow_channel.gd").new()
	add_child(grow_channel)
	grow_channel.setup(self, 0)

func setup(new_type):
	counter = 0
	var growth_or_death_rate
	type = new_type
	prey.clear()
	if type == "Predator":
		prey.append("Herbivore")
		color = Color.red
		growth_or_death_rate = -5
	elif type == "Herbivore":
		prey.append("Plant")
		color = Color.yellow
		growth_or_death_rate = -5
	elif type == "Plant":
		color = Color.green
		growth_or_death_rate = 10
	elif type == "Wastedland":
		color = Color.brown
		growth_or_death_rate = 0
	species_name = type #temporary solution probably
	$NameLabel.text = species_name
	$NameLabel.hide()
	$NameLabel.show()
	$NameLabel.set_size(Vector2.ZERO)
	name_lentgh = -$NameLabel.get_combined_minimum_size().x/2
	
	nutrition = initial_nutrition
	previous_turn_nutrition = initial_nutrition
	next_turn_nutrition = initial_nutrition
	second_next_turn_nutrition = initial_nutrition
	
	grow_channel.growth_per_second = growth_or_death_rate

func set_enviroment(enviroment_type):
	enviroment = enviroment_type
	enviroment_slot_type_name = enviroment
	$EnviromentLabel.text = enviroment_slot_type_name
	$EnviromentLabel.hide()
	$EnviromentLabel.show()
	$EnviromentLabel.set_size(Vector2.ZERO)
	enviroment_name_length = -$EnviromentLabel.get_combined_minimum_size().x/2

func _draw():
	draw_circle(Vector2(0,0), size,color)

func die():
	for connection in connections.values():
		if connection.origin_species_node == self:
			connection.end_species_node.connections.erase(self)
		elif connection.end_species_node == self:
			connection.origin_species_node.connections.erase(self)
		connection.queue_free()
	connections.clear()

func next_turn(time_per_turn):
	assess_closest_nodes()
	second_next_turn_nutrition = clamp(second_next_turn_nutrition, 0, max_nutrition)
	previous_turn_nutrition = next_turn_nutrition
	next_turn_nutrition = second_next_turn_nutrition
	previous_turn_size = next_turn_size
	next_turn_size = sqrt((50 + next_turn_nutrition)*25/PI) #TODO: sqrt is very inefficient. just estimate it if precise calculation is too slow.
	if next_turn_nutrition <= 0:
		die()
		setup("Plant" if type != "Plant" else "Wastedland")

func interpolate_to_next_turn_target(current_turn_time_as_percentage):
	var new_nutrition = previous_turn_nutrition + (next_turn_nutrition - previous_turn_nutrition) * current_turn_time_as_percentage
	nutrition = new_nutrition
	size = previous_turn_size + (next_turn_size - previous_turn_size) * current_turn_time_as_percentage
	$NutritionLabel.text = str(int(nutrition))
	$NameLabel.rect_position = Vector2(name_lentgh, 15)
	$EnviromentLabel.rect_position = Vector2(enviroment_name_length, -30)
	update()

#Species node AI
var counter = 10
var spreading_counter = 1

func assess_closest_nodes():
	if counter >= 10:
		for node in closest_nodes:
			if ((node.type in prey)and not(node in connections.keys())):
				var con = get_parent().create_connection(self, node)
				con.create_channel(node, 10, "Nutrition")
				counter = 0
				break
	else:
		counter += 1
	if  nutrition > 350 and spreading_counter >=100:
		for node in closest_nodes:
			if ((type != "Plant" and type != "Wastedland") and node.type == "Plant") or (type == "Plant" and node.type == "Wastedland"):
#				node.die()
#				node.setup(self.type)
#				print("Spreading!!!")
#				counter = 0
#				second_next_turn_nutrition -= 200
				var con
				if connections.has(node):
					con = connections[node]
				else:
					con = get_parent().create_connection(self, node)
				con.create_channel(self, 10, "Spreading")
				spreading_counter = 0
				break
	else:
		spreading_counter += 1
