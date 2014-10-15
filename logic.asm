; Amanda Sagasti - B36269

SECTION .data
	global colorficha
	m8: times 64 dd 0 ; matriz de 8x8
	m6: times 36 dd 0 ; matriz de 6x6
	m10: times 100 dd 0 ; 10x10
	xcor: dd 0 ; coordenada x
	ycor: dd 0 ; coordenada y
	xcoro: dd 0
	ycoro: dd 0 
	
SECTION .text
	global ponerficha
	global fueratablero
	global ponercentro8
	
ponerficha:
	mov edx, [esp+4] ; le estoy pasando el color.
	mov ebx, [esp+8] ; le estoy pasando el tama;o del tablero
	call posicionvacia ; verifica que se puede poner una ficha en posicion valida (posicion este vacia)
					   ; en eax tiene 0 = vacia o 3 = llena
	cmp eax, 3
	je devuelve

	; si es 0 pone ficha POS VALIDA ES EL PROBLEMA. fijo estoy sumando mal, entonces tengo que poner suma de x y y en EDI. y moverme eso.
	call posicionvalida ; ver si esta a la par de una ficha de distinto color

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
		
		mov_right_6x6: 
			cmp edi, 20
			jg mov_invalido
			mov [xcor], edi
			mov eax, 1
			jmp fin

		mov_right_8x8:
			cmp edi, 28
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

; a partir de aqui hay que hacer casos por tablero. ver verificar_celda de flow2.asm (coordenada total)
	cmp ebx, 1 ;tablerp 6x6
	je pos_vac_6x6

	cmp ebx, 2 ;tablero 8x8
	je pos_vac_8x8

	cmp ebx, 3 ; tablero 10x10
	je pos_vac_10x10

	pos_vac_6x6:

	pos_vac_8x8:
		mov ecx, [m8+edi]
		cmp ecx, 0
		je acabar
		; nigga fuck your tea
		jmp mov_3

	pos_vac_10x10:

	cmp eax, edi ; ver si [xcor] es 0 
	je acabar

	mov_3:
	mov eax, 3 ; 3 = hay ficha en ese lugar.

	acabar:
ret

posicionvalida: ;parametro: color ficha
;ecx tama;o
	mov esi, [xcor]
	mov [xcoro], esi ; si no aqui [esi]

	mov esi, [ycor]
	mov [ycoro], esi


	cmp edx, 1 ; es rojo
	je jugador1
	cmp edx, 2 ; es azul
	je jugador2

	jugador1: ; si en alugno de sus 8 neighbors es azul, devluevle que puede
		push eax ;;FUCK POPPEAR A REGISTROS. YO QUIERO POPPEAR A YCOR. 
		mov eax, [ycor] ; si no funca, es mov eax, ycor sin []
		push eax
		ver_N1: 
			call mov_arriba ; ver si no esta fuera del tablero
			cmp eax, 0
			je ver_NE1
			mov esi, 1 ; 1 = Norte
			mov eax, [ycor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarN1:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, [ycor]
		push eax
		ver_NE1:
			call mov_NE
			cmp eax, 0
			je ver_E1
			mov esi, 2 ; 2 = NE
			mov eax, [ycor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarNE1:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, [xcor]
		push eax
		ver_E1:
			call mov_derecha
			cmp eax, 0
			je ver_SE1
			mov esi, 3 ; 3 = Este
			mov eax, [xcor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarE1:
			pop eax
			mov [xcor], eax
			pop eax

		push eax
		mov eax, [ycor] ; poner corchetes en todas y seguir compilando. 
		push eax
		ver_SE1:
			call mov_SE
			cmp eax, 0
			je ver_S1
			mov esi, 4 ; 4 = SE
			mov eax, [ycor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarSE1:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, [ycor]
		push eax
		ver_S1:
			call mov_abajo
			cmp eax, 0
			je ver_SO1
			mov esi, 5 ; 5 = Sur
			mov eax, [ycor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarS1:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, ycor
		push eax
		ver_SO1:
			call mov_SO
			cmp eax, 0
			je ver_O1
			mov esi, 6 ; 6 = SO
			mov eax, [ycor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarSO1:
			pop eax
			mov [ycor], eax
			pop eax
			

		push eax
		mov eax, [xcor]
		push eax
		ver_O1:
			call mov_izquierda
			cmp eax, 0
			je ver_NO1
			mov esi, 7 ; 7 = Oeste
			mov eax, [xcor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarO1:
			pop eax
			mov [xcor], eax
			pop eax

		push eax
		mov eax, [ycor]
		push eax
		ver_NO1:
			call mov_NE
			cmp eax, 0
			je adios ; a que salta
			mov esi, 8 ; 8 = NO
			mov eax, [ycor]
			cmp [eax], dword 2 ; dice si es azul
			je buscarcierre1
			regresarNO1:
			pop eax
			mov [xcor], eax
			pop eax


		buscarcierre1: ; que no se encuentre un 0 o se salga del tablero
;se encuentre una fucha del misco color que uno esta pieniendo. 

			cmp esi, 1
			je buscar_N1
			cmp esi, 2
			je buscar_NE1
			cmp esi, 3
			je buscar_E1
			cmp esi, 4
			je buscar_SE1
			cmp esi, 5
			je buscar_S1
			cmp esi, 6
			je buscar_SO1
			cmp esi, 7
			je buscar_O1
			cmp esi, 8
			je buscar_NO1

			buscar_N1:
				call mov_arriba
				cmp eax, 0
				je regresarN1
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarN1
				jmp buscar_N1

			buscar_NE1:
				call mov_NE
				cmp eax, 0
				je regresarNE1
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarNE1
				jmp buscar_NE1

			buscar_S1:
				call mov_abajo
				cmp eax, 0
				je regresarS1
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarS1
				jmp buscar_S1

			buscar_E1:
				call mov_derecha
				cmp eax, 0
				je regresarE1
				mov eax, [xcor]
				cmp edx, eax
				je ubicarfichax
				cmp eax, 0
				je regresarE1
				jmp buscar_E1

			buscar_O1:
				call mov_izquierda
				cmp eax, 0
				je regresarO1
				mov eax, [xcor]
				cmp edx, eax
				je ubicarfichax
				cmp eax, 0
				je regresarO1
				jmp buscar_O1

			buscar_SE1:
				call mov_SE
				cmp eax, 0
				je regresarSE1
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarSE1
				jmp buscar_SE1

			buscar_SO1:
				call mov_SO
				cmp eax, 0
				je regresarSO1
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarSO1
				jmp buscar_SO1

			buscar_NO1:
				call mov_NO
				cmp eax, 0
				je regresarNO1
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarNO1
				jmp buscar_NO1

	jugador2: ; si alguno de sus 8 neighbors es rojo, puede poner
		
; sadddddddddddddddddddddd

		push eax
		mov eax, [ycor]
		push eax 
		ver_N2: 
			call mov_arriba ; ver si no esta fuera del tablero
			cmp eax, 0
			je ver_NE2
			mov esi, 1 ; 1 = Norte
			mov eax, [ycor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarN2:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, [ycor]
		push eax
		ver_NE2:
			call mov_NE
			cmp eax, 0
			je ver_E2
			mov esi, 2 ; 2 = NE
			mov eax, [ycor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarNE2:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, [xcor]
		push eax
		ver_E2:
			call mov_derecha
			cmp eax, 0
			je ver_SE2
			mov esi, 3 ; 3 = Este
			mov eax, [xcor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarE2:
			pop eax
			mov [xcor], eax
			pop eax

		push eax
		mov eax, [ycor]
		push eax
		ver_SE2:
			call mov_SE
			cmp eax, 0
			je ver_S2
			mov esi, 4 ; 4 = SE
			mov eax, [ycor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarSE2:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, [xcor]
		push eax
		ver_S2:
			call mov_abajo
			cmp eax, 0
			je ver_SO2
			mov esi, 5 ; 5 = Sur
			mov eax, [xcor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarS2:
			pop eax
			mov [xcor], eax
			pop eax

		push eax
		mov eax, [ycor]
		push eax
		ver_SO2:
			call mov_SO
			cmp eax, 0
			je ver_O2
			mov esi, 6 ; 6 = SO
			mov eax, [ycor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarSO2:
			pop eax
			mov [ycor], eax
			pop eax

		push eax
		mov eax, [xcor]
		push eax
		ver_O2:
			call mov_izquierda
			cmp eax, 0
			je ver_NO2
			mov esi, 7 ; 7 = Oeste
			mov eax, [xcor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarO2:
			pop eax
			mov [xcor], eax
			pop eax

		push eax
		mov eax, [ycor]
		push eax
		ver_NO2:
			call mov_NE
			cmp eax, 0
			je adios ; a que salta
			mov esi, 8 ; 8 = NO
			mov eax, [ycor]
			cmp [eax], dword 1 ; dice si es rojo
			je buscarcierre2
			regresarNO2:
			pop eax
			mov [ycor], eax
			pop eax


		buscarcierre2: ; que no se encuentre un 0 o se salga del tablero
;se encuentre una fucha del misco color que uno esta pieniendo. 

			cmp esi, 1
			je buscar_N2
			cmp esi, 2
			je buscar_NE2
			cmp esi, 3
			je buscar_E2
			cmp esi, 4
			je buscar_SE2
			cmp esi, 5
			je buscar_S2
			cmp esi, 6
			je buscar_SO2
			cmp esi, 7
			je buscar_O2
			cmp esi, 8
			je buscar_NO2

			buscar_N2: ; cambia algo para jugador 2?
				call mov_arriba
				cmp eax, 0
				je regresarN2
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarN2
				jmp buscar_N2

			buscar_NE2:
				call mov_NE
				cmp eax, 0
				je regresarNE2
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarNE2
				jmp buscar_NE2

			buscar_S2:
				call mov_abajo
				cmp eax, 0
				je regresarS2
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarS2
				jmp buscar_S2

			buscar_E2:
				call mov_derecha
				cmp eax, 0
				je regresarE2
				mov eax, [xcor]
				cmp edx, eax
				je ubicarfichax
				cmp eax, 0
				je regresarE2
				jmp buscar_E2

			buscar_O2:
				call mov_izquierda
				cmp eax, 0
				je regresarO2
				mov eax, [xcor]
				cmp edx, eax
				je ubicarfichax
				cmp eax, 0
				je regresarO2
				jmp buscar_O2

			buscar_SE2:
				call mov_SE
				cmp eax, 0
				je regresarSE2
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarSE2
				jmp buscar_SE2

			buscar_SO2:
				call mov_SO
				cmp eax, 0
				je regresarSO2
				mov eax, [ycor]
				cmp edx, eax
				je ubicarfichay
				cmp eax, 0
				je regresarSO2
				jmp buscar_SO2

			buscar_NO2:
				call mov_NO
				cmp eax, 0
				je regresarNO2
				mov eax, [ycor]
				cmp edx, eax
				mov eax, [ycor] ; ???
				push eax ; para match pop de ubicarficha
				je ubicarfichay
				cmp eax, 0
				je regresarNO2
				jmp buscar_NO2

	ubicarfichax:
		; mover en la matriz que corresponde el color de la ficha en esa coordenada //era un pop xcor

		

		cmp ebx, 1 ; 6x6
		je odio1
		cmp ebx, 2 ;8x8
		je las1
		cmp ebx, 3 ;10x10
		je etiquetas1

		odio1:
			mov edi, [xcoro]
			mov [m6+edi], edx ; mov [m6+xcor], edx
			jmp adios

		las1:
			mov edi, [xcoro]
			mov [m8+edi], edx
			jmp adios

		etiquetas1:
			mov edi, [xcoro]
			mov [m10+edi], edx
			jmp adios

	ubicarfichay:
;		pop eax ; mover en la matriz que corresponde el color de la ficha en esa coordenada // pop ycor

		cmp ebx, 1 ; 6x6
		je odio
		cmp ebx, 2 ;8x8
		je las
		cmp ebx, 3 ;10x10
		je etiquetas

		odio:
			mov edi, [ycoro]
			mov [m6+edi], edx
			jmp adios

		las:
			mov edi, [ycoro]
			mov [m8+edi], edx 
			jmp adios
	
		etiquetas:
			mov edi, [ycoro]
			mov [m10+edi], edx
			jmp adios
		
	adios:

ret

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
	mov [m8+108], eax ; bajo 128 dwords (4 filas) y le sumo para llegar al centro (4,4)
	mov [m8+144], eax ; (5,5)
	mov eax, 2 ; ficha azul = 2
	mov [m8+112], eax ; (4,5)
	mov [m8+140], eax ; (5,4)
ret

ponercentro6:
	mov eax, 1 ; ficha roja = 1


	mov eax, 2 ; ficha azul = 2

ponercentro10:
	mov eax, 1 ; ficha roja = 1


	mov eax, 2 ; ficha azul = 2

juegofinalizado: ; ya no hay mas espacio en el tablero

	fin_6x6:
	fin_8x8:
	fin_10x10:

ret
