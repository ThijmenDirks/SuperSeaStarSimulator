extends Node

var old_window_mode

func _input(event):
	#print("iinputevent ", event)
	if event.is_action_pressed("c"):
		set_fullscreen()


func set_fullscreen():
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		old_window_mode = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		return
	else:
		DisplayServer.window_set_mode(old_window_mode)
		return
