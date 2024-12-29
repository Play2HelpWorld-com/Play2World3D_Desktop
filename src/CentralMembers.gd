extends Node3D

@onready var avatar_node: Array = [ $api_json/Avatar1, etc]
# Arrays for labels
@onready var name_labels: Array = [
	$api_json/Name1, $api_json/Name2, $api_json/Name3, $api_json/Name4, $api_json/Name5, 
	$api_json/Name6, $api_json/Name7, $api_json/Name8, $api_json/Name9, $api_json/Name10
]
@onready var role_labels: Array = [
	$api_json/Role1, $api_json/Role2, $api_json/Role3, $api_json/Role4, $api_json/Role5,
	$api_json/Role6, $api_json/Role7, $api_json/Role8, $api_json/Role9, $api_json/Role10
]
@onready var joindate_labels: Array = [
	$api_json/JoinDate1, $api_json/JoinDate2, $api_json/JoinDate3, $api_json/JoinDate4, $api_json/JoinDate5,
	$api_json/JoinDate6, $api_json/JoinDate7, $api_json/JoinDate8, $api_json/JoinDate9, $api_json/JoinDate10
]
@onready var brands_labels: Array = [
	$api_json/Brands1, $api_json/Brands2, $api_json/Brands3, $api_json/Brands4, $api_json/Brands5,
	$api_json/Brands6, $api_json/Brands7, $api_json/Brands8, $api_json/Brands9, $api_json/Brands10
]
@onready var earned_tokens_labels: Array = [
	$api_json/EarnedTokens1, $api_json/EarnedTokens2, $api_json/EarnedTokens3, $api_json/EarnedTokens4, $api_json/EarnedTokens5,
	$api_json/EarnedTokens6, $api_json/EarnedTokens7, $api_json/EarnedTokens8, $api_json/EarnedTokens9, $api_json/EarnedTokens10
]
@onready var earned_dollars_labels: Array = [
	$api_json/EarnedDollars1, $api_json/EarnedDollars2, $api_json/EarnedDollars3, $api_json/EarnedDollars4, $api_json/EarnedDollars5,
	$api_json/EarnedDollars6, $api_json/EarnedDollars7, $api_json/EarnedDollars8, $api_json/EarnedDollars9, $api_json/EarnedDollars10
]

# Timer for polling API data
var polling_interval: float = 5.0  # Time in seconds
var polling_timer: Timer

func _ready() -> void:
	# Create a Timer for periodic API calls
	polling_timer = Timer.new()
	polling_timer.wait_time = polling_interval
	polling_timer.autostart = true
	polling_timer.one_shot = false
	add_child(polling_timer)
	polling_timer.timeout.connect(fetch_member_data)

	# Fetch data immediately on start
	fetch_member_data()

func fetch_member_data() -> void:
	# Create and set up an HTTPRequest node
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)

	# Connect the request_completed signal
	http_request.request_completed.connect(_on_request_completed)

	# Define the API URL
	var url: String = "https://play2helpbackend.onrender.com/api/games/getMemberData/"
	
	# Make the request
	var result: int = http_request.request(url)

	if result != OK:
		print("Failed to make HTTP request. Error code:", result)

func _on_request_completed(
	result: int, response_code: int, headers: Array, body: PackedByteArray
) -> void:
	if response_code == 200:
		# Decode the JSON response
		var json: String = body.get_string_from_utf8()
		var json_parser: JSON = JSON.new()
		var parse_result: int = json_parser.parse(json)

		if parse_result != OK:
			print("Failed to parse JSON:", json_parser.get_error_message())
			return

		# Access the JSON data
		var response_data: Dictionary = json_parser.data
		var member_data: Array = response_data.get("member_data", [])
		update_member_data(member_data)
	else:
		print("HTTP Request failed with code:", response_code)

func update_member_data(member_data: Array) -> void:
	# Update each label dynamically based on the data
	for i in range(name_labels.size()):
		if i < member_data.size():
			var data: Dictionary = member_data[i]
			name_labels[i].text = data.get("name", "Unknown Name")
			role_labels[i].text = data.get("role", "Unknown Role")
			joindate_labels[i].text = data.get("join_date", "Unknown Date")
			brands_labels[i].text = data.get("brands", "No Brands")
			earned_tokens_labels[i].text = str(data.get("earned_tokens", "0.0"))
			earned_dollars_labels[i].text = str(data.get("earned_dollars", "0.0"))
		else:
			# If no data available, set placeholders
			name_labels[i].text = "Processing..."
			role_labels[i].text = "Processing..."
			joindate_labels[i].text = "Processing..."
			brands_labels[i].text = "Processing..."
			earned_tokens_labels[i].text = "Processing..."
			earned_dollars_labels[i].text = "Processing..."
