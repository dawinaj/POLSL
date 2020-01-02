#include "stdafx.h"
#include <iostream>
#include <cmath>
#include <ctime>
#include <cstdlib> 
#include <algorithm>

using namespace std;

int num = 0;

double f(double x)
{
	num++;
	return x / (1.2 - sin(2 * x));
}


double rand_interv(double c, double d)
{
	return rand() * (d - c) / RAND_MAX + c;
}

int main()
{
	srand((unsigned int)time(NULL));
	rand();
	
	double e = 0.01;
	double a = -1;
	double b = 1;
	
	double temp1 = rand_interv(a, b);
	double temp2 = rand_interv(a, b);
	double x1 = min(temp1, temp2);
	double x2 = max(temp1, temp2);
	double f1 = f(x1);
	double f2 = f(x2);
	double ftemp1, ftemp2;
	
	while (abs(b - a) >= e)
	{
		if (f1 <= f2)
		{
			a = x1;
			temp1 = rand_interv(a, b);
			ftemp1 = f(temp1);
			temp2 = x2;
			ftemp2 = f2;
		}
		else
		{
			b = x2;
			temp1 = x1;
			ftemp1 = f1;
			temp2 = rand_interv(a, b);
			ftemp2 = f(temp2);
		}

		if (temp1 < temp2)
		{
			x1 = temp1;
			x2 = temp2;
			f1 = ftemp1;
			f2 = ftemp2;
		}
		else
		{
			x1 = temp2;
			x2 = temp1;
			f1 = ftemp2;
			f2 = ftemp1;
		}
	}
	cout << (a + b) / 2 << endl << endl;
	cout << num << endl;
	system("PAUSE");
	return 0;
}
