extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$TextEdit.gui_input.connect(_on_text_edit_gui_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationPlayer.play('idle')

func _on_area_3d_body_entered(body: Node3D) -> void:
	$Label3D.visible = true
	print("you've entered the bot's area..")

func _on_area_3d_body_exited(body: Node3D) -> void:
	print("you've left the bot's area..")
	$Label3D.visible = false
	$TextEdit.visible = false
	$RichTextLabel.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ask"):
		print('q button pressed')
		if $Label3D.visible:
			$Label3D.visible = false
			$TextEdit.visible = true
			$TextEdit.grab_focus()
			Global.is_typing = true
			
			
		if event.is_action_pressed('exit-chat'):
			print('exit-chat has been pressed')
			Global.is_typing = false
			$TextEdit.text = ""
			$TextEdit.visible = false

func _on_text_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			print('chat submitted while typing')
			handle_submit()

func handle_submit() -> void:
	print('the enter button from handle clicked')
	$RichTextLabel.visible = true
	$TextEdit.visible = false
	getAnswer(str($TextEdit.text))
	$TextEdit.text = ""
	
func getAnswer(text: String) -> void:
	# Prepare request data (no authorization required)
	var url: String = "https://flowise-2-0.onrender.com/api/v1/prediction/9f1781bd-ad88-42a8-8baf-554a0e7b1ac9"
	var headers: PackedStringArray = PackedStringArray(["Content-Type: application/json"])
	var body: Dictionary = {
		"question": text
	}
	# Send the HTTP request
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response_str: String = body.get_string_from_utf8()
		var response_data: Variant = JSON.parse_string(response_str)
		if response_data is Dictionary and response_data.has("text"):
			var ai_response: String = response_data["text"]
			$RichTextLabel.text = ai_response
		else:
			# Show error message in case of failure
			$RichTextLabel.push_color(Color.DARK_RED)
			$RichTextLabel.append_text("\n\n---\n\n[u]Error:[/u] Failed to parse response.")
			$RichTextLabel.pop()
		$TextEdit.visible = true
		$TextEdit.grab_focus()

func _on_greeting_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.

func _on_greeting_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
