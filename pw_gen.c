#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

int main(int argc, char * argv[]) {
    char *charlist = "abcdefghijklmnopqrstuvwxyz"
                     "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                     "1234567890`-=~!@#$%^&*()_+"
                     "[]\\{}|;':\",./<>?";

    if (argc == 2 || (argc == 3 && strcmp(argv[2], "-a") == 0)) {
        int chars = atoi(argv[1]);
        int len = ((argc == 3) ? 62 : strlen(charlist));
        int i;

        srand((unsigned int)time(NULL));

        for (i = 0; i < chars; ++i)
            printf("%c", charlist[rand() % len]);

        printf("\n");
        return 0;
    }
    return 1;
}
