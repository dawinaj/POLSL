#include <iostream>
#include <cmath>
#include <ctime>
#include <cstdlib>
#include <algorithm>
#include <vector>

using namespace std;

double f(double x)
{
	return -x / (1.2-sin(2*x));
}
double df(double x)
{
	return (sin(2*x) - 2*x*cos(2*x) - 1.2) / pow(1.2 - sin(2*x), 2);
}


double rand_interv(double c, double d) // map <A, B> => <C, D>
{
	return rand()* (d - c) / RAND_MAX + c;
}

vector<double> fibonacci = { 0, 1 };
double fib(int pos)
{
	if ((size_t)pos >= fibonacci.size())
		for (int i = fibonacci.size(); i <= pos; i++)
			fibonacci.push_back(fib(i - 1) + fib(i - 2));
	return fibonacci[pos];
}


int main()
{
	srand((unsigned int)time(NULL));
	int r = rand();
	double prec = 0.001;
	double Xmin = -1;
	double Xmax = 1;


	// inner point rand
	{
		double a = Xmin;
		double b = Xmax;

		while (abs(b - a) >= prec)
		{
			double r1 = rand_interv(a, b);
			double r2 = rand_interv(a, b);
			double x1 = min(r1, r2);
			double x2 = max(r1, r2);
			if (f(x1) >= f(x2))
				a = x1;
			else
				b = x2;
		}
		cout << (a + b) / 2 << endl << endl;
	}
	
	// inner point fibonacci
	{
		double a = Xmin;
		double b = Xmax;
		int n = 0;
		while (fib(n) < (b - a) / prec)
			n++;
		double tau = fib(n) / fib(n + 1);
		double x1 = b - tau * (b - a);
		double x2 = a + tau * (b - a);
		double result = 0;

		for (int i = 0; i < n; i++)
		{
			tau = fib(n - i) / fib(n - i + 1);
			if (f(x1) >= f(x2))
			{
				if (abs(b - x1) < prec)
				{
					result = x2;
					break;
				}
				else
				{
					a = x1;
					x1 = x2;
					x2 = a + tau * (b - a);
				}
			}
			else
			{
				if (abs(a - x2) < prec)
				{
					result = x1;
					break;
				}
				else
				{
					b = x2;
					x2 = x1;
					x1 = b - tau * (b - a);
				}
			}
		}
		cout << result << endl << endl;
	}
	
	// inner point golden
	{
		double a = Xmin;
		double b = Xmax;
		double alpha = (sqrt(5) - 1) / 2;
		double x1 = b - alpha * (b - a);
		double x2 = a + alpha * (b - a);

		while (abs(b - a) >= prec)
		{
			if (f(x1) >= f(x2))
			{
				a = x1;
				x1 = x2;
				x2 = a + b - x1;
			}
			else
			{
				b = x2;
				x2 = x1;
				x1 = a + b - x2;
			}
		}
		cout << (a + b) / 2 << endl << endl;
	}

	// inner point quadratic
	{
		double a = Xmin;
		double b = Xmax;
		double k = 4; // [3, 5]
		double x0 = 0.5; // >0 && E[a, b]
		double x1;
		double x2 = a;

		if (f(0) >= f(x0))
		{
			a = 0;
			x1 = x0;
			b = (k + 1) * x0;
		}
		else
		{
			a = -k * x0;
			x1 = 0;
			b = x0;
		}
		while (true)
		{
			double c = -2 * (f(a) * (b - x1) + f(x1) * (a - b) + f(b) * (x1 - a)) / ((b - x1) * (a - b) * (x1 - a));
			if (c > 0)
			{
				double prev = x2;
				x2 = 0.5 * (f(a) * (pow(b, 2) - pow(x1, 2)) + f(x1) * (pow(a, 2) - pow(b, 2)) + f(b) * (pow(x1, 2) - pow(a, 2))) / (f(a) * (b - x1) + f(x1) * (a - b) + f(b) * (x1 - a));
//				cout << x2 << endl;
				if (abs(x2 - prev) < prec)
					break;
			}
			else
			{
				double temp[] = { a + k * (a - x1), a, x1 };
				a = temp[0];
				x1 = temp[1];
				b = temp[2];
			}
			if (x2 <= a || x2 >= b)
			{
				b = x1;
				x1 = a;
				a = x2;
			}
		}
		cout << x2 << endl << endl;
	}

	// inner point gradient
	{
		double a = Xmin;
		double b = Xmax;
		double tau0 = (b-a)/10;
		double taum = 1;
		double beta = 0.6; // E[0, 1]
		int k = 0;
		double tau = tau0;
		
		while (f(tau0) <= f(0) + df(0) * tau0)
		{
			tau = -0.5 * df(0) * pow(tau, 2)/(f(tau)-f(0)-df(0)*taum);

			if (f(tau) >= f(0) + 0.5* df(0)*tau)
				break;
		}
		cout << tau;
	}


	return 0;
}
