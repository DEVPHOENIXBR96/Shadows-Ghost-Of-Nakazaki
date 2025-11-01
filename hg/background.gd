extends Node2D

var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:
	global_position = start_position
