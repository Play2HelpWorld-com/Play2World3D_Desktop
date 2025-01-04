extends Node3D

@export var highlight_material: StandardMaterial3D
<<<<<<< HEAD
@export var game_url: String = "https://play2helpgamesserver.onrender.com/snakeGame/?to=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM2MDYxMzMwLCJpYXQiOjE3MzU5NzQ5MzAsImp0aSI6IjZmYzlmZDk3MzY0OTQzM2JiOTAwOGM0YWU5MzQxOTUyIiwidXNlcl9pZCI6MTF9.ymAgeQl2e7FxUfe5LWJx8pNvBPvhhnOj_3Qq5T6yTfw"
=======
@export var new_scene_path: String = "res://addons/interactive/props/window/window.tscn"
@export var game_url: String = "https://play2helpgamesserver.onrender.com/tetrixGame/?to=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM2MDYxMzMwLCJpYXQiOjE3MzU5NzQ5MzAsImp0aSI6IjZmYzlmZDk3MzY0OTQzM2JiOTAwOGM0YWU5MzQxOTUyIiwidXNlcl9pZCI6MTF9.ymAgeQl2e7FxUfe5LWJx8pNvBPvhhnOj_3Qq5T6yTfw"
>>>>>>> df40a2fa1a150bb9e96adebf9dcf6e7a5515027f

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chest_meshinstance: MeshInstance3D = $Armature/Skeleton3D/top_Chest_0
@onready var chest_material: StandardMaterial3D = chest_meshinstance.mesh.surface_get_material(0)

var is_open: bool = false

<<<<<<< HEAD
# Open the chest and display the game URL
=======
# Function to open the specified URL in the default web browser
func open_game_url() -> void:
	OS.shell_open(game_url) # Opens the URL in the default web browser

# Function to load a new scene (if needed)
func load_new_scene() -> void:
	var new_scene = load(new_scene_path) # Load the new scene
	if new_scene:
		loaded_scene = new_scene.instantiate() # Create an instance of the new scene
		get_tree().current_scene.add_child(loaded_scene) # Add the new scene to the current scene

# Function to unload the scene
func unload_scene() -> void:
	if loaded_scene:
		loaded_scene.queue_free() # Free the loaded scene
		loaded_scene = null # Reset the reference to the loaded scene

# Open the chest and open the game URL
>>>>>>> df40a2fa1a150bb9e96adebf9dcf6e7a5515027f
func open() -> void:
	is_open = true
	animation_player.play("Open")

	# Fade the light in
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 11.5, 0.5)
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)
<<<<<<< HEAD

	# Open the game URL in an external browser or embedded window
	open_game_window()

# Close the chest
=======
	
	# Open the game URL
	open_game_url()

# Close the chest and unload the scene
>>>>>>> df40a2fa1a150bb9e96adebf9dcf6e7a5515027f
func close() -> void:
	is_open = false
	animation_player.play("Close")

	# Fade the light out
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

<<<<<<< HEAD
# Open the game URL in a new window or browser
func open_game_window() -> void:
	# Check if the Godot version/platform supports embedding web content
	if OS.has_feature("webview"):
		var web_view = WebView.new()
		web_view.url = game_url
		web_view.popup()
	else:
		OS.shell_open(game_url)  # Opens the URL in the system's default browser
=======
	# Unload the scene after closing
	unload_scene()
>>>>>>> df40a2fa1a150bb9e96adebf9dcf6e7a5515027f

# Add highlight effect to the chest
func add_highlight() -> void:
	chest_meshinstance.set_surface_override_material(0, chest_material.duplicate())
	chest_meshinstance.get_surface_override_material(0).next_pass = highlight_material

# Remove highlight effect from the chest
func remove_highlight() -> void:
	chest_meshinstance.set_surface_override_material(0, null)

<<<<<<< HEAD
# Toggle the chest's state (open/close) on interaction
=======
# Toggle the chest's state (open/close) and open the URL on interaction
>>>>>>> df40a2fa1a150bb9e96adebf9dcf6e7a5515027f
func _on_interactable_interacted(_interactor: Interactor) -> void:
	# Remove highlight and toggle the chest's state
	remove_highlight()
	if is_open:
		close()
	else:
		open()
