extends PathFollow2D

var speed = 0.5
var destination
var color

var size = 5
var type
var payload = 0
var target

func _ready():
	pass

func setup(backwards, new_payload, new_target, new_type):
	type = new_type
	payload = new_payload
	target = new_target
	if backwards:
		unit_offset = 1
		destination = 0
		speed = speed*-1
		set_unit_offset(1)
	else:
		unit_offset = 0
		destination = 1
	if type == "Nutrition":
		color = Color.green
		size = 5
	elif type == "Spreading":
		color = Color.yellow
		size = 10

func _draw():
	draw_circle(Vector2(0,0), size, color)

func _process(delta):
	offset += speed
	update()
	if unit_offset == destination:
		if type == "Nutrition":
			target.second_next_turn_nutrition += payload
		elif type == "Spreading":
			target.die()
			target.setup(payload)
		queue_free()
