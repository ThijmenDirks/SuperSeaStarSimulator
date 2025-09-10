extends CanvasLayer

@onready var last_screen_size = get_viewport().get_visible_rect().size
@onready var wave_number_label = $Control/WaveNumberLabel
@onready var selected_school_label = $Control/SelectedSchoolLabel
#@onready var mana_thingy = load("res://scenes/other/mana_thingy.tscn").instantiate()

var mana_thingies : Array

var all_colors = ["red", "blue", "green", "purple"]
var used_colors = ["red", "green", "blue", "a", "purple"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hi", wave_number_label)
	for i in range(used_colors.size() - 1, -1, -1):
		var color = used_colors[i]
		var new_mana_thingy = load("res://scenes/UI_and_the_like/mana_thingy.tscn").instantiate()
		add_child(new_mana_thingy)
		new_mana_thingy.my_color = color
		#new_mana_thingy.position = Vector2(-190, 50-i*30) # from top top bottom instean bottom to top ?
		new_mana_thingy.position = Vector2(35, 250-i*30)
		mana_thingies.append(new_mana_thingy)


func get_mana_thingies():
	return mana_thingies


func update_wave_number_label(new_wave_number):
	wave_number_label.text = "wave " + str(new_wave_number)


func update_selected_school_label(selected_school):
	selected_school_label.text = str(selected_school)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if last_screen_size != get_viewport().get_visible_rect().size and false:
		#var new_screen_size = get_viewport().get_visible_rect().size/last_screen_size
		#scale *= new_screen_size
		#last_screen_size = get_viewport().get_visible_rect().size


func _on_save_button_button_up() -> void:
	SaveSystem.save_data()
