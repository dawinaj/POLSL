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
	bool corr = false;
	do
	{
		corr = true;
		double prev = 0;
		for (size_t i = 0; i < coeffs.size(); ++i)
		{
			double temp = coeffs[i] + prev;
			if (temp < 0)
			{
				b += 1;
				corr = false;
				break;
			}
			prev = b * temp;
		}
	}
	while (!corr);

	//===== A =====//

	for (size_t i = 0; i < coeffs.size(); ++i) // rotate polynomial by X and Z-axes
		coeffs[i] *= pow(-1, i);
	
	do
	{
		corr = true;
		double prev = 0;
		for (size_t i = 0; i < coeffs.size(); ++i)
		{
			double temp = coeffs[i] + prev;
			if (temp <= 0)
			{
				a += 1;
				corr = false;
				break;
			}
			prev = a * temp;
		}
	}
	while (!corr);

	return pair<double, double>(-a, b);
}


int main()
{
	vector<double> coeffs = { 0, 0, 0, -1, 3, 144, 140 }; // highest power's coeff --> lower powers' coeffs --> free coeff

	pair<double, double> values = poly(coeffs, 3.1415);
	cout << "Regular value: " << values.first << endl;
	cout << "Horner  value: " << values.second << endl;
	cout << endl;
	pair<double,double> bounds = bound(coeffs);
	cout << "Lower bound: " << bounds.first << endl;
	cout << "Upper bound: "<< bounds.second << endl;
}
