extends Node2D

onready var connection_class_ref = load("res://src/Connection.tscn")

func _ready():
	var con = connection_class_ref.instance()
	con.init($Wolf, $Elk)
	add_child(con)
	con = connection_class_ref.instance()
	con.init($Elk, $Grass)
	add_child(con)

func _process(delta):
	pass
