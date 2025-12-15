extends Node2D

@onready var score_label: Label = $ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not get_parent().get_parent() is Spawn:
		score_label.text = "score: " + str(get_parent().score * 10)
		#await get_tree().physics_frame
		score_label.position.x = -(score_label.size.x/2)
	else:
		score_label.text = " "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	print("paused ? ", get_tree().paused)
	get_tree().paused = false
	var menu = load("res://scenes/other/menu.tscn").instantiate()
	#get_parent().add_child(menu)
	#queue_free()
	#get_tree().paused = false
	get_parent().get_parent().get_parent().add_child(menu)#"menu").visible = true
	get_parent().get_parent().queue_free() # delete level
	#get_tree().paused = false
	print("still paused ? ", get_tree().paused)
