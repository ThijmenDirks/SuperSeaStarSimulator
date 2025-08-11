extends Node2D


@export var text: String = "whatch out! a sign!"
@onready var label = $Label

var player_is_near = false


func _ready():
	label.visible = false


func _on_Area2D_body_entered(body):
	if body is Player:
		player_is_near = true
		print("sign, player is near")


func _on_Area2D_body_exited(body):
	if body is Player:
		player_is_near = false
		label.visible = false
		print("sign, player is far")



func _unhandled_input(event):
	print("sign, T has been pressed")
	if event.is_action_pressed("T") and player_is_near:
		print("sign")
		label.visible = !label.visible
	
