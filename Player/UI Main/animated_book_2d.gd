extends AnimatedSprite2D

var ENTRIES: int
var ENTRIES_PER_PAGE: int = 2

@onready var next_page: TextureButton = $NextPage
@onready var previous_page: TextureButton = $PreviousPage
@onready var left_page: RichTextLabel = $LeftPage
@onready var rigt_page: RichTextLabel = $RigtPage

#var diseases: Array = ["DA","DB","DC"]
#var symptoms: Array = ["SA","SB","SC","SD"]

#var left_count = 0
#var rigt_count = 0
var glossary: Array[String]
var n_of_pages: int
var current_side: int = 0
var page_content: Dictionary = {}
var opening := 0


#func _ready() -> void:
	
	
	
	#for i in ENTRIES:
		#glossary.append(diseases[randi()%2]+ ": " + symptoms[randi()%3] + " + " + symptoms[randi()%3] + "\n")
		
		#for i in n_of_pages:
		#print("page: " + str(i+1) + "\n" + str(page_content[i]) + "\n ")
	#print(n_of_pages)
	#show_side(opening)
	
		#print("page: " + i + "\n" + page_content[i] + "\n ")
	#for i in range(0,7):
		#left_count = 0
		#rigt_count = 0
		#if left_count < 3:
			#left_page.text += glossary[i]
			#left_count += 1
		#elif rigt_count < 3:
			#rigt_page.text += glossary[i]
			#rigt_count += 1
		#else:
			#print("out of pages")
			#return
	#print(glossary)
	
	
func reset_pages():
	left_page.text = ""
	rigt_page.text = ""
	
	
	
func Configurar_Paginas(Array_de_Entrada: Array):
	
	var Temp_Array: Array[String] = Array_de_Entrada.duplicate(true)
	
	ENTRIES = Temp_Array.size()
	
	n_of_pages = ceil( float(ENTRIES) / ENTRIES_PER_PAGE)
	
	
	for page in n_of_pages:
		page_content[page] = []
		for j in range(ENTRIES_PER_PAGE):
			if Temp_Array.size() > 0:
				page_content[page].append(Temp_Array[0])
				Temp_Array.pop_front()
			else:
				break
				
				
				
	print(n_of_pages)
	
	
	
	
	show_side(opening)
	
func show_side(side):
	show_left_page(side)
	show_rigt_page(side+1)
	if side >= n_of_pages-2:
		next_page.visible = false
		next_page.disabled = true
	else:
		next_page.visible = true
		next_page.disabled = false
	
	if side <= 0:
		previous_page.visible = false
		previous_page.disabled = true
	else:
		previous_page.visible = true
		previous_page.disabled = false

func show_left_page(page:int):
	if page_content.has(page):
		
		for i in range(page_content[page].size()):
			left_page.text += page_content[page][i]
		
		
		
	else:
		left_page.text = ""

func show_rigt_page(page:int):
	if page_content.has(page):
		for i in range(page_content[page].size()):
			rigt_page.text += page_content[page][i]
	else:
		rigt_page.text = ""

func _on_next_page_pressed() -> void:
	left_page.text = ""
	rigt_page.text = ""
	next_page.disabled = true
	previous_page.disabled = true
	next_page.visible = false
	previous_page.visible = false
	play("page_next")
	await animation_finished
	current_side += 2
	show_side(current_side)
	

func _on_previous_page_pressed() -> void:
	left_page.text = ""
	rigt_page.text = ""
	next_page.disabled = true
	previous_page.disabled = true
	next_page.visible = false
	previous_page.visible = false
	play("page_back")
	await animation_finished
	current_side -= 2
	show_side(current_side)
	
