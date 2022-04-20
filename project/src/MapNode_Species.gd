extends Node2D

var species_name
export var type = ""

var nutrition = 100
var nutrition_gain_per_second = 0
var death_rate_per_second = 5
var total_nutrition_change_per_second = 0
var connections = {}
var size = 0
var max_nutrition = 300

func _ready():
	species_name = get_path()
	$NameLabel.text = species_name
	if type == "Plant":
		nutrition_gain_per_second = 10
	if type == "Prey":
		nutrition_gain_per_second = 5

func _recalculate_total_nutrition_change_per_second():
	total_nutrition_change_per_second = 0
	if type == "Plant":
		total_nutrition_change_per_second = 10
	elif type == "Prey":
		for connection in connections:
			total_nutrition_change_per_second += 5
	elif type == "Predator":
		for connection in connections:
			total_nutrition_change_per_second += 5

func _draw():
	draw_circle(Vector2(0,0), size,Color.red)

func _process(delta):
	_recalculate_total_nutrition_change_per_second()
	nutrition += total_nutrition_change_per_second * delta
	nutrition = clamp(nutrition, 0, max_nutrition)
	size = sqrt(nutrition/PI)*10 #TODO: sqrt is very inefficient. just estimate it if precise calculation is too slow.
	update()
