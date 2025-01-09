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

/* This function turns a array of chars in a decimal representation to its numeric value.
ARG
    char str[]
    int size
    int isnegative
RETURN
    unsigned int number
*/
int tonumeric(char str[], int size, int isnegative){
    int number = 0;
    for (int i = 0; i < size; i++) {
        number += (str[i] - '0') * power(size - i - 1, 10);
    }
    if (isnegative==1){
        number*=-1;
    }

    return number;
}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

// Selects the fraction of the number to be inserted in the answer and does so by shifting bit to bit and comparing it to the answer.
// Parameters: 
//    - int: number [to be inserted in the binary answer]
//    - int: answer [the answer as a binary number].
//    - int: begin [first position of the number to be collected]
//    - int: last [last position of the number to be collected]
//
// Returns: (answer)
unsigned pack(int number, int answer, int begin, int end, int last){
    unsigned int temp=0;
    for(begin; begin<=end;begin++){
        answer = answer<<1;
        temp = number << begin;
        temp = temp >> 31;
        answer = answer | temp;
        
    }
    return answer;
}

int main(){
    char str[31], binary[36], inverted[11], decimal[5];
    int answer = 0, number;
    int isnegative = 0, counter = 1, first=28;

    /* Read up to 20 bytes from the standard input into the str buffer */
    int n = read(STDIN_FD, str, 31);

    while (counter<6){
        isnegative = 0;
        //int stringposition=4;
        for(int begin = 3; begin>=0;begin--){
            decimal[begin] = str[first];
            //stringposition--;
            first--;
        }
        decimal[4] = '\n';
        if (str[first] == '-'){
            isnegative=1;
        }
        first-=2;
        //possuo o decimal
        number = tonumeric(decimal, 4, isnegative);

        if(counter== 1){
            answer = pack(number, answer, 21,31, 0);
        } else if(counter ==2){
            answer = pack(number, answer, 27,31, 0);

        }else if(counter==3){
            answer = pack(number, answer, 27,31, 0);

        } else if(counter ==4){
            answer = pack(number, answer, 24,31, 0);

        } else{
            answer = pack(number, answer, 29,31, 1);
        }

        counter++;
    }
    hex_code(answer);
    return 0;
}

void _start()
{
    int ret_code = main();
    exit(ret_code);
}