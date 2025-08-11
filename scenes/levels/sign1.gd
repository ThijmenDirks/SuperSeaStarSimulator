extends Node2D

var player_near = false

func _ready():
	$Label.visible = false

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_near = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_near = false
		$Label.visible = false
		
func _unhandled_input(event):
	if event.is_action_pressed("T") and player_near:
		$Label.visible = !$Label.visible
	
