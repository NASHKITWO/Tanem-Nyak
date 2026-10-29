extends Node2D

enum mouse_states { ADD_CROP, ADD_DISEASE, EVOLVE, SPREAD, CYCLE, WATCH }

var mouse_state = 0

# The World scene is not loaded yet when this autoload is ready, so the camera
# container is resolved lazily (see _get_editor).
var editor = null
var editor_cam = null

export var cam_speed = 10
export var cam_zoom_speed = 0.1
var is_panning = true

func _get_editor():
	if editor == null or not is_instance_valid(editor):
		editor = get_node_or_null("/root/World/cam_container")
		editor_cam = null
		if editor:
			editor_cam = editor.get_node_or_null("Camera2D")
			if editor_cam:
				editor_cam.current = true
	return editor


func _process(_delta):
	move_editor()

#############################################################################
# Camera movement
# Used by the on-screen D-pad (GUI/TouchControls.gd)
func move_camera(dir: Vector2):
	var cam_container = _get_editor()
	if cam_container:
		cam_container.global_position += dir * cam_speed


func zoom_camera(direction: int):
	if _get_editor() and editor_cam:
		var z = clamp(editor_cam.zoom.x + direction * cam_zoom_speed * 3, 0.3, 3.0)
		editor_cam.zoom = Vector2(z, z)


func set_mouse_state(state: int):
	mouse_state = state
	print("mode: ", mouse_states.keys()[state].to_lower())


func move_editor():
	var cam_container = _get_editor()
	if cam_container == null:
		return
	if Input.is_action_pressed("w"):
		cam_container.global_position.y -= cam_speed
	if Input.is_action_pressed("a"):
		cam_container.global_position.x -= cam_speed
	if Input.is_action_pressed("s"):
		cam_container.global_position.y += cam_speed
	if Input.is_action_pressed("d"):
		cam_container.global_position.x += cam_speed


func _unhandled_input(event):
	#TODO: handle max/min zoom
	if _get_editor() == null or editor_cam == null:
		return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP:
			editor_cam.zoom -= Vector2(cam_zoom_speed, cam_zoom_speed)
		if event.button_index == BUTTON_WHEEL_DOWN:
			editor_cam.zoom += Vector2(cam_zoom_speed, cam_zoom_speed)

	if event is InputEventMouseMotion and Input.is_action_pressed("mb_middle"):
		editor.global_position -= event.relative * editor_cam.zoom

###############################################################################

func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_K:
				mouse_state = mouse_states.ADD_CROP
				print("add_crop")
			KEY_D:
				mouse_state = mouse_states.ADD_DISEASE
				print("add_disease")
			KEY_E:
				mouse_state = mouse_states.EVOLVE
				print("evolve (not implemented)")
			KEY_S:
				mouse_state = mouse_states.SPREAD
				print("spread")
			KEY_C:
				mouse_state = mouse_states.CYCLE
				print("cycle")
			KEY_O:
				mouse_state = mouse_states.WATCH
				print("watch")
