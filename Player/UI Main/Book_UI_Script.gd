extends Control


var Glossario_de_Doencas: Array : set = Glossario_Setado


@onready var book: AnimatedSprite2D = $Control/Book
@onready var close: Button = $Close



func Glossario_Setado(Array_de_Entrada: Array):
	
	Glossario_de_Doencas = Array_de_Entrada
	book.Configurar_Paginas(Array_de_Entrada)
	
	
	
	
func Open_Book() -> void:
	book.show()
	book.play("open_book")
	close.disabled = false
	close.visible = true
	await book.animation_finished
	if book.opening >= book.n_of_pages-2:
		book.next_page.visible = false
		book.next_page.disabled = true
	else:
		book.next_page.visible = true
		book.next_page.disabled = false
	
	if book.opening <= 0:
		book.previous_page.visible = false
		book.previous_page.disabled = true
	else:
		book.previous_page.visible = true
		book.previous_page.disabled = false
	book.left_page.visible = true
	book.rigt_page.visible = true
	#book.next_page.visible = true
	#book.next_page.disabled = false
	#book.previous_page.visible = true
	#book.previous_page.disabled = false

func _on_close_pressed() -> void:
	
	book.current_side = 0
	book.left_page.visible = false
	book.rigt_page.visible = false
	book.next_page.visible = false
	book.next_page.disabled = true
	book.previous_page.visible = false
	book.previous_page.disabled = true
	close.disabled = true
	close.visible = false
	book.play("close_book")
	#await book.animation_finished
	#book.hide()
	
	
	book.reset_pages()
	book.Configurar_Paginas(Glossario_de_Doencas)
