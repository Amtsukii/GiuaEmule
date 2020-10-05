extends Control

onready var chat = get_node("VBoxContainer/HBoxContainer/LineEdit")
onready var ChatLog = get_node("VBoxContainer/RichTextLabel")

func _ready():
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_success")
	network.connect("game_ended", self, "_on_game_ended")
	network.connect("game_error", self, "_on_game_error")
	
#	for ip in IP.get_local_addresses():
#		if str(ip).split(".")[0] == "192":
#			$IP/Value.text = str(ip)
var groups = [
	{'name': 'Alunno', 'color': '#ffffff'},
	{'name': 'Alunna', 'color': '#db65d3'},
	{'name': 'Spaccino', 'color': '#207e06'},
	{'name': 'Tamarro', 'color': '#a59c15'},
	{'name': 'Musicista', 'color': '#801f94'},
	{'name': 'Nerd', 'color': '#523f07'},
	{'name': 'Bidello', 'color': '#89efea'},
	{'name': 'Bullo', 'color': '#7c0909'},
	{'name': 'MrRobot', 'color': '#27bd12'},
	{'name': 'Professore', 'color': '#0e51a6'},
	{'name': 'Professoressa', 'color': '#c14fb7'}
]
var group_index = 0
	
var username = OS.get_environment("USERNAME")

func add_message(username, text, group = 0):
	ChatLog.bbcode_text += '\n'
	ChatLog.bbcode_text += '[color=' + groups[group]['color'] + ']'
	ChatLog.bbcode_text += '['+ username +']: '
	ChatLog.bbcode_text += text
	ChatLog.bbcode_text += '[/color]'

func text_entered(text):
	if text != '':
		var gruppo = '[' + groups[group_index]['name'] + ']'
		print(text)
		add_message(gruppo + ']' + '[' + username,text, group_index)
		chat.text = ''
	
	if OS.has_environment("USERNAME"):
		$Name/Value.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Name/Value.text = desktop_path[desktop_path.size()-2]


func _on_quit_button_pressed():
	get_tree().quit()

func _on_join_button_pressed():
	var player_name = $Name/Value.text
	if $Name/Value.text == "":
		$Info.text = "Nome Non Valido"
		return
	
	var ip = $IP/Value.text
	if !ip.is_valid_ip_address():
		$Info.text = "Ip Non Valido se hai dubbi contatta (+393450752957)!"
		return
	
	var port = $Port/Value.value
	
	disable_ui("Stai Entrando Nel Giua...")
	network.join_game(ip, port, player_name)


func disable_ui(message=""):
	$Buttons/join_button.disabled = true
	$Name/Value.editable = false
	$IP/Value.editable = false
	$Port/Value.editable = false
	$Info.text = message


func enable_ui(message="", connected=false):
	$Buttons/join_button.disabled = false
	$Name/Value.editable = true
	$IP/Value.editable = true
	$Port/Value.editable = true
	$Info.text = message
	if connected:
		return
	yield(get_tree().create_timer(3.0), "Errore Di Connessione All'Host")
	$Info.text = ""


func _on_game_error(error_text):
	enable_ui(error_text)


func _on_game_ended():
	show()
	enable_ui()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_connection_failed():
	enable_ui("Connessione fallita per problemi di connessione contatta (+393450752957)")


func _on_connection_success():
	enable_ui("Connesso!", true)
