extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$Music.play()
	_start_tutorial(0)

func _start_tutorial(part):
	$BG.show_default()
	match part:
		0:
			_prepare_field(10)
			yield(
				_message_window(
					[
						"@Доброе утро Сержант.",
						"@В Алжир съежаются важные шишки.",
						"@Их задача - закопать радиоактивный мусор в пустыне.",
						"@Президенту Ранаяну пообещали приз если он пойдет на это.",
						"@Терористам из группировки \"черный баклажан\" эта преспектива крайне ненравится.",
						"@Они заминировали часть Сахары на подьезде к Алжиру.",
						"@Задача нашей ЧВК - не один толстосум не должен превратиться в мокрое место на песочке.",
						"@Вопросы?",
						"#Никак нет.",
						"#Разрешите выполнять задание?",
						"@Разрешаю.",
						"@Желаю удачи."
					]
				),
				"completed"
			)
			if (yield(_lust_for_demine(10), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		1:
			yield(
				_message_window(
					[
						"@На этом все.",
						"@Не думаю что ты долго протянешь на настоящем поле.",
						"@Легкой смерти!",
					]
				),
				"completed"
			)
			get_tree().quit()

func _play_sfx(event):
	if event["name"] == "tile_open":
		$OpenSFX.stop()
		$OpenSFX.play()
	elif event["name"] == "tile_demine":
		$DemineSFX.stop()
		$DemineSFX.play()
		
func _message_window(messages):
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_colonel.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	message_window.get_node("Message").avatar_3 = null
	add_child(message_window, true);
	yield($MessageWindow, "tree_exited")

func _show_fail_message():
	yield(
		_message_window(
			[
				"@Вы идиот, сержант.",
				"@Еще раз, сержант.",
				"@И постарайтесь не быть большим идиотом чем вы есть, сержант."
			]
		),
		"completed"
	)

func _show_success_message():
	yield(
		_message_window(
			[
				"@Очень хорошо, сержант."
			]
		),
		"completed"
	)


func _fail(event):
	if event["name"] == "tile_demine" and not event["tile"].mine:
		return true
	if event["name"] == "tile_open" and event["tile"].mine:
		return true
	return false

func _prepare_field(mines):
	$Field.reset()
	$Field.distribute_mines(mines)
	$Field.get_safty_tile().swing()
	$OpenSFX.play()

func _lust_for_demine(demine_counter):
	var _result = false
	##################################
	$Music.fade_in()
	while true:
		var event = yield($Field, "change")
		_play_sfx(event)
		$Voice.talk()
		if _fail(event):
			_result = false
			break
		if $Field.demined_tiles() == demine_counter:
			_result = true
			break
	$Music.fade_out()
	##################################
	if _result:
		$VictorySFX.play()
		yield($VictorySFX, "finished")
		yield(_show_success_message(), "completed")
	else:
		$BG.show_explosion()
		$FireSFX.play()
		yield($FireSFX, "finished")
		yield(_show_fail_message(), "completed")
	##################################
	return _result
	
func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()
