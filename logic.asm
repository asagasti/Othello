; Amanda Sagasti - B36269

SECTION .data
	global colorficha
	m8: times 64 dd 0 ; matriz de 8x8
	m6: times 36 dd 0 ; matriz de 6x6
	m10: times 100 dd 0 ; 10x10
	xcor: dd 0 ; coordenada x
	ycor: dd 0 ; coordenada y
	
SECTION .text
	global ponerficha
	global fueratablero
	
ponerficha:
; to do: verificar que este a la par de una ficha y el color
	call posicionvalida ; verifica que se puede poner una ficha en posicion valida (posicion este vacia)
	cmp ebx, 3
	je end
;	mov [xcor], colorficha
	end:
ret
	
fueratablero:
	mov ebx, [esp+8] ; tama;o del tablero
	mov eax, [esp+4] ; direccion

	cmp eax, 1 ; izq
	je mov_izquierda
;;quede aqui.
	cmp eax, 2 ; up
	je mov_arriba

	cmp eax, 3 ; down
	je mov_abajo

	cmp eax, 4 ; derecha
	je mov_derecha

	mov_izquierda:
		mov edi, [xcor]
		sub edi, 4 ; le quito un dword hacia la izquierda
		cmp edi, 0 ; caso donde no me puedo mover hacia la izquierda
		jl mov_invalido
		mov [xcor], edi
		mov eax, 1
		jmp fin

	mov_arriba:
		mov edi, [ycor]
		cmp ebx, 1 ; 6x6
		je mov_up_6x6 ;;como le digo yo que eso es lo que vale? digaos, que el 1 es 6x6 2 8x8 and so fort
		cmp ebx, 2 ; 8x8
		je mov_up_8x8
		cmp ebx, 3 ;10x10
		je mov_up_10x10
		mov_up_6x6:
			sub edi, 24 ; 6x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_up_8x8:
			sub edi, 32 ; 8x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_up_10x10:
			sub edi, 40 ; 10x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 

	mov_abajo:
		mov edi, [ycor]
		cmp ebx, 1 ; 6x6
		je mov_down_6x6 
		cmp ebx, 2 ; 8x8
		je mov_down_8x8
		cmp ebx, 3 ;10x10
		je mov_down_10x10
		mov_down_6x6:
			add edi, 24 ; 6x4 bytes
			cmp edi, 140 ; si no cambiar por 144
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_down_8x8:
			add edi, 32 ; 8x4 bytes
			cmp edi, 252 ;si no cambiar por 256
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_down_10x10:
			add edi, 40 ; 10x4 bytes
			cmp edi, 396 ; si no cambiar por 400
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 

	mov_derecha:
		mov edi, [xcor]
		add edi, 4
		cmp ebx, 1 ; 6x6
		je mov_right_6x6 
		cmp ebx, 2 ; 8x8
		je mov_right_8x8
		cmp ebx, 3 ;10x10
		je mov_right_10x10
		
		mov_right_6x6: ;;;;;;DUDA
			cmp edi, 0 
			jg mov_invalido
			mov [xcor], edi
			mov eax, 1
			jmp fin

		mov_right_8x8:
			cmp edi, 0 
			jg mov_invalido
			mov [xcor], edi
			mov eax, 1
			jmp fin

		mov_right_10x10:
			cmp edi, 0
			jg mov_invalido
			mov [xcor], edi
			mov eax, 1
			jmp fin
		
	mov_invalido:
		mov eax, 0
	
	fin:
ret

posicionvalida:
	mov eax, 0
	cmp [xcor], eax
;	mov ebx, colorficha
	je acabar
	mov ebx, 3 ; valor arbitrario para comparar
	
	acabar:
ret

ponercentro:
	mov eax, 1 ; ficha roja = 1
	mov [m8+144], eax ; bajo 128 dwords (4 filas) y le sumo para llegar al centro (4,4)
	mov [m8+180], eax ; (5,5)
	mov eax, 2 ; ficha azul = 2
	mov [m8+148], eax ; (4,5)
	mov [m8+176], eax ; (5,4)
ret

juegofinalizado: ; ya no hay mas espacio en el tablero

ret
