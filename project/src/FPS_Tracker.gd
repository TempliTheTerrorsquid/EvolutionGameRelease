extends Control

var current_fps
var worst_fps = 10000
var worst_fps_in_last_10_seconds
var average_fps = 0
var frame_counter = 0
var last_timestamp
var last_10_seconds_record = []
var last_1_second_record = []

func _ready():
	last_timestamp = OS.get_ticks_msec()

func _process(delta):
	frame_counter += 1
	current_fps = 1/delta
	$VBoxContainer/Label_CurrentFPS.text = "Current FPS: " + str(current_fps)
	if frame_counter%100 == 0:
		var new_timestamp = OS.get_ticks_msec()
		average_fps = 1000/((float(new_timestamp)/frame_counter))
		$VBoxContainer/Label_AverageFPS.text = "Average FPS: " + str(average_fps)
		last_timestamp = new_timestamp
	if current_fps < worst_fps:
		worst_fps = current_fps
		$VBoxContainer/Label_WorstFPS.text = "Worst FPS: " + str(worst_fps)
	
	last_10_seconds_record.append(current_fps)
	$VBoxContainer/Label_SpikeFPS_10sec.text = "Spike FPS (worst FPS in last 10 seconds): " + str(last_10_seconds_record.min())
	if frame_counter > 1000:
		last_10_seconds_record.remove(0)

	last_1_second_record.append(current_fps)
	$VBoxContainer/Label_SpikeFPS_1sec.text = "Spike FPS (worst FPS in last 1 second): " + str(last_1_second_record.min())
	if frame_counter > 100:
		last_1_second_record.remove(0)
	
	print(len(last_1_second_record))
	print(len(last_10_seconds_record))
