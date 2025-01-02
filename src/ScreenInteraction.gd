extends Node3D

@export var screen_scene: PackedScene = preload("res://data/scene/Play2World/maps/center_map/pop_up.tscn")
@onready var interactable_area: Area3D = $Area3D  # The interactable area
var screen_instance: Node = null  # Holds the loaded screen instance
var is_screen_open: bool = false  # Tracks whether the screen is currently displayed
var can_interact: bool = false  # Tracks if the player is in the interaction area

func _ready() -> void:
	if not interactable_area:
		print("Error: 'Area3D' node not found. Ensure the node is named 'Area3D' and exists under this node.")
		return

	# Connect signals
	interactable_area.body_entered.connect(_on_interactable_focused)
	interactable_area.body_exited.connect(_on_interactable_unfocused)

# Player entered interaction area
func _on_interactable_focused(body: Node) -> void:
	if body.name == "Player":  # Replace "Player" with the name of your player node
		can_interact = true
		print("Player entered interaction area.")

# Player exited interaction area
func _on_interactable_unfocused(body: Node) -> void:
	if body.name == "Player":  # Replace "Player" with the name of your player node
		can_interact = false
		print("Player exited interaction area.")

# Triggered when the interact button is pressed
func _on_interactable_interacted(_interactor: Interactor) -> void:
	if can_interact:
		interact()

func interact() -> void:
	# Toggles between opening and closing the screen
	if is_screen_open:
		close_screen()
	else:
		open_screen()

func open_screen() -> void:
	if not screen_scene:
		print("Error: No `screen_scene` assigned.")
		return

	if not is_screen_open:
		# Instance the screen scene and add it to the current node
		screen_instance = screen_scene.instantiate()
		add_child(screen_instance)
		is_screen_open = true
		print("Screen opened and loaded.")

func close_screen() -> void:
	if screen_instance:
		screen_instance.queue_free()
		screen_instance = null
		is_screen_open = false
		print("Screen closed and unloaded.")
