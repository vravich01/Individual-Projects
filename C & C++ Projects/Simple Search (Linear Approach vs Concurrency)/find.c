#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>

int newlineCheck(FILE * input)
{
    int ret = 0;
    char c = fgetc(input);
    if(c == '\n') {
        ret++;
        ret += newlineCheck(input);
        ungetc(c, input);
    } else {
        ungetc(c, input);
        return 0;
    }
    return ret;
}

void search(char * filename, char * target) 
{
    FILE * input = fopen(filename, "r");
    char * currentWord = (char *) malloc(999 * sizeof(char));
    int lines = 1;
    while (fscanf(input, "%s", currentWord) == 1) {
        if(strcmp(currentWord, target) == 0) {
            printf("\"%s\": %s, ln %d\n", target, filename, lines);
        }
        lines += newlineCheck(input);
    }
}

int main (int argc, char ** argv)
{
    for (int i = 2; i < argc; i++) {
        if(fork() ==0) {
            search(argv[i], argv[1]);
            exit(0);
        }
    }
    for (int i = 2; i < argc; i++) {
        wait(NULL);
    }
    return 0;
}