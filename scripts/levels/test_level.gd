extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





		#"goblins" = 3,
		#"time" = 10,


# WIL ik, voor elke wae een nieuwe var, of alles in een grote dict?

var spawn_area_one: Area2D
var spawn_area_two: Area2D
var spawn_area_three: Area2D

var wave_one = {
	subwave_one = 
	{
		subwave_one = 
		{
		"goblin" = 3,
		"time" = 10,
		},
		subwave_two = 
		{
		"goblin" = 5,
		"time" = 15,
		},
		
	},
	subwave_two = 
	{
		
	},
	subwave_three = 
	{
		
	}


}var wave_one = {
	spawn_area_one = 
	{
		subwave_one = 
		{
		"goblin" = 3,
		"time" = 10,
		},
		subwave_two = 
		{
		"goblin" = 5,
		"time" = 15,
		},
		
	},
	spawn_area_two = 
	{
		
	},
	spawn_area_three = 
	{
		
	}
}
