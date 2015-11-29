#include <stdio.h>

int makeguess(int bigOrSmall)
{
       static mid = 50;
       static min = 1;
       static max = 100;
       if (bigOrSmall == 0)
       {
               min = 1;
               max = 100;
               mid = 50;
               return 0;
       }
       if (bigOrSmall == 1)
       {
               max = (max + mid) /2;
       }
       else
       {
               min = (min + mid) / 2;
       }
       printf("%d\n", mid);
}

int main()
{
       while (1)
       {
               int guess;
               scanf("%d", &guess);
               makeguess(guess);
       }
       return 0;
}
