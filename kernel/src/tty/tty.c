/* 
    Copyright (C) 2024 WIX Kernel
    Authored by Will Klees
    tty.c - ANSI TTY interface to bootvid
*/

#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <tty/bootvid.h> 
#include <init/init.h>

#define AWAITING_ESC 0
#define AWAITING_BRACKET 1
#define AWAITING_ARG 2
#define AWAITING_CMD 3

int cur_mode = AWAITING_ESC;
int ansi_args[8];
int n_args = 0;
int started_arg = 0;

char ansi_to_vga[] = {0, 4, 2, 14, 1, 5, 3, 15, 0, 15};

void do_graphics_cmd(int arg){
    //dbg_printf("Graphics command %x\n", arg);

    if (arg >= 40){
        bootvid_bg(ansi_to_vga[arg - 40]);
    } else if (arg >= 30){
        bootvid_fg(ansi_to_vga[arg - 30]);
    }
}

void do_erase(int arg){
    int start, end;
    //dbg_printf("Erase command %x\n", arg);
    
    switch(arg){
        case 0:
            start = bootvid_cursor;
            end = 2000;
            break;
        case 1:
            start = 0;
            end = bootvid_cursor;
            break;
        case 2:
            start = 0;
            end = 2000;
            break;
        default:
            printk("Unknown erase command %x\n", arg);
            break;
    }

    bootvid_fill(start, end);
}

void do_ansi_cmd(int ch){
    int i;
    int arg1, arg2;

    switch(ch){
        case 'A':
            bootvid_gotoxy(bootvid_getx(), bootvid_gety() - ansi_args[0]);
            break;
        
        case 'B':
            bootvid_gotoxy(bootvid_getx(), bootvid_gety() + ansi_args[0]);
            break;

        case 'C':
            bootvid_gotoxy(bootvid_getx() + ansi_args[0], bootvid_gety());
            break;

        case 'D':
            bootvid_gotoxy(bootvid_getx() - ansi_args[0], bootvid_gety());
            break;

        case 'E':
            break;

        case 'F':
            break;
        
        case 'G':
            bootvid_gotoxy(ansi_args[0], bootvid_gety());
            break;

        case 'H':
            if (n_args > 1){
                arg1 = (ansi_args[0] == -1) ? bootvid_getx() : ansi_args[0];
                arg2 = (ansi_args[1] == -1) ? bootvid_gety() : ansi_args[1];
            } else if (n_args == 1){
                arg1 = ansi_args[0];
                arg2 = bootvid_gety();
            } else {
                arg1 = 0;
                arg2 = 0;
            }
            //dbg_printf("Cursor movement to %x, %x\n", arg1, arg2);
            bootvid_gotoxy(arg1, arg2);
            break;
        case 'm': // color/graphics
            for(i = 0; i < n_args; i++){
                do_graphics_cmd(ansi_args[i]);
            }
            break;
        case 'J':
            if(n_args == 0){
                i = 0;
            } else{
                i = ansi_args[0];
            }
            do_erase(i);
            break;
        default:
            printk("HELP %c\nn_args=%x args[0]=%x args[1]=%x\n", ch, n_args, ansi_args[0], ansi_args[1]);
            break;
    }    
}

void proc_char(int ch){
    //dbg_printf("ch=%c Mode=%x\n", ch, cur_mode);

    switch(cur_mode){
        case AWAITING_ESC:
            if (ch == 0x1B){
                cur_mode = AWAITING_BRACKET;
            } else {
                bootvid_putch(ch);
            }
            break;
        case AWAITING_BRACKET:
            if (ch == '['){
                cur_mode = AWAITING_ARG;
            } else {
                bootvid_putch(ch);
                cur_mode = AWAITING_ESC;
            }
            break;
        case AWAITING_ARG:
            if (ch == ';') { // next arg
                if(!started_arg) ansi_args[n_args] = -1;

                n_args++;
                started_arg = 0;
            }

            if (isdigit(ch)){
                ansi_args[n_args] = 10 * ansi_args[n_args] + (ch - 48);
                started_arg = 1;
            }

            if (isalpha(ch)){
                if (started_arg){
                    n_args++;
                }
                goto do_command;
            }

            break;

        do_command:
        case AWAITING_CMD:
            do_ansi_cmd(ch);
            cur_mode = AWAITING_ESC;
            started_arg = 0;
            n_args = 0;
            memset(ansi_args, 0, sizeof(ansi_args));
            break;
    }
}

void tty_write(const void* buf, size_t count){
    const char* str = buf;

    while(count--){
        proc_char(*str++);
    }
}

void tty_init(){
    bootvid_init();
}
