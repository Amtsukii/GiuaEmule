extends Control

onready var ChatLog = get_node("VBoxContainer/RichTextLabel")
onready var inputLabel = get_node("VBoxContainer/HBoxContainer/Label")
onready var inputField = get_node("VBoxContainer/HBoxContainer/LineEdit")

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


func _ready():
	inputField.connect("text_entered", self, "text_entered")
	add_message('Giua', '/h per vedere la lista dei comandi')
	add_message('Sviluppatore', 'ti ricordo che il gioco è sempre in sviluppo')
	add_message('Sviluppatore', 'aiutateci a migliorarlo dandoci dei suggerimenti di cosa vorreste')
	add_message('Sviluppatore', 'Contatti: +393450752957')
	change_group(0)


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			inputField.grab_focus()
			
		if event.pressed and event.scancode == KEY_ESCAPE:
			inputField.release_focus()
		if event.pressed and event.scancode == KEY_F3:
			change_group(1)

	

func change_group(value):
	group_index += value
	if group_index > (groups.size() - 1):
		group_index = 0
	inputLabel.text = '[' + groups[group_index]['name'] + ']'
	inputLabel.set('custom_colors/font_color', Color(groups[group_index]['color']))

func add_message(username, text, group = 0):
	ChatLog.bbcode_text += '\n'
	ChatLog.bbcode_text += '[color=' + groups[group]['color'] + ']'
	ChatLog.bbcode_text += '['+ username +']: '
	ChatLog.bbcode_text += text
	ChatLog.bbcode_text += '[/color]'


func text_entered(text):
	if text == '/giua':
		add_message('giua', 'Comanidi:', 0)
		add_message('giua', 'Premi f3 per cambiare gruppo:', 0)
		add_message('giua', 'Premi invio per accede alla chat:', 0)
		inputField.text = ''
		return
	if text != '':
		var gruppo = '[' + groups[group_index]['name'] + ']'
		print(text)
		add_message(gruppo + ']' + '[' + username,text, group_index)
		inputField.text = ''
