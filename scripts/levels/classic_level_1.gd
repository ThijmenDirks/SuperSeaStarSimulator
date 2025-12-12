class_name ClassicLevel
extends Node2D

const GOBLIN = preload("res://scenes/enemies/goblin.tscn")

var current_enemies_amount: int = 0
var cg_label: Label

@onready var timer: Timer = $Timer
@onready var player: Player = $CharacterBody2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.classic_mode = true
	var interface = player.get_child(0)
	interface.get_child(0).get_child(0).queue_free() # kleurenbalkje
	interface.get_child(0).get_child(7).queue_free() # SelectedSchoolBar
	for i in range(4):
		interface.get_child(i + 4).queue_free()

	cg_label = interface.cg_label
	cg_label.visible = true


func _process(delta: float) -> void:
	cg_label.text = str("goblins: ") + str(current_enemies_amount)


func _on_timer_timeout() -> void:
	spawn_goblins()
	timer.start(randi_range(2, 5))

func spawn_goblins():
	for i in randi_range(2, 5):
		var goblin_pos: Vector2 = Vector2(randi_range(-868, 1169), randi_range(-427, 418))
		if goblin_pos.distance_to(player.position) > 190:
			var new_goblin = GOBLIN.instantiate()
			new_goblin.position = goblin_pos
			add_child(new_goblin)
			current_enemies_amount += 1
			print("gobling spawned ! there are now ", current_enemies_amount, " goblins ! ssss", randf())


#-868, -427
#
#1169, 418
