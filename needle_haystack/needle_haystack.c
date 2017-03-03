#include <stdio.h>
#include <string.h>

int countMatches(const char* needle, const char* haystack) {
  int count = 0;
  int haystack_length = strlen(haystack);
  int needle_length = strlen(needle);
  for(int i = 0; i < haystack_length - needle_length + 1; i++) {
    int charMatches = 0;
    for(int j = 0; j < needle_length; j++) {
      if(needle[j] == haystack[i+j]) {
        charMatches++;
      }
    }
    if (charMatches == needle_length) {
      count++;
    }
  }
  return count;
}

int main() {
  const char a[] = "abba";
  const char b[] = "abbaadcfababba";
  const char c[] = "abbabba";
  const char d[] = "def";

  printf("countMatches(%s, %s) = %d\n", a, b, countMatches(a, b));
  printf("countMatches(%s, %s) = %d\n", a, c, countMatches(a, c));
  printf("countMatches(%s, %s) = %d\n", a, d, countMatches(a, d));
}

