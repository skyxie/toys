#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void string_tail(char *string, int maxlen) {
  int len = strlen(string);
  if (len > maxlen) {
    strcpy(string, string+(len-maxlen));
  }
}

int main(int argc, char *argv[])
{
  if (argc < 3) {
    printf("USAGE: %s <string to tail> <tail length>\n", argv[0]);
    exit(1);
  } else {
    char* string = argv[1];
    int maxlen = atoi(argv[2]);
    string_tail(string, maxlen);
    printf("%s\n", string);
    exit(0);
  }
}
