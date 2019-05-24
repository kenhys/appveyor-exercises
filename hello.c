#include <stdio.h>
#include <wchar.t>

int main(int argc, char *argv[]){
  wchar_t name[] = L"\\\\?\\\C:\projects\nroonga";
  size_t length = wcslen(name);
  wmemmove(name, name+4, length);
  name[length - 4] L'\\0';
  printf("%ls\n", name);
  return 0;
}
