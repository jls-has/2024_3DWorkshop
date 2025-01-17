@tool
extends Marker3D
class_name PivotShape3D

@export_category("Appearance")
@export_enum("Box", "Capsule", "Cylinder", "Prism", "Sphere", "Empty") var shape : int :
	set(value):
		shape = value
		set_mesh_shape(shape)
@export var color : Color :
	set(value):
		color = value
		set_color(color)
@export var shadows := false:
	set(value):
		shadows = value
		set_shadows(shadows)

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
@export var osc_rotation := Vector3.ZERO
@export var p_speed := 1.0
@export var osc_position := Vector3.ZERO

var init := false
var time := 0.0

func _ready() -> void:
	init = true
	set_mesh_shape(shape)
	set_color(color)
	set_shadows(shadows)
	
func _process(delta: float) -> void: 
	if enable_animation:
		time += delta
		rotation.x = sin(time*r_speed)*osc_rotation.x
		rotation.y = sin(time*r_speed)*osc_rotation.y
		rotation.z = sin(time*r_speed)*osc_rotation.z
		position.x = sin(time*p_speed)*osc_position.x
		position.y = sin(time*p_speed)*osc_position.y
		position.z = sin(time*p_speed)*osc_position.z
	
func set_color(_color: Color)->void:
	if not init:
		return
	$Mesh.get_surface_override_material(0).albedo_color = _color

func set_shadows(_b:bool)->void:
	if not init:
		return
	if _b:
		$Mesh.get_surface_override_material(0).shading_mode = 1
	else:
		$Mesh.get_surface_override_material(0).shading_mode = 0
		
func set_mesh_shape(_shape: int)->void:
	if not init:
		return
	match _shape:
		0:
			$Mesh.mesh = BoxMesh.new()
		1:
			$Mesh.mesh = CapsuleMesh.new()
		2:
			$Mesh.mesh = CylinderMesh.new()
		3:
			$Mesh.mesh = PrismMesh.new()
		4:
			$Mesh.mesh = SphereMesh.new()
		5: 
			$Mesh.mesh = null
