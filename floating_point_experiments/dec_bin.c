#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main(int argc, char *argv[])
{
  int i = 0;
  int pows[23];
  float x = atof(argv[1]);

  while (x > 0)
  {
    float next_pow = floor(log(x)/log(2));
    pows[i++] = (int)next_pow;
    x = x - ((float)pow(2.0, next_pow));
  }

  char str[i * 10];
  str[0] = '\0';
  for (int j = 0; j < i; j++)
  {
    sprintf(str, "%s1*2^%d", str, pows[j]);
    if (j < i - 1)
    {
      strcat(str, " + ");
    }
  }

  printf("%s = %s\n", argv[1], str);
}