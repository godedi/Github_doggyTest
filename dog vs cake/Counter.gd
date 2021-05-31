extends Label

var cookies = 0

func _ready():
	text = String(cookies)



func _on_cookie_cookieCollected():
	cookies = cookies + 1
	_ready()
