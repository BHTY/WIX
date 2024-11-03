#include <stdarg.h>
#include <stdint.h>
#include <stddef.h>

uint32_t ilog(uint32_t num, uint32_t base){
    uint32_t t = 0;

    while(num >= 1){
        num /= base;
        t++;
    }

    return t;
}

int32_t ipow(uint32_t base, uint32_t power){
    int32_t t = 1;

    while(power > 0){
        power--;
        t *= base;
    }

    return t;
}

char hexch(uint8_t num){ //for a number between 0 and 15, get the hex digit 0-f
    if(num < 10){
        return (char)(num + 48);
    }
    return (char)(num + 55);
}

int32_t numtostr(uint8_t *str, int num, int base, int sign){ //0=unsigned, 1=signed
	uint32_t i;
	
	if (sign && (num < 0)){
		str[0] = '-';
		i = 1;
		num = ~num + 1;
	}
	else{
		i = 0;
	}

	uint32_t places = ilog(num, base);

	while (places > 1){
		uint32_t temp = ipow(base, places - 1);
		uint32_t tmp = (num - (num % temp));
		str[i] = hexch(tmp / temp);
		num -= tmp;

		places--;
		i++;
	}

	str[i] = hexch(num);
	str[i + 1] = 0;

	return i + 1;
}

int vsprintf(char* buf, const char* fmt, va_list args){
    char *str;
	uint16_t i;
	uint16_t len;
	char *s;

	for (str = buf; *fmt; ++fmt){

		if (*fmt != '%'){
			*str++ = *fmt;
			continue;
		}

		fmt++;

		switch (*fmt){
			case 'c':
				*str++ = (char)va_arg(args, int);
				break;
			case 's':
				s = va_arg(args, char*);
				len = strlen(s);
				for (i = 0; i < len; ++i) *str++ = *s++;
				break;
			case 'o':
				break;
			case 'x':
				str += numtostr(str, va_arg(args, unsigned int), 16, 0);
				break;
			case 'X':
				str += numtostr(str, va_arg(args, int), 16, 1);
				break;
			case 'p':
				str += numtostr(str, (int)(va_arg(args, void*)), 16, 0);
				break;
			case 'd':
			case 'i':
				str += numtostr(str, va_arg(args, int), 10, 1);
				break;
			case 'u':
				str += numtostr(str, va_arg(args, unsigned int), 10, 0);
				break;
			case 'b':
				str += numtostr(str, va_arg(args, unsigned int), 2, 0);
				break;
			case 'B':
				str += numtostr(str, va_arg(args, unsigned int), 2, 1);
				break;
			default:
                *str++ = '%';
				break;
		}

	}

	*str = 0;

	return str - buf;
}

int sprintf(char* str, const char* format, ...){
    va_list args;
    int size;

    va_start(args, format);
    size = vsprintf(str, format, args);
    va_end(args);

    return size;
}