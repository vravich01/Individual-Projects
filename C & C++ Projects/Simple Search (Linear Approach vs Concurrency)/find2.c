#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

typedef struct thread_args {
    char * filename;
    char * target;
} thread_args;

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

void * search(void * t_args) 
{
    thread_args * args = (thread_args *) t_args;

    char * filename = args->filename;
    char * target = args->target;


    FILE * input = fopen(filename, "r");
    char * currentWord = (char *) malloc(999 * sizeof(char));
    int lines = 1;
    while (fscanf(input, "%s", currentWord) == 1) {
        if(strcmp(currentWord, target) == 0) {
            printf("\"%s\": %s, ln %d\n", target, filename, lines);
        }
        lines += newlineCheck(input);
    }

    return NULL;
}



int main (int argc, char ** argv)
{
    struct thread_args * t_args = malloc(sizeof(struct thread_args));
    pthread_t thread_ids[argc - 2];
    for (int i = 2; i < argc; i++) {
        
        t_args->filename = argv[i];
        t_args->target = argv[1];
        pthread_create(&thread_ids[i - 2], NULL, search, t_args);
    }
    for (int i = 2; i < argc; i++) {
        t_args->filename = argv[i];
        t_args->target = argv[1];
        pthread_join(thread_ids[i - 2], NULL);
    }
    free(t_args);
    return 0;
}

//search(argv[i], argv[1]);