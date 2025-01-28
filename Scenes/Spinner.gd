@tool
extends Node2D

@export var speed : float = 0.0
@export var spin : bool = true

func _process(delta: float) -> void:
	if spin:
		rotation += speed * delta
