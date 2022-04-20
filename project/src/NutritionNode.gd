extends PathFollow2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	offset = 0


func _draw():
	draw_circle(Vector2(0,0), 10.0,Color.green)

func _process(delta):
	offset += 1
	if unit_offset == 1:
		queue_free()
