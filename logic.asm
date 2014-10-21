; Amanda Sagasti - B36269
; ver unica condicion para poner ficha (haya al menos una del color contrario y una del mismo color al final)
; un solo metodo para moverme en 8 direcciones parametrizando la distancia (vector)

SECTION .data
	global turno_mio
	global turno_oponente
	m8: times 64 dd 0 ; matriz de 8x8
	m6: times 36 dd 0 ; matriz de 6x6
	m10: times 100 dd 0 ; 10x10
	xcor: dd 0 ; coordenada x
	ycor: dd 0 ; coordenada y
	xcoro: dd 0 ; copia de coordenada original x
	ycoro: dd 0 ; copia de coordenada original y
	turno_mio: dd 0
	turno_oponente: dd 0
;	distancia: dd 0 ; vector donde puedo parametrizar la distancia que me voy a mover para cada una de las 8 direcciones
	
SECTION .text
	global ponerficha
	global fueratablero
	global ponercentro8
	
ponerficha:
; Devuelve un 3 si no  es una posicion valida
; Devuelve un 1 si es una posicion valida.

	mov edx, [esp+4] ; le estoy pasando el color.
	mov ecx, [esp+8] ; le estoy pasando el tama;o del tablero

	push ecx
	call posicionvacia ; verifica que se puede poner una ficha en posicion valida (posicion este vacia)
					   ; en eax tiene 0 = vacia o 3 = llena
	pop ecx
	cmp eax, 3 ; no pudo poner ficha
	je devuelve

	; si posicionvacia devuelve 0, puedo poner ficha y llamo a posicionvalida 
	call posicionvalida ; ver si esta a la par de una ficha de distinto color
	cmp eax, 0 ; 0 = no pudo poner ficha 
	je devuelve
	; si pudo poner ficha
	mov eax, 1 ; else mueve a eax un 1

	jmp end

; falta color
;	cmp ebx, 3
;	je end
;	mov [xcor], colorficha

	devuelve:
		mov eax, 3 ; no es una posicion valida

	end:
ret
	
fueratablero:
	mov eax, [esp+4] ; direccion en la que se mueve
	mov ebx, [esp+8] ; tama;o del tablero

	cmp eax, 1 ; izq
	je mov_izquierda

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
		je mov_up_6x6
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
		
		mov_right_6x6: 
			cmp edi, 20
			jg mov_invalido
			mov [xcor], edi
			mov eax, 1
			jmp fin

		mov_right_8x8:
			cmp edi, 28 ; por que 28?
			jg mov_invalido
			mov [xcor], edi
			mov eax, 1
			jmp fin

		mov_right_10x10:
			cmp edi, 36
			jg mov_invalido
			mov [xcor], edi
			mov eax, 1
			jmp fin
		
	mov_invalido:
		mov eax, 0
	
	fin:
ret ; 1  si se puede 0 si no

posicionvacia: ;falta verifica que esta a la par de una ficha
	mov edi, [xcor]
	add edi, [ycor]
	mov eax, 0 ; pos vacia

	cmp ebx, 1 ;tablero 6x6
	je pos_vac_6x6

	cmp ebx, 2 ;tablero 8x8
	je pos_vac_8x8

	cmp ebx, 3 ; tablero 10x10
	je pos_vac_10x10

	pos_vac_6x6:
		mov ecx, [m6+edi]
		cmp ecx, 0
		je acabar
		jmp mov_3

	pos_vac_8x8:
		mov ecx, [m8+edi]
		cmp ecx, 0
		je acabar
		jmp mov_3

	pos_vac_10x10:
		mov ecx, [m10+edi]
		cmp ecx, 0
		je acabar
		jmp mov_3

	cmp eax, edi ; ver si [xcor] es 0 
	je acabar

	mov_3:
		mov eax, 3 ; 3 = hay ficha en ese lugar.

	acabar:
ret

verificar_celda: ; contenido de celda
	mov ecx, [esp+4] ; recupera tama;o
	mov edi, [xcor]
	add edi, [ycor] ; acumulado

	cmp ecx, 1 ; 6x6
	je tablero_N1
	cmp ecx, 2 ; 8x8
	je tablero_N2
	cmp ecx, 3 ; 10x10
	je tablero_N3

	tablero_N1:
		mov edx, [m6+edi]
		jmp contenido
	tablero_N2:
		mov edx, [m8+edi]
		jmp contenido
	tablero_N3:
		mov edx, [m10+edi]

	contenido:
		cmp edx, 0 ;campo vacio
		je vacio
		cmp edx, 1 ; & rojo
		je rojo
		cmp edx, 2 ; & azul
		je azul

	vacio:
		mov ebx, 0
		jmp terminar_verificar
	rojo:
		mov ebx, 1
		jmp terminar_verificar
	azul:
		mov ebx, 2
		jmp terminar_verificar    ;guarda en ebx lo que se haya encontrado en la celda actual, sea un color o un campo vacio

	terminar_verificar:
ret

posicionvalida: 
; DEvuelve un 1 si esta a la par de una ficha
; Devuelve un 0 si no esta a la par de una ficha
; ve si esta a la par de una ficha
; ecx tama;o
	mov edi, [xcor] ; guarda coordenadas originales
	mov [xcoro], edi ;; esto da problema con la primera fila. h0lp pl0x
	mov edi, [ycor]
	mov [ycoro], edi

	push edx ; color

	mov edi, [xcor]
	add edi, [ycor]   
	push edi  ; celda donde quiero poner la ficha (valor acumulado de cuanto me quiero mover en la matriz)
	push ecx ; tama;o

	ver_N:
		call mov_arriba
		cmp eax, 0
		je ver_NE
		call verificar_celda
		; que se salte el primero la primera vez y depues siga
		ver_N_1: ; entra la primera vez
			cmp ebx, [turno_mio] 
			je ver_NE
			jmp ver_N
		ver_N_2:
			cmp ebx, [turno_oponente] ; turno es el color opuesto
			je ver_NE



	ver_NE:
		mov edi, [ycoro]
		mov [ycor], edi ; restaura coordenadas viejas
		call mov_NE
		cmp eax, 0
		je ver_E
		call verificar_celda

		ver_NE_1:
			cmp ebx, [turno_mio] 
			je ver_E
			jmp ver_NE
		ver_NE_2:
			cmp ebx, [turno_oponente]
			je ver_E

	ver_E:
		call mov_derecha
		cmp eax, 0
		je ver_SE
		call verificar_celda

		ver_E_1:
			cmp ebx, [turno_mio]
			je ver_SE
			jmp ver_E
		ver_E_2:
			cmp ebx, [turno_oponente]
			je ver_SE

	ver_SE:
		mov edi, [ycoro]
		mov [ycor], edi ; restaura coordenadas viejas
		call mov_SE
		cmp eax, 0
		je ver_S
		call verificar_celda

		ver_SE_1:
			cmp ebx, [turno_mio]	
			je ver_S
			jmp ver_SE
		ver_SE_2:
			cmp ebx, [turno_oponente]
			je ver_S
	ver_S:
		mov edi, [ycoro]
		mov [ycor], edi
		call mov_abajo
		cmp eax, 0
		je ver_SO
		call verificar_celda

		ver_S_1:
			cmp ebx, [turno_mio]
			je ver_SO
			jmp ver_S
		ver_S_2:
			cmp ebx, [turno_opuesto]
			je ver_SO

	ver_SO:
		mov edi, [ycoro]
		mov [ycor], edi
		call mov_SO
		cmp eax, 0
		je ver_O
		call verificar_celda

		ver_SO_1:
			cmp ebx, [turno_mio]
			je ver_O
			jmp ver_SO
		ver_SO_2:
			cmp ebx, [turno_oponente]
			je ver_O

	ver_O:
		mov edi, [xcoro]
		mov [xcor], edi
		call mov_izquierda
		cmp eax, 0
		je ver_NO
		call verificar_celda

		ver_O_1:
			cmp ebx, [turno_mio]
			je ver_NO
			jmp ver_O
		ver_SO_2:
			cmp ebx, [turno_oponente]
			je ver _NO

	ver_NO:
		mov edi, [ycoro]
		mov [ycor], edi
		call mov_NO
		cmp eax, 0
		je no_ficha
		call verificar_celda 
		ver_NO_1:
			cmp ebx, [turno_mio]
;;?????????????????????????????????????????????????

;	pops:
;		pop ecx 
;		pop edi 
;		pop edx 

	poner_ficha: ; pone la ficha.
		pop ecx 
		pop edi 
		pop edx 
		cmp ecx, 1
		je poner6

		cmp ecx, 2
		je poner8

		cmp ecx, 3
		je poner8

		poner6:
			mov [m6+edi], edx
			jmp devolver_valor

		poner8:
			cmp edx, 1 ; ficha roja
			je poner_azul_8x8

			mov [m8+edi], dword 2 ;ficha azul
			jmp fin_8x8
			poner_azul_8x8:
				cmp ebx, 1
				je poner_la_ficha_azul_8x8
				; si se encuentra una del mismo color, devuelvase a seguir buscando
				; pasarle "valor" de direccion por pila, hacer 8 compares para devolverme a la direccion siguiente
				push edx
				push edi
				push ecx
				jmp mover_0
				poner_la_ficha_azul_8x8:
					mov [m8+edi], dword 1
					jmp fin_8x8
	
			poner_rojo_8x8:
				cmp ebx, 2
				je poner_la_ficha_roja_8x8
				; si se encuentra una del mismo color, devuelvase a seguir buscando
				; pasarle "valor" de direccion por pila, hacer 8 compares para devolverme a la direccion siguiente
				push edx
				push edi
				push ecx
				jmp mover_0
				poner_la_ficha_roja_8x8:
					mov [m8+edi], dword 2
					jmp fin_8x8							

			fin_8x8:
				jmp devolver_valor
	
		poner10:
			mov [m10+edi], edx

	devolver_valor:
		mov eax, 1 ; si pudo poner ficha
		jmp finalizar_validar
	
	no_ficha: ; aqui hay error
		pop ecx 
		pop edi 
		pop edx 
		mov eax, 0 ; no pudo poner ficha

	mover_0:
		mov eax, 0

	finalizar_validar:
ret


; moverse por diagonales
	mov_NO:
		mov edi, [ycor]
		cmp ebx, 1 ; 6x6
		je mov_NO_6x6 
		cmp ebx, 2 ; 8x8
		je mov_NO_8x8
		cmp ebx, 3 ;10x10
		je mov_NO_10x10
		mov_NO_6x6:
			sub edi, 20 ; 6x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_NO_8x8:
			sub edi, 28 ; 8x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_NO_10x10:
			sub edi, 36 ; 10x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
ret

	mov_NE:
		mov edi, [ycor]
		cmp ebx, 1 ; 6x6
		je mov_NE_6x6 
		cmp ebx, 2 ; 8x8
		je mov_NE_8x8
		cmp ebx, 3 ;10x10
		je mov_NE_10x10
		mov_NE_6x6:
			sub edi, 20 ; 6x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_NE_8x8:
			sub edi, 28 ; 8x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_NE_10x10:
			sub edi, 36 ; 10x4 bytes
			cmp edi, 0
			jl mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
ret

	mov_SE:
		mov edi, [ycor]
		cmp ebx, 1 ; 6x6
		je mov_SE_6x6 
		cmp ebx, 2 ; 8x8
		je mov_SE_8x8
		cmp ebx, 3 ;10x10
		je mov_SE_10x10
		mov_SE_6x6:
			add edi, 28 ; 6x4 bytes
			cmp edi, 140 ; si no cambiar por 144
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_SE_8x8:
			add edi, 36 ; 8x4 bytes
			cmp edi, 252 ;si no cambiar por 256
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_SE_10x10:
			add edi, 44 ; 10x4 bytes
			cmp edi, 396 ; si no cambiar por 400
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
ret

	mov_SO:
		mov edi, [ycor]
		cmp ebx, 1 ; 6x6
		je mov_SO_6x6 
		cmp ebx, 2 ; 8x8
		je mov_SO_8x8
		cmp ebx, 3 ;10x10
		je mov_SO_10x10
		mov_SO_6x6:
			add edi, 20 ; 6x4 bytes
			cmp edi, 140 ; si no cambiar por 144
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_SO_8x8:
			add edi, 28 ; 8x4 bytes
			cmp edi, 252 ;si no cambiar por 256
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
		mov_SO_10x10:
			add edi, 36 ; 10x4 bytes
			cmp edi, 396 ; si no cambiar por 400
			jg mov_invalido
			mov [ycor], edi
			mov eax, 1 ; recibe resultado
			jmp fin 
ret

ponercentro8: ; falta poner centro 6x6 y 10x10
	mov eax, 1 ; ficha roja = 1
	mov [m8+108], eax ; (4,4)
	mov [m8+144], eax ; (5,5)
	mov eax, 2 ; ficha azul = 2
	mov [m8+112], eax ; (4,5)
	mov [m8+140], eax ; (5,4)
ret

ponercentro6:
	mov eax, 1 ; ficha roja = 1
	mov [m6+312], eax ; (3,3) / m6 + m8 (64*4) + (15-1)*4
	mov [m6+340], eax ; (4,4)

	mov eax, 2 ; ficha azul = 2
; (3,4)
; (4,3)

ponercentro10:
	mov eax, 1 ; ficha roja = 1
; (5,5) / m10 + m6 (36*4) + m8 (64*4) + campos bajados
; (6,6)

	mov eax, 2 ; ficha azul = 2
; (5,6)
; (6,5)

juegofinalizado: ; ya no hay mas espacio en el tablero

	bye_6x6:
	bye_8x8:
	bye_10x10:

ret
