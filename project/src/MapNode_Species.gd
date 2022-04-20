extends Node2D

var species_name

func _ready():
	species_name = get_path()
	$NameLabel.text = species_name

func _draw():
	draw_circle(Vector2(0,0), 100.0,Color.red)

func _process(delta):
	update()
