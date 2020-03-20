#include <iostream>
#include <cmath>
#include <vector>

using namespace std;

pair<double, double> poly(vector<double> coeffs, double x)
{
	double regular = 0;
	size_t maxpow = coeffs.size() - 1;
	for (size_t i = 0; i < coeffs.size(); ++i)
		regular += pow(x, maxpow - i) * coeffs[i];

	double horner = 0;
	for (size_t i = 0; i < coeffs.size(); ++i)
		horner = horner * x + coeffs[i];

	return pair<double, double>(regular, horner);
}


pair<double, double> bound(vector<double> coeffs)
{
	while (coeffs.front() == 0) // remove highest powers if coeffs are null
		coeffs.erase(coeffs.begin());
	if (coeffs.front() < 0)     // rotate polynomial by X-axis if highest power coeff is negative
		for (size_t i = 0; i < coeffs.size(); ++i)
			coeffs[i] *= -1;

	double b = 1;
	double a = 1;

	//===== B =====//
	bool corr = true;
	do
	{
		corr = true;
		double prev = 0;
		double temp = 0;
		for (size_t i = 0; i < coeffs.size(); ++i)
		{
			temp = coeffs[i] + prev;
			if (temp < 0)
			{
				b += 1;
				corr = false;
				break;
			}
			prev = b * temp;
		}
		if (corr && temp == 0)
		{
			b += 1;
			corr = false;
		}
	} while (!corr);

	//===== A =====//
	for (size_t i = 0; i < coeffs.size(); ++i) // rotate polynomial by X and Z-axes
		coeffs[i] *= pow(-1, i);
	do
	{
		corr = true;
		double prev = 0;
		double temp = 0;
		for (size_t i = 0; i < coeffs.size(); ++i)
		{
			temp = coeffs[i] + prev;
			if (temp < 0)
			{
				a += 1;
				corr = false;
				break;
			}
			prev = a * temp;
		}
		if (corr && temp == 0)
		{
			a += 1;
			corr = false;
		}
	} while (!corr);

	return pair<double, double>(-a, b);
}

double cosxestimator(double x, double e = numeric_limits<double>::epsilon())
{
	double sum = 1;
	double ele = 1;
	int i = 1;
	while (abs(ele) >= abs(sum*e))
	{
		ele *= x / (2*i-1) * x / (2*i);
		if (i & 1)
			sum -= ele;
		else
			sum += ele;
//		cout << ele << endl << sum << endl << endl;
		++i;
	}
	return sum;
}

int main()
{
	vector<double> coeffs = { 0, 0, 0, -1, 3, 144, 140 }; // highest power's coeff --> lower powers' coeffs --> free coeff

	pair<double, double> values = poly(coeffs, 3.1415);
	cout << "Regular value: " << values.first << endl;
	cout << "Horner  value: " << values.second << endl;
	cout << endl;
	pair<double, double> bounds = bound(coeffs);
	cout << "Lower bound: " << bounds.first << endl;
	cout << "Upper bound: " << bounds.second << endl;

	double x = 3.14159/4;
	cout << "Approximation at x=" << x << " of cos(x)=" << cosxestimator(x) << endl;
}
