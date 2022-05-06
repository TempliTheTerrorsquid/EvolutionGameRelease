class_name ZoomingCamera2D
extends Camera2D

################################
#zooming in and out
################################

export var min_zoom := 0.3
export var max_zoom := 5.0

export var zoom_factor := 0.1
export var zoom_duration := 0.2

var _zoom_level := 1.0 setget _set_zoom_level

onready var tween: Tween = $Tween

func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
	tween.interpolate_property(self, "zoom", zoom, Vector2(_zoom_level, _zoom_level),
	zoom_duration, tween.TRANS_SINE, tween.EASE_OUT)
	tween.start()

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)

################################
#move camera by dragging mouse
################################

var mouse_start_pos
var screen_start_position

var dragging = false


func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

