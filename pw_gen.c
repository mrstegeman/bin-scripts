#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

int main(int argc, char * argv[]) {
    if (argc == 2 || (argc == 3 && strcmp(argv[2], "-a") == 0)) {
        int chars = atoi(argv[1]);
        srand((unsigned int)time(NULL));
        int i;
        int num;
        for (i = 0; i < chars; ++i) {
            num = (rand() % 94) + 33;
            if (argc == 3) {
                while (!((num >= 48 && num <= 57) ||
                         (num >= 65 && num <= 90) ||
                         (num >= 97 && num <= 122))) {
                    num = (rand() % 94) + 33;
                }
            }
            printf("%c", num);
        }
        printf("\n");
        return 0;
    }
    return 1;
}
