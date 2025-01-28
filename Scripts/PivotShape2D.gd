@tool
extends ColorRect
class_name PivotShape2D

var shader_material: ShaderMaterial = preload("res://Materials/PivotShape2D.material").duplicate(true)
@export_category("Appearance")
@export var _color := Color(1,1,1,1) :
	set(value): 
		_color = value
		color = _color
		material.set_shader_parameter("my_color", value)
		

@export_enum("Normal", "Multiply", "Screen", "Darken", "Lighten", "Difference", "Exclusion", "Overlay", "Hard_Light", "Soft_Light", "Color Dodge", "Linear Dodge", "Color Burn", "Linear Burn") var blend_mode : int :
	set(value):
		blend_mode = value
		if material == null:
			return
			
		match blend_mode:
			0:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			1:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			2:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			3:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			4:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			5:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			6:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			7:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			8:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			9:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			10:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			11:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			12:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			13:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			14:
				(material as ShaderMaterial).set_shader_parameter("blending_mode", value-1)
			
@export_enum("Rectangle", "Ellipsoid", "Polygon") var shape : int :
	set(value):
		shape = value
		if material == null:
			return
			
		match blend_mode:
			0:
				(material as ShaderMaterial).set_shader_parameter("shape", value)
			1:
				(material as ShaderMaterial).set_shader_parameter("shape", value)
			2:
				(material as ShaderMaterial).set_shader_parameter("shape", value)
				
@export_range(0,10, 1.0) var poly_count: float = 3.0 : 
	set(value):
		if material == null:
			return
		(material as ShaderMaterial).set_shader_parameter("poly_count", value)

@export_range(0.0,1.0,0.01) var edge_scalor = 1.0:
	set(value):
		if material == null:
			return
		edge_scalor = value
		material.set_shader_parameter("radius_scalor", edge_scalor)

@export var stroke_only := false:
	set(value):
		if material == null:
			return
		if stroke_only and edge_scalor >=1.0:
			edge_scalor = 0.9
		stroke_only= value
		material.set_shader_parameter("stroke_only", stroke_only)
		
@export var center_pivot := false:
	set(value):
		pivot = Vector2(0.5,0.5);
		pivot_offset = size*pivot
		center_pivot = false
		
@export var pivot := Vector2.ZERO : 
	set(value):
		pivot = value
		pivot_offset = size*pivot

@export var mask_children := false:
	set(value):
		mask_children = value
		clip_contents = mask_children
		
#func _set(property: StringName, value: Variant) -> bool:
	#if property == "color":
		#set_color(value)
		#if material == null:
			#return false
		#material.set_shader_parameter("my_color", value)
	#return true
	
func _ready() -> void:
	material = shader_material.duplicate(true)
	_color = _color
	set_color(_color)
	poly_count= poly_count
	shape = shape
	stroke_only = stroke_only
	edge_scalor = edge_scalor
	blend_mode = blend_mode
	poly_count = poly_count


func _on_size_flags_changed()->void:
	pivot = pivot

func _process(delta: float) -> void:
	pass
