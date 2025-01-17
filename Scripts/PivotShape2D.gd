@tool
extends Marker2D
class_name PivotShape2D

@export_category("Appearance")

@export var pivot_offset : Vector2 = Vector2.ZERO :
	set(value):
		pivot_offset = value
		queue_redraw()
		
@export_enum("Box", "Circle", "Triangle", "Line") var shape : int :
	set(value):
		shape = value
		queue_redraw()

@export_range(0, 5000, .5) var radius : float = 50.0 :
	set(value):
		radius = value
		queue_redraw()

##@export var scale_x : float  = 1.0 :
	##set(value):
		##scale_x = value
		##if scale_link_xy:
			##scale_y = value
		##scale = Vector2(scale_x, scale_y)
#
#@export var scale_y : float  = 1.0 :
	#set(value):
		#scale_y = value
		#if scale_link_xy:
			#scale_x = value
		#scale = Vector2(scale_x, scale_y)
#
#@export var scale_link_xy : bool = true:
	#set(value):
		#scale_link_xy = value
		#
@export var invisible : bool = false :
	set(value):
		invisible = value
		queue_redraw()
		
@export var color : Color :
	set(value):
		color = value
		queue_redraw()

@export var filled : bool = true :
	set(value):
		filled = value
		if not filled and stroke_width <1:
			stroke_width = 1.0
		queue_redraw()

@export_range (0,1000, 1.0) var stroke_width : float = 0.0 :
	set(value):
		stroke_width = value
		queue_redraw()
		
@export var anti_aliased : bool = true : #https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html#antialiased-drawing
	set(value):
		anti_aliased = value
		queue_redraw()

@export_enum("Mix", "Add", "Subtract", "Mask") var blend_mode : int :
	set(value):
		blend_mode = value
		if material == null:
			material = CanvasItemMaterial.new()
		set_clip_children_mode(CanvasItem.CLIP_CHILDREN_DISABLED)
		match blend_mode:
			0:
				(material as CanvasItemMaterial).blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
			1:
				(material as CanvasItemMaterial).blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
			2:
				(material as CanvasItemMaterial).blend_mode = CanvasItemMaterial.BLEND_MODE_SUB
			3:
				(material as CanvasItemMaterial).blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
				queue_redraw()
				print("masking")
				set_clip_children_mode(CanvasItem.CLIP_CHILDREN_MAX)
			
		

@export_category("Movement")
@export var enable_animation := false :
	set(value):
		enable_animation = value
		time = 0.0
@export var offset := Vector3.ZERO :
	set(value):
		offset = value
		if init:
			$Mesh.position = offset
			
@export var r_speed := 1.0
@export var osc_rotation :float = 0.0
@export var p_speed := 1.0
@export var osc_position := Vector2.ZERO

var init := false
var time := 0.0

func _ready() -> void:
	init = true
	
	
func _process(delta: float) -> void: 
	if enable_animation:
		time += delta
		rotation = sin(time*r_speed)*osc_rotation
		
		position.x = sin(time*p_speed)*osc_position.x
		position.y = sin(time*p_speed)*osc_position.y

func _draw()->void:
	if invisible:
		return
	var _stroke_width = stroke_width
	var _color = color
	
	if filled:
		_stroke_width = -1.0
	

		
	match shape:
		0: #Box
			draw_rect(Rect2(-radius + pivot_offset.x,-radius+ pivot_offset.y, radius*2,radius*2), _color, filled, _stroke_width, anti_aliased )
		1: #Circle
			draw_circle(Vector2.ZERO + pivot_offset, radius, _color, filled, _stroke_width, anti_aliased)
		2: #Triangle
			var points : PackedVector2Array = [
				Vector2(-radius, radius) + pivot_offset,
				Vector2(0, -radius)+pivot_offset,
				Vector2(radius, radius)+pivot_offset,
				Vector2(-radius, radius) + pivot_offset
			]
			if filled:
				draw_colored_polygon(points, _color)
				
			else:
				draw_polyline(points, _color, stroke_width, anti_aliased)
		3: #Line
			filled = false
			#if position == Vector2.ZERO and stroke_width < 5.0:
				#stroke_width = 5.0
			draw_line(Vector2(-radius,0) + pivot_offset, Vector2(radius, 0) + pivot_offset, _color, stroke_width)
