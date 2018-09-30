BEGIN{
#include<stdio.h>
c=0;
}
{
if($1=="d")
c++
}
END{
printf("Packets dropped are: %d\n",c);
}
