extends Node3D

# Animation Tree
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _main_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")

# Eye Materials
@onready var _model_mesh: MeshInstance3D = $mini_sophia/Armature/Skeleton3D/sophia_mesh
@onready var _eye_left_mat: BaseMaterial3D = _model_mesh.get("surface_material_override/1")
@onready var _eye_right_mat: BaseMaterial3D = _model_mesh.get("surface_material_override/2")

# Blinking
var _blinking: bool = false
@onready var _blinking_timer: Timer = $BlinkTimer
@onready var _closed_eyes_timer: Timer = $ClosedTimer
var _eyes_atlas_order: Array[String] = ["default", "closed"]
var _eyes_atlas: Dictionary = {}
var _current_eyes: String = "default"

func _ready() -> void:
	# Initialize eyes atlas
	_eyes_atlas = _get_atlas(_eyes_atlas_order)

	# Start blinking logic
	_blinking_timer.connect("timeout", _on_blink_timer_timeout)
	_set_blinking(true)

	# Ensure character starts in idle animation
	idle()

func _get_atlas(base_atlas: Array[String]) -> Dictionary:
	var atlas: Dictionary = {}
	var step: float = 1.0 / base_atlas.size()
	for atlas_index in range(base_atlas.size()):
		atlas[base_atlas[atlas_index]] = step * float(atlas_index)
	return atlas

# Keep the character idle
func idle() -> void:
	_main_state_machine.travel("Idle")

# Set blinking
func _set_blinking(value: bool) -> void:
	_blinking = value
	if _blinking:
		_blinking_timer.start()
	else:
		_blinking_timer.stop()
		_set_eyes(_current_eyes)

# Blinking timer callback
func _on_blink_timer_timeout() -> void:
	# Close eyes
	_set_eyes("closed")
	_closed_eyes_timer.start(randf_range(0.1, 0.25))
	await _closed_eyes_timer.timeout
	# Return to default eyes
	_set_eyes(_current_eyes)
	_blinking_timer.wait_time = randf_range(1.0, 4.0)
	_blinking_timer.start()

# Update the current eyes state
func _set_eyes(eyes_name: String) -> void:
	var texture_offset: float = _eyes_atlas.get(eyes_name, 0.0)
	_eye_left_mat.set("uv1_offset", Vector3(0.0, texture_offset, 0.0))
	_eye_right_mat.set("uv1_offset", Vector3(0.0, texture_offset, 0.0))
