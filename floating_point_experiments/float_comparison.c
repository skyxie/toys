#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
  float f = 0.1f, sum = 0;
  int max = atoi(argv[1]);
   
  printf("   %25s %25s %25s\n", "sum", "float product", "double product");
  for (int i = 0; i < max; ++i)
  {
    float float_product = f * i;
    double double_product = ((double)f) * i;

    printf("%2d) %1.23f %1.23f %1.23f\n", i, sum, float_product, double_product);

    sum += f;
  }
}
