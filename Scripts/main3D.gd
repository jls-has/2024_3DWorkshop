@tool
extends Node3D
@export_category("World Settings")
@export var background_color : Color :
	set(value):
		background_color = value
		if environment:
			environment.environment.background_color = background_color

@export_category("nodes")
@export var camera : Camera3D 
@export var environment : WorldEnvironment

@export_global_dir var save_path

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	else:
		if Input.is_action_just_pressed("ui_accept"):
			take_photo()

func take_photo()->void:
	if save_path:
		var vp : Viewport = get_viewport()
		var t : ViewportTexture = vp.get_texture()
		var i : Image = t.get_image()
		#i.save_jpg(save_path + "/workshop.jpg")
		
