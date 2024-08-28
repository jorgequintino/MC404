#define STDIN_FD  0
#define STDOUT_FD 1

int read(int __fd, const void *__buf, int __n){
    int ret_val;
    __asm__ __volatile__(
      "mv a0, %1           # file descriptor\n"
      "mv a1, %2           # buffer \n"
      "mv a2, %3           # size \n"
      "li a7, 63           # syscall write code (63) \n"
      "ecall               # invoke syscall \n"
      "mv %0, a0           # move return value to ret_val\n"
      : "=r"(ret_val)  // Output list
      : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
      : "a0", "a1", "a2", "a7"
    );
    return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
    __asm__ __volatile__(
      "mv a0, %0           # file descriptor\n"
      "mv a1, %1           # buffer \n"
      "mv a2, %2           # size \n"
      "li a7, 64           # syscall write (64) \n"
      "ecall"
      :   // Output list
      :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
      : "a0", "a1", "a2", "a7"
    );
}

void exit(int code)
{
    __asm__ __volatile__(
      "mv a0, %0           # return code\n"
      "li a7, 93           # syscall exit (64) \n"
      "ecall"
      :   // Output list
      :"r"(code)    // Input list
      : "a0", "a7"
    );
}

/* This function sets the power for a given base.
ARG
    int exponential
    int base
RETURN
    base**exp
*/
int power(int exp, int base){
    int ans = 1;
    if (exp == 0)
        return 1;
    for(int i=0;i<exp;i++){
        ans *= base;
    }
    return ans;
}

/* This function inverts a string by swapping char from beggining to the ones in the end.
ARG
    int size
    char* string
RETURN
    none
*/
void invertstring(int size, char *string){
    int first = 0;
    int last = size;
    char temp;
    while(first<last){
        temp=string[first];
        string[first]=string[last];
        string[last]=temp;
        first++;
        last--;
    }
}

/* This function turns a array of chars in a haxadecimal representation to its numeric value.
ARG
    char str[]
    int isnegative
    int size
RETURN
    unsigned int number
*/
unsigned hexatonumeric(char str[], int isnegative, int size){
    unsigned number = 0;
    for(int i=2;i < size;i++){
        //potencia
        if(str[i]>='a'){
            number += (str[i] - 'W') * power(size - i - 1, 16);
        }else{
            number += (str[i] - '0') * power(size - i - 1, 16);
        }
    }
    if(isnegative==1){
        if(number> power(31,2)){
            number = ~number;
            number+=1;
        }
    }
    return number;
}

/* This function turns a numeric value into a array of chars in a decimal representation.
ARG
    unsigned number
    int isnegative
    char decimal[]
RETURN
    int size[of array]
*/
int numerictodec(unsigned number, int isnegative, char decimal[]){
    int q =1;
    int i =1;
    if (isnegative == 0){
        decimal[0] = '\n';
        while (q !=0){
            decimal[i] = '0' + (number%10);
            number = number / 10;
            q = number;
            i++;
        }
        invertstring(i-1, decimal);
        return i-1;
    } else{
        if(number>= power(31,2)){
            number = ~number;
            number+=1;
        }
        decimal[0] = '\n';
        while (q !=0){
            decimal[i] = '0' + (number%10);
            number = number / 10;
            q = number;
            i++;
        }
        decimal[i] = '-';
        invertstring(i, decimal);
        return i;
    }
}

/* This function turns a numeric value into a array of chars in a hexadecimal representation.
ARG
    unsigned number
    int isnegative
    char hexadecimal[]
RETURN
    int size[of array]
*/
int numerictohexa(unsigned number, int isnegative, char hexadecimal[]){
    int q =1;
    int i =1;
    if (isnegative == 0){
        hexadecimal[0] = '\n';
        while (q !=0){
            if(number%16<10){
                hexadecimal[i] = '0' + (number%16);
            }else{
                hexadecimal[i] = 'W' + (number%16);
            }
            number = number / 16;
            q = number;
            i++;
        }
        hexadecimal[i] = 'x';
        hexadecimal[i+1] = '0';
        invertstring(i+1, hexadecimal);
        return i+1;
    } else{
        if(number> power(31,2)){
            number+=1;
            number = ~number;
        } else{
            number = ~number;
            number+=1;
        }
        return numerictohexa(number, 0, hexadecimal);
    }
}

/* This function turns a numeric value into a array of chars in a binary representation.
ARG
    unsigned number
    int isnegative
    char binary[]
RETURN
    int size[of array]
*/
int numerictobi(unsigned number, int isnegative, char binary[]){
    int q =1;
    int i =1;
    if (isnegative==0){
        binary[0] = '\n';
        while (q !=0){
            binary[i] = '0' + (number%2);
            number = number / 2;
            q = number;
            i++;
        }
        binary[i] = 'b';
        binary[i+1] = '0';
        invertstring(i+1, binary);
        return i+1;
    } else{
        if(number> power(31,2)){
            number+=1;
            number = ~number;
        } else{
            number = ~number;
            number+=1;
        }
        return numerictobi(number, 0, binary);
    }
}

/* This function swapps the endian of a array of char in a hexadecimal representation.
ARG
    char string[]
    char inverted[]
    int size
RETURN
    none
*/
void invertendian(char string[], char inverted[], int size){
    inverted[0] = '0';
    inverted[1] = 'x';
    int p = 1;
    if (size<11){
        //makes sure has all 8 digits.
        for(int k=size-1;k>1;k--){
            inverted[10-p] = string[k];
            p++;
        }

        for(int j=2;j<10-size+2;j++){
            inverted[j]='0';
        }
    } else{
        for(int f=2; f<10;f++){
            inverted[f]=string[f];
        }
    }
    int first = 2;
    int last = 9;
    char temp1, temp2;
    while(first<last){
        //it swaps two chars at a time
        temp1=inverted[first];
        temp2=inverted[first+1];
        inverted[first]=inverted[last-1];
        inverted[first+1]=inverted[last];
        inverted[last-1]=temp1;
        inverted[last]=temp2;
        first+=2;
        last-=2;
    }
    inverted[10]= '\n';
}

/* This function turns a array of chars in a decimal representation to its numeric value.
ARG
    char str[]
    int size
    int isnegative
RETURN
    unsigned int number
*/
unsigned tonumeric(char str[], int size, int isnegative){
    unsigned number = 0;
    int limit = 0;
    if (isnegative==1){
        limit = 1;
    }
    for (int i = limit; i < size; i++) {
        number += (str[i] - '0') * power(size - i - 1, 10);
    }
    return number;
}

int main()
{
    char str[20];
    char decimal[36], hexadecimal[36], binary[36], inverted[11];
    unsigned int number;
    int ishexa = 0;
    int isnegative = 0;
    int bisize, hexasize, decsize;
    /* Read up to 20 bytes from the standard input into the str buffer */
    int n = read(STDIN_FD, str, 20);

    if (str[0]=='0' && str[1]=='x'){
        ishexa=1;
        if (str[2] >= '8' && n >= 10){
            isnegative = 1;
        }
    } else if (str[0] == '-'){
        isnegative = 1;
    }


    if (ishexa != 1){
        //finds the number in all representations
        number = tonumeric(str, n-1, isnegative);
        bisize = numerictobi(number, isnegative, binary);
        hexasize = numerictohexa(number, isnegative, hexadecimal);

        //prints said representations
        write(STDOUT_FD, binary, bisize + 1);
        write(STDOUT_FD, str, n);
        write(STDOUT_FD, hexadecimal, hexasize + 1);

        //inverts endian
        invertendian(hexadecimal,inverted, hexasize);

        //dec representation for the changed endian
        number = hexatonumeric(inverted, 0, 10);
        decsize = numerictodec(number, 0, decimal);
        write(STDOUT_FD, decimal, decsize + 1);

    }else{
        //finds the number in all representations
        number = hexatonumeric(str, isnegative, n-1);
        bisize = numerictobi(number, isnegative, binary);
        decsize = numerictodec(number, isnegative, decimal);

        //prints said representations
        write(STDOUT_FD, binary, bisize + 1);
        write(STDOUT_FD, decimal, decsize + 1);
        write(STDOUT_FD, str, n);

        //inverts endian
        invertendian(str, inverted, n-1);

        //dec representation for the changed endian
        number = hexatonumeric(inverted, 0, 10);
        decsize = numerictodec(number, 0, decimal);
        write(STDOUT_FD, decimal, decsize + 1);
    }
    return 0;
}

void _start()
{
    int ret_code = main();
    exit(ret_code);
}