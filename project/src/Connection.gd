extends Path2D

onready var nutrition_node_class_ref = load("res://src/NutritionNode.tscn")

var origin_species_node
var end_species_node

var nutrition = 100
var nutrition_node_cost = 100

func init(origin, end):
	origin_species_node = origin
	end_species_node = end
	curve.add_point(origin_species_node.position)
	curve.add_point(end_species_node.position)
#	update()

func _ready():
	pass
	
func _spawn_new_nutrition_node():
	nutrition -= nutrition_node_cost
	
	var nutrition_node = nutrition_node_class_ref.instance()
	add_child(nutrition_node)

func _process(delta):
	nutrition += 1
	print(nutrition)
	if nutrition >= nutrition_node_cost:
		_spawn_new_nutrition_node()