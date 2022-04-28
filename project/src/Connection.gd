extends Path2D

onready var nutrition_node_class_ref = preload("res://src/NutritionNode.tscn")
onready var channel_class_ref = preload("res://src/Channel.tscn")

var origin_species_node
var end_species_node

var active_nutrition_nodes = []
var nutrition_node_pool = []

var channels = []

func init(origin, end):
	origin_species_node = origin
	end_species_node = end
	curve = Curve2D.new()
	curve.add_point(origin_species_node.position)
	curve.add_point(end_species_node.position)
#	update()
	origin_species_node.connections[end] = self
	end_species_node.connections[origin] = self

func create_channel(start, change_per_second, type):
	var direction_backwards
	if start == origin_species_node:
		direction_backwards = false
	elif start == end_species_node:
		direction_backwards = true

	channel_class_ref = preload("res://src/Channel.tscn") #TODO: how to load resources properly.
	var channel = channel_class_ref.instance()
	add_child(channel)
	channel.setup(self, direction_backwards, change_per_second, type)
	
	channels.append(channel)

func delete_channel(channel):
	channels.erase(channel)
	channel.queue_free()
#	if len(channels) == 0:
#		end_species_node.connections.erase(self)
#		origin_species_node.connections.erase(self)
#		queue_free()

func _ready():
	pass
	
func _draw():
	draw_polyline(curve.get_baked_points(), Color.red, 2.0)

func next_turn(time_per_turn):
	active_nutrition_nodes

func spawn_new_nutrition_node(direction_backwards, payload, type):
	var nutrition_node = nutrition_node_class_ref.instance()
	add_child(nutrition_node)
	var target = origin_species_node if direction_backwards else end_species_node
	var source = end_species_node if direction_backwards else origin_species_node
	if type == "Nutrition":
		source.second_next_turn_nutrition -= payload
	elif type == "Spreading":
		source.second_next_turn_nutrition -= 200
	nutrition_node.setup(direction_backwards, payload, target, type)
	active_nutrition_nodes.append(nutrition_node)
