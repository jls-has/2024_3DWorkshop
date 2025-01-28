@tool
extends TextureRect
class_name PivotMask2D

@export var center_pivot := false:
	set(value):
		pivot = Vector2(0.5,0.5);
		pivot_offset = size*pivot
		center_pivot = false
		
@export var pivot := Vector2.ZERO : 
	set(value):
		pivot = value
		pivot_offset = size*pivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = CurveTexture.new()
	texture.curve = Curve.new()
	texture.curve.add_point(Vector2.ONE)
	texture.set_width(32)
	clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
