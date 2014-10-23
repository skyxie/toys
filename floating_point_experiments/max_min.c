#include <stdio.h>
#include <limits.h>
#include <float.h>

int main()
{
  printf("             %12s %12s\n", "MIN", "MAX");
  printf("UNSIGNED INT %12u %12u\n", 0, UINT_MAX);
  printf("  SIGNED INT %12d %12d\n", INT_MIN, INT_MAX);
  printf("       FLOAT %12.5e %12.5e\n", FLT_MIN, FLT_MAX);
}
