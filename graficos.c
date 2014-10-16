// Amanda Sagasti - B36269
#include <ncurses.h>
#include <stdlib.h>

extern int ponerficha(int color, int tam);
extern int fueratablero(int dir, int tam);
extern void ponercentro6();
extern void ponercentro8();
extern void ponercentro10();

int x = 0; // coordenada x
int y = 1; // coordenada y
int dir; // habla con ensambla para ver tecla presionada
int tam; // el tama;o del tablero
int color = 1; //siempre inicia jugador 1 rojo
bool cambio = true; //cambio de color de las fichas
int lugarvalido = 0; //dice si es un lugar valido o no

void tamano(){
	tam = getch(); // tam deberia ir declarado afuera? 
	switch(tam){
		case '1': // 6x6
			printw("6x6 seleccionado \n");
			tam = 1;
			//ponercentro6();
			tablero6();
			break;
		case '2': // 8x8
			printw("8x8 seleccionado \n");
			tam = 2; 
			ponercentro8(); //to do: pasar tam por parametro para todos los casos
			tablero8();
			break;
		case '3': // 10x10
			printw("10x10 seleccionado \n");
			tam = 3;
			//ponercentro10();
			tablero10();
			break;
		case 27: // ESC
			endwin();
			exit(0);
		case KEY_F(1): // no funciona en mi maquina virtual, pero la idea esta
			printw("Escoja una letra entre a y d para el tablero. \n");
		default:
			printw("Seleccione un tamaño válido. \n");
			tamano();
	}
	refresh();
	
}

void tablero6(){ //tablero de 6x6
	int i = 0;
	clear();

	while(i != 6){
		printw("[ ][ ][ ][ ][ ][ ]\n");
		i++;
	}
	printw("Cantidad de fichas restantes:\n"); // estadísticas
	printw("Jugador 1: \n");
	printw("Jugador 2: \n");
	attron(COLOR_PAIR(1));	 // colocar fichas rojas
	mvaddch(2, 7, '&'); // (4,4)
	mvaddch(3, 10, '&'); // (5,5)

	attron(COLOR_PAIR(2));  // colorcar fichas azules
	mvaddch(2, 10, '&'); // (4,5)
	mvaddch(3, 7, '&'); // (5,4)

	attron(COLOR_PAIR(1));

	move(0, 1); // cursor en primera casilla 

}

void tablero8(){

	int i = 0;
	clear();

	while(i != 8){
		printw("[ ][ ][ ][ ][ ][ ][ ][ ]\n");
		i++;
	}
	printw("Cantidad de fichas restantes:\n"); // estadísticas: depende del tamaño del tablero
	printw("Jugador 1: \n");
	printw("Jugador 2: \n");
	attron(COLOR_PAIR(1));	 // colocar fichas rojas
	mvaddch(3, 10, '&'); // (4,4)
	mvaddch(4, 13, '&'); // (5,5)

	attron(COLOR_PAIR(2));  // colorcar fichas azules
	mvaddch(3, 13, '&'); // (4,5)
	mvaddch(4, 10, '&'); // (5,4)

	attron(COLOR_PAIR(1));

	move(0, 1); // cursor en primera casilla 
}

void tablero10(){
	int i = 0;
	clear();

	while(i != 10){
		printw("[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]\n");
		i++;
	}
	printw("Cantidad de fichas restantes:\n");
	printw("Jugador 1: \n");
	printw("Jugador 2: \n");
	attron(COLOR_PAIR(1));	 //rojas
	mvaddch(4, 13, '&'); // (4,4)
	mvaddch(5, 16, '&'); // (5,5)

	attron(COLOR_PAIR(2));  //azules
	mvaddch(4, 16, '&'); // (4,5)
	mvaddch(5, 13, '&'); // (5,4)

	attron(COLOR_PAIR(1));

	move(0, 1); // cursor en primera casilla 
}

void cambiarcolor(){
	if (cambio == true) {
		color = 1;
	}
	else {
		color = 2;
	}
}


void jugar() { // mover cursor 
	int cursor = getch(); // lee donde esta el cursor
	int mov;

	switch(cursor){
		case 10: //enter. poner ficha

			lugarvalido = ponerficha(color, tam);
			printw("%i", lugarvalido);
/*
			if (lugarvalido == 1 || lugarvalido == 2) {
			
				if (cambio == true ){ //cambia entre dos jugadores
					cambio = false;
					cambiarcolor();
					attron(COLOR_PAIR(color));
				}	
				else {
					cambio = true;
					cambiarcolor();
					attron(COLOR_PAIR(color));
				}

				mvaddch(x, y, '&');

			}
			else{
				//printw("Movimiento inválido\n");
			}
*/
			break;

		case KEY_LEFT:
			dir = 1; 
			mov = fueratablero(dir, tam);
			if (mov == 1) {
				y = y-3; 
				move(x, y); 
			}
			break;

		case KEY_UP:
			dir = 2;
			mov = fueratablero(dir, tam);
			if (mov == 1) {
				x = x-1 ;
				move(x, y);
			}
			break;

		case KEY_DOWN:
			dir = 3; 
			mov = fueratablero(dir, tam);
			if (mov == 1) {
				x = x+1 ;
				move(x, y);
			}
			break;

		case KEY_RIGHT:
			dir = 4; 
			mov = fueratablero(dir, tam);
			if (mov == 1) {
				y = y+3 ; 
				move(x, y);
			}
			break;

		case KEY_F(1): //ayuda
			clear(); // como me devuelvo a la pantalla anterior?
			printw("Flechas direccionales: mueve cursor\n");
			printw("enter: pone ficha\n");
			printw("F2: reiniciar\n");
			break;
		case KEY_F(2): //reiniciar
			break;
//		case KEY_F(8): //cambiar el color
//			break;
		case KEY_F(10): //revertir
			break;

	} 
	
}

void inicio(){ // Menú del juego
	printw("0thell0 \n");
	printw("v 0.0 \n");
	printw("Amanda Sagasti - B36269 \n");
	printw("\n");
	printw("Seleccione el tamaño del tablero. Presione la letra correspondiente. \n");
	printw("(1) 6x6 \n");
	printw("(2) 8x8 \n");
	printw("(3) 10x10 \n");
	printw("\n");
	printw("Salir (ESC) \n");
	printw("Ayuda (F1) \n");
	tamano();
	refresh();

}

int main() {
	initscr(); // Inicializar
	noecho();
	keypad(stdscr, TRUE); //F keys	
	start_color();
	init_pair(1,COLOR_RED, COLOR_BLACK); // fichas rojas
	init_pair(2,COLOR_BLUE, COLOR_BLACK); // fichas azules

	inicio();
//to do: mover el cursor, ligar con .asm

	while(true){jugar(); }//hace UNA jugada
	getch();
	endwin();

	return 0;
}
