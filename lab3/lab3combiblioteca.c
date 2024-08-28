#include <stdio.h>


int power(int exp, int base){
    int ans = 1;
    if (exp == 0)
        return 1;
    for(int i=0;i<exp;i++){
        ans *= base;
    }
    return ans;
}

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

unsigned hexatonumeric(char str[], int isnegative, int size){
    //flag neg, ~number
    unsigned number = 0;
    if(isnegative==0){
        //decimal[0] = '\0';
        for(int i=2;i < size;i++){
            //potencia
            if(str[i]>='a'){
                number += (str[i] - 'W') * power(size - i - 1, 16);
                //printf("%d\n", power(size - i - 1, 16));

            }else{
                number += (str[i] - '0') * power(size - i - 1, 16);
                //printf("%d\n", power(size - i - 1, 16));
            }
        }
        
    }
    else {
        //printf("entrou negativo\n");
        
        for(int i=2;i < size;i++){
            //potencia
            if(str[i]>='a'){
                number += (str[i] - 'W') * power(size - i - 1, 16);
                //printf("%d\n", power(size - i - 1, 16));

            }else{
                number += (str[i] - '0') * power(size - i - 1, 16);
                //printf("%d\n", power(size - i - 1, 16));
            }
        }
        // if(number> power(31,2)){
        //     number = ~number;
        //     number+=1;
        // }
    }
    return number;
}


int numerictodec(unsigned number, int isnegative, char decimal[]){
    int q =1;
    int i =1;
    if (isnegative == 0){
        decimal[0] = '\0';
        while (q !=0){
            decimal[i] = '0' + (number%10);
            number = number / 10;
            q = number;
            i++;
        }
        invertstring(i-1, decimal);
        return i-1;
    } else{
        if(number> power(31,2)){
            number+=1;
            number = ~number;
        } else{
            number = ~number;
            number+=1;
        }
        decimal[0] = '\0';
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

int numerictohexa(unsigned number, int isnegative, char hexadecimal[]){
    int q =1;
    int i =1;
    if (isnegative == 0){
        hexadecimal[0] = '\0';
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

int numerictobi(unsigned number, int isnegative, char binary[]){
    int q =1;
    int i =1;
    if (isnegative==0){
        binary[0] = '\0';
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

int invertendian(char string[], char inverted[], int size){
    inverted[0] = '0';
    inverted[1] = 'x';
    int p = 1;
    if (size<10){
        //printf("%d\n", size);
        for(int k=size-1;k>1;k--){
            inverted[10-p] = string[k];
            p++;
        }
        
        
        for(int j=2;j<10-size+2;j++){
    //        printf("%d\n", j);
            inverted[j]='0';
    //        printf("extra: %c\n", inverted[j]);
        }
    } else{
        for(int f=2; f<10;f++){
            inverted[f]=string[f];
        }
    }
    //printf("%s\n", inverted);
    
    
    
    
    
    int first = 2;
    int last = 9;
    char temp1, temp2;
    while(first<last){
        // printf("first: %c %c\n", inverted[first], inverted[first+1]);
        // printf("last: %c %c\n", inverted[last-1], inverted[last]);
        // printf("%d %d\n", first, last);
        temp1=inverted[first];
        temp2=inverted[first+1];
        inverted[first]=inverted[last-1];
        inverted[first+1]=inverted[last];
        inverted[last-1]=temp1;
        inverted[last]=temp2;
        //\\("temps: %c %c\n", temp1, temp2);
        //printf("inverted first: %c %c\n", inverted[first], inverted[first+1]);
        //printf("inverted last: %c %c\n", inverted[last-1], inverted[last]);
        first+=2;
        last-=2;
    }
    //printf("%d\n", first);
    // if (size<10){
    //     for(int j=size;j<10;j++){
    // //        printf("%d\n", j);
    //         inverted[j]='0';
    // //        printf("extra: %c\n", inverted[j]);
    //     }
    // }
    inverted[10]= '\0';
    //printf("extra 10: %c\n", inverted[10]);
}

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
    char decimal[36], hexadecimal[32], binary[35], inverted[11];
    unsigned number;
    int ishexa = 0;
    int isnegative = 0;
    int bisize, hexasize, decsize;
    /* Read up to 20 bytes from the standard input into the str buffer */
    //int n = read(STDIN_FD, str, 20);
    scanf("%s", str);
    
    int n = 0;
    while (str[n] != '\0')
        n++;
    //printf("size of str: %d\n", n);
    //valor numerico
    if (str[0]=='0' && str[1]=='x'){
        ishexa=1;
        if (str[2] >= '8' && n >= 10){
            isnegative = 1;
        }
    } else if (str[0] == '-'){
        isnegative = 1;
    }
    
    
    if (ishexa != 1){
        number = tonumeric(str, n, isnegative);
        bisize = numerictobi(number, isnegative, binary);
        hexasize = numerictohexa(number, isnegative, hexadecimal);
        //printf("%u\n", number);
        printf("%s\n", binary);
        printf("%s\n", str);
        printf("%s\n", hexadecimal);
        invertendian(hexadecimal,inverted, hexasize);
        //printf("%s\n", inverted);
        if (inverted[2] >= '8'){
            isnegative = 1;
        } else{
            isnegative = 0;
        }
        //printf("%d\n",isnegative);
        number = hexatonumeric(inverted, isnegative, 10);
        //printf("%d\n", number);
        decsize = numerictodec(number, 0, decimal);
        printf("%s\n", decimal);
        
    }else{
        number = hexatonumeric(str, isnegative, n);
        bisize = numerictobi(number, isnegative, binary);
        decsize = numerictodec(number, isnegative, decimal);
        printf("%s\n", binary);
        printf("%s\n", decimal);
        printf("%s\n", str);
        invertendian(str, inverted, n);
        //printf("%s\n", inverted);
        //printf("%c\n", inverted[2]);
        if (inverted[2] >= '8'){
            isnegative = 1;
        } else{
            isnegative = 0;
        }
        number = hexatonumeric(inverted, isnegative, 10);
        decsize = numerictodec(number, isnegative, decimal);
        printf("%s\n", decimal);
    }
    return 0;
}


