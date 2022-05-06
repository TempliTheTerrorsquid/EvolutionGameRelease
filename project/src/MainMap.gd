extends Node2D

onready var connection_class_ref = load("res://src/Connection.tscn")
onready var species_node_class_ref = load("res://src/MapNode_Species.tscn")
var turns_per_second = 10
var speed_up_simulation_factor = 1 #fix this. gotta go fast.
var time_per_turn = 0.0
var current_turn_time = 0.0
var turn_count = 0
var map_width = 0
var map_height = 0

func _ready():
	time_per_turn = (1.0/turns_per_second)*speed_up_simulation_factor #this dont work:DDDD
	map_height = int(get_viewport_rect().size.y)
	map_width = int(get_viewport_rect().size.x)
	spawn_grassland()
	spawn_river()
	spawn_forest()

var do_once_counter = 0
func _process(delta):
	if do_once_counter > 5000: return
	current_turn_time += delta
	get_tree().call_group("to_update_next_turn", "interpolate_to_next_turn_target", current_turn_time*turns_per_second)
	if current_turn_time > time_per_turn:
		do_once_counter += 1  
		current_turn_time -= time_per_turn
		turn_count += 1
#		print(turn_count)
		get_tree().call_group("connections", "next_turn", time_per_turn)
		get_tree().call_group("Channels", "next_turn", time_per_turn)
		get_tree().call_group("to_update_next_turn", "next_turn", time_per_turn)


#custom data structure for storing node positions and finding the closest one. May be turned into more general library later.
var node_position_array = []
var node_array = []
var squared_distance_considered_close = pow(400,2)

func find_closest_nodes():
	var found_nodes = []
	return found_nodes

#Node spawner at the start of the game. May be a separate class later.
func spawn_node(node_position, type):
	var node = species_node_class_ref.instance()
	add_child(node)
	node.setup(type)
	node.position = node_position
	for close_node in node_array:
		if (node.position.distance_squared_to(close_node.position) < squared_distance_considered_close):
			node.closest_nodes.append(close_node)
			close_node.closest_nodes.append(node)
			#add listening on signals between those nodes. signals like on death,
			# on type change(when new species takes over node), on evolution.
	return node

func create_connection(predator, prey):
	var con = connection_class_ref.instance()
	add_child(con)
	con.init(predator, prey)
	predator.connections[prey] = con
	prey.connections[predator] = con
	return con

func spawn_nodes(node_positions, enviroment_type):
	var types = ["Predator","Herbivore","Plant"]
	for node_position in node_positions:
		var type = types[randi()%len(types)]
		var node = spawn_node(node_position, type)
		node_array.append(node)
		node.set_enviroment(enviroment_type)

################################
#generate map layount
################################

func spawn_grassland():
	enviroments.append("grass")
	enviroments_positions.append(Vector2(0,0))
	enviroments_dimensions.append(Vector2(map_width*3, map_height*3))
	var new_layout = cells(10000,65,50,map_width*3, map_height*3, Vector2(0,0))
	spawn_nodes(new_layout, "grass")

func spawn_river():
	enviroments.append("river")
	enviroments_positions.append(Vector2(0,1000))
	enviroments_dimensions.append(Vector2(map_width*3, 200))
	for node in node_array:
		if (0 < node.position.x and node.position.x < map_width*3) and (935 < node.position.y and node.position.y < 1265):
			node.set_enviroment("river")

func spawn_forest():
	var counter = 0
	for node in node_array:
		counter+=1
		if counter >=3 and node.enviroment != "river": 
			counter = 0
			
			enviroments.append("forest")
			enviroments_positions.append(node.position)
			enviroments_dimensions.append(Vector2(150, 0))
			
			node.set_enviroment("forest")

#enviroments to draw
var enviroments = []
var enviroments_positions = []
var enviroments_dimensions = []

func _draw():
	#draw enviroment background
	for i in range(len(enviroments)):
		if enviroments[i] == "grass":
			draw_rect(Rect2(enviroments_positions[i], enviroments_dimensions[i]), Color.burlywood)
	for i in range(len(enviroments)):
		if enviroments[i] == "river":
			draw_rect(Rect2(enviroments_positions[i], enviroments_dimensions[i]), Color.aqua)
		elif enviroments[i] == "forest":
			draw_circle(enviroments_positions[i], enviroments_dimensions[i][0], Color.chartreuse)
	
func cells(number_of_nodes_spawned, R, D, size_x, size_y, upper_left_corner_location):
	var min_distance = pow(2*R+D, 2)
	var node_positions = []
	randomize()
	for n in range(number_of_nodes_spawned):
		var attempt_counter = 0
		while true:
			var location_candidate = Vector2(R + randi()%(size_x-2*R),R + randi()%(size_y-2*R)) + upper_left_corner_location
			var can_pass = true
			for node_position in node_position_array:
				if (location_candidate.distance_squared_to(node_position) < min_distance):
					can_pass = false
					break
			if can_pass:
				node_positions.append(location_candidate)
				node_position_array.append(location_candidate)
				break
			else:
				attempt_counter += 1
				if attempt_counter >= 100:
#					print("No more aviable space found, attempts tried:", attempt_counter)
					return node_positions
	return node_positions







