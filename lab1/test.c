#include<stdio.h>
#include<stdlib.h>
#include<time.h>
void arr_set(float *p,int n)
{
	srand((unsigned int)time(NULL));
	for (int i = 0; i < n; i++)
	{
		p[i] = (rand()%1000+1.0)/1000.0;
	}
}
void arr_print(float *p,int n)
{
	int i = 0;
	while (i < n)
	{
		printf("%f ", p[i]);
		i++;
	}
}
int main()
{
	int n;
	scanf("%d", &n);
	float* p=NULL;
	p = (float*)malloc(sizeof(float) * n);
	arr_set(p, n);
	arr_print(p, n);
	return 0;
}
