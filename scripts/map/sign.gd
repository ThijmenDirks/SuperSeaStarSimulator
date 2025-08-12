extends Node2D


@export var text: String = "whatch out! a sign!"
@onready var label = $Label

var player_is_near = false


func _ready():
	label.text = text
	label.visible = false


func _unhandled_input(event):
	#print("sign, T has been pressed")
	if event.is_action_pressed("T"):# and player_is_near:
		print("sign, T has been pressed")
		if player_is_near:
			print("sign, show text")
			label.visible = !label.visible


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("sign, body is near")
	if body is Player:
		player_is_near = true
		print("sign, player is near")


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("sign, body is far")
	if body is Player:
		player_is_near = false
		label.visible = false
		print("sign, player is far")
