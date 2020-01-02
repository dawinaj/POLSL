#include <algorithm>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <limits>
#include <string>
#include <type_traits>
#include <vector>
using namespace std;

int numlen = 8;

template<class T>
typename enable_if<!numeric_limits<T>::is_integer, bool>::type
eq(T x, T y, int ulp = 8)
{
	return fabs(x - y) <= numeric_limits<T>::epsilon() * fabs(x + y) * ulp
		|| fabs(x - y) < numeric_limits<T>::min();
}
bool eq(float a, float b, float epsilon)
{
	return fabs(a - b) <= numeric_limits<T>::epsilon() * fabs(x + y) * ulp;
}
bool gt(float a, float b, float epsilon)
{
	return (a - b) > numeric_limits<T>::epsilon() * fabs(x + y) * ulp;
}
bool lt(float a, float b, float epsilon)
{
	return (b - a) > numeric_limits<T>::epsilon() * fabs(x + y) * ulp;
}

string pad(double num)
{
	string temp = to_string(num);
	int offset = 1;
	if (temp.find_last_not_of('0') == temp.find('.'))
		offset = 0;
	temp.erase(temp.find_last_not_of('0') + offset, string::npos);
	if (temp.find('-')) // dirty deeds done dirt cheap
		temp.insert(0, " ");
	temp.append(numlen, ' ');
	return temp.substr(0, numlen);
}

class Simplex
{
public:
	int height = 0;
	int width = 0;
	double k = 0;
	vector<double> body;
	vector<double> coeffs;
	vector<double> values;
	double value = 0;

	Simplex(int h, int w)
	{
		height = h;
		width = w;
		body.resize(h * w, 0);
		coeffs.resize(w, 0);
		values.resize(h, 0);
	}
	~Simplex() {}
	double elem(int y, int x) const
	{
		int pos = (y - 1) * width + x - 1;
		return body[pos];
	}
	double elem(int y, int x, double v)
	{
		int pos = (y - 1) * width + x - 1;
		body[pos] = v;
		return body[pos];
	}
	double coeff(int x) const
	{
		int pos = x - 1;
		return coeffs[pos];
	}
	double coeff(int x, double v)
	{
		int pos = x - 1;
		coeffs[pos] = v;
		return coeffs[pos];
	}
	double val(int y) const
	{
		int pos = y - 1;
		//		cout << pos;
		return values[pos];
	}
	double val(int y, double v)
	{
		int pos = y - 1;
		values[pos] = v;
		return values[pos];
	}
	double fVal() const
	{
		return value;
	}
	double fVal(double v)
	{
		value = v;
		return value;
	}
	double kVal() const
	{
		return k;
	}
	double kVal(double v)
	{
		k = v;
		return k;
	}
	void resize(int h, int w)
	{
		if (h < height)
		{
			body.resize(h * width);
			values.resize(h);
			height = h;
		}
		if (w != width)
		{
			vector<double> temp = body;
			if (w > width)
			{
				fill(body.begin(), body.end(), 0);
				body.resize(w * height);
			}
			else if (w < width)
			{
				body.resize(w * height);
				fill(body.begin(), body.end(), 0);
			}
			int iterw = min(w, width);
			for (int y = 0; y < height; y++)
			{
				for (int x = 0; x < iterw; x++)
				{
					int oldpos = y * width + x;
					int newpos = y * w + x;
					body[newpos] = temp[oldpos];
				}
			}
			coeffs.resize(w);
			width = w;
		}
		if (h > height)
		{
			body.resize(h * width);
			values.resize(h);
			height = h;
		}
	}
	double xval(int x) const
	{
		int yPos = 0;
		if (eq(coeff(x), 0.0))
		{
			double minV = INFINITY;
			double maxV = -INFINITY;
			double total = 0;
			for (int y = 1; y <= height; y++)
			{
				total += elem(y, x);
				if (elem(y, x) < minV)
					minV = elem(y, x);
				if (elem(y, x) > maxV)
					maxV = elem(y, x);
				if (eq(elem(y, x), 1.0))
					yPos = y;
			}
			if (eq(minV, 0.0) && eq(maxV, 1.0) && eq(total, 1.0))
				return val(yPos);
		}
		return 0;
	}
	int mx_coeff_indx() const
	{
		int maxcoeffI = max_element(coeffs.begin(), coeffs.end()) - coeffs.begin() + 1;
		double maxcoeffV = coeff(maxcoeffI);
		if (maxcoeffV + 1e-6 > 0)
			return maxcoeffI;
		return 0;
	}
	int smallest_valdiv(int pivX) const
	{
		if (pivX > 0)
		{
			int pivY = 0;
			double minD = INFINITY;
			for (int y = 1; y <= height; y++)
				if (val(y) / elem(y, pivX) < minD && elem(y, pivX) + 1e-6 > 0)
				{
					pivY = y;
					minD = val(y) / elem(y, pivX);
				}
			return pivY;
		}
		return 0;
	}
	void table() const
	{
		cout << endl;
		for (int y = 1; y <= height; y++)
		{
			for (int x = 1; x <= width; x++)
				cout << " " << pad(elem(y, x)) << " |";
			cout << "| " << pad(val(y)) << endl;
		}
		cout << string((width + 1) * (numlen + 3), '=') << endl;
		for (int x = 1; x <= width; x++)
			cout << " " << pad(coeff(x)) << " |";
		cout << "| " << pad(fVal()) << endl << endl;
	}
	void vars() const
	{
		int nX = width - height;
		int nE = height;
		//		cout << "nX=" << nX << " & nE=" << nE << endl;
		for (int x = 1; x <= nX; x++)
			cout << "x" << x << " = " << xval(x) << endl;
		for (int x = 1; x <= nE; x++)
			cout << "s" << x << " = " << xval(nX + x) << endl;

		double total = 0;
		for (int x = 1; x <= nX; x++)
			total += xval(x);
		cout << "To = " << total << endl << endl;
		double Sm = 1 / total;
		cout << "Sm = " << Sm - kVal() << endl << endl;
		for (int x = 1; x <= nX; x++)
			cout << "p" << x << " = " << xval(x) * Sm * 100 << "%" << endl;
	}

	Simplex(const Simplex & obj, int pivX = 0)
	{
		k = obj.k;
		width = obj.width;
		height = obj.height;
		body = obj.body;
		coeffs = obj.coeffs;
		values = obj.values;
		value = obj.value;

		if (pivX < 1 || pivX > width)
			pivX = obj.mx_coeff_indx();

		int pivY = obj.smallest_valdiv(pivX);

		if (pivX > 0 && pivY > 0)
		{
			double pivVal = obj.elem(pivY, pivX);
			for (int y = 1; y <= height; y++)
			{
				if (y == pivY)
				{
					for (int x = 1; x <= width; x++)
						elem(pivY, x, obj.elem(pivY, x) / pivVal);
					val(y, obj.val(pivY) / pivVal);
				}
				else
				{
					for (int x = 1; x <= width; x++)
						elem(y, x, obj.elem(y, x) - obj.elem(pivY, x) * obj.elem(y, pivX) / pivVal);
					val(y, obj.val(y) - obj.elem(y, pivX) * obj.val(pivY) / pivVal);
				}
			}
			for (int x = 1; x <= width; x++)
				coeff(x, obj.coeff(x) - obj.elem(pivY, x) * obj.coeff(pivX) / pivVal);
			fVal(obj.fVal() - obj.val(pivY) * obj.coeff(pivX) / pivVal);
		}
	}
	Simplex & operator= (const Simplex & obj)
	{
		if (this != &obj)
		{
			k = obj.k;
			height = obj.height;
			width = obj.width;
			body.resize(height * width, 0);
			coeffs.resize(width, 0);
			values.resize(height, 0);
			body = obj.body;
			coeffs = obj.coeffs;
			values = obj.values;
			value = obj.value;
		}
		return *this;
	}
};

int main()
{
	Simplex D1(5, 10);
	{
		D1.elem(1, 1, 4.000000);	D1.elem(1, 2, 31.000000);	D1.elem(1, 3, 2.000000);	D1.elem(1, 4, 40.000000);	D1.elem(1, 5, 6.000000);	D1.elem(1, 6, 1.000000);	D1.elem(1, 7, 0.000000);	D1.elem(1, 8, 0.000000);	D1.elem(1, 9, 0.000000);	D1.elem(1, 10, 0.000000);	D1.val(1, 1.000000);
		D1.elem(2, 1, 24.000000);	D1.elem(2, 2, 6.000000);	D1.elem(2, 3, 26.000000);	D1.elem(2, 4, 8.000000);	D1.elem(2, 5, 25.000000);	D1.elem(2, 6, 0.000000);	D1.elem(2, 7, 1.000000);	D1.elem(2, 8, 0.000000);	D1.elem(2, 9, 0.000000);	D1.elem(2, 10, 0.000000);	D1.val(2, 1.000000);
		D1.elem(3, 1, 6.000000);	D1.elem(3, 2, 27.000000);	D1.elem(3, 3, 30.000000);	D1.elem(3, 4, 31.000000);	D1.elem(3, 5, 5.000000);	D1.elem(3, 6, 0.000000);	D1.elem(3, 7, 0.000000);	D1.elem(3, 8, 1.000000);	D1.elem(3, 9, 0.000000);	D1.elem(3, 10, 0.000000);	D1.val(3, 1.000000);
		D1.elem(4, 1, 6.000000);	D1.elem(4, 2, 24.000000);	D1.elem(4, 3, 10.000000);	D1.elem(4, 4, 30.000000);	D1.elem(4, 5, 18.000000);	D1.elem(4, 6, 0.000000);	D1.elem(4, 7, 0.000000);	D1.elem(4, 8, 0.000000);	D1.elem(4, 9, 1.000000);	D1.elem(4, 10, 0.000000);	D1.val(4, 1.000000);
		D1.elem(5, 1, 23.000000);	D1.elem(5, 2, 10.000000);	D1.elem(5, 3, 29.000000);	D1.elem(5, 4, 11.000000);	D1.elem(5, 5, 4.000000);	D1.elem(5, 6, 0.000000);	D1.elem(5, 7, 0.000000);	D1.elem(5, 8, 0.000000);	D1.elem(5, 9, 0.000000);	D1.elem(5, 10, 1.000000);	D1.val(5, 1.000000);
		D1.coeff(1, 1.000000);		D1.coeff(2, 1.000000);		D1.coeff(3, 1.000000);		D1.coeff(4, 1.000000);		D1.coeff(5, 1.000000);		D1.coeff(6, 0.000000);		D1.coeff(7, 0.000000);		D1.coeff(8, 0.000000);		D1.coeff(9, 0.000000);		D1.coeff(10, 0.000000);		D1.fVal(0.000000);
		D1.kVal(16.000000);
	}
	Simplex D2(5, 10);
	{
		D2.elem(1, 1, 38.000000);	D2.elem(1, 2, 18.000000);	D2.elem(1, 3, 36.000000);	D2.elem(1, 4, 36.000000);	D2.elem(1, 5, 19.000000);	D2.elem(1, 6, 1.000000);	D2.elem(1, 7, 0.000000);	D2.elem(1, 8, 0.000000);	D2.elem(1, 9, 0.000000);	D2.elem(1, 10, 0.000000);	D2.val(1, 1.000000);
		D2.elem(2, 1, 11.000000);	D2.elem(2, 2, 36.000000);	D2.elem(2, 3, 15.000000);	D2.elem(2, 4, 18.000000);	D2.elem(2, 5, 32.000000);	D2.elem(2, 6, 0.000000);	D2.elem(2, 7, 1.000000);	D2.elem(2, 8, 0.000000);	D2.elem(2, 9, 0.000000);	D2.elem(2, 10, 0.000000);	D2.val(2, 1.000000);
		D2.elem(3, 1, 40.000000);	D2.elem(3, 2, 16.000000);	D2.elem(3, 3, 12.000000);	D2.elem(3, 4, 32.000000);	D2.elem(3, 5, 13.000000);	D2.elem(3, 6, 0.000000);	D2.elem(3, 7, 0.000000);	D2.elem(3, 8, 1.000000);	D2.elem(3, 9, 0.000000);	D2.elem(3, 10, 0.000000);	D2.val(3, 1.000000);
		D2.elem(4, 1, 2.000000);	D2.elem(4, 2, 34.000000);	D2.elem(4, 3, 11.000000);	D2.elem(4, 4, 12.000000);	D2.elem(4, 5, 31.000000);	D2.elem(4, 6, 0.000000);	D2.elem(4, 7, 0.000000);	D2.elem(4, 8, 0.000000);	D2.elem(4, 9, 1.000000);	D2.elem(4, 10, 0.000000);	D2.val(4, 1.000000);
		D2.elem(5, 1, 36.000000);	D2.elem(5, 2, 17.000000);	D2.elem(5, 3, 37.000000);	D2.elem(5, 4, 24.000000);	D2.elem(5, 5, 38.000000);	D2.elem(5, 6, 0.000000);	D2.elem(5, 7, 0.000000);	D2.elem(5, 8, 0.000000);	D2.elem(5, 9, 0.000000);	D2.elem(5, 10, 1.000000);	D2.val(5, 1.000000);
		D2.coeff(1, 1.000000);		D2.coeff(2, 1.000000);		D2.coeff(3, 1.000000);		D2.coeff(4, 1.000000);		D2.coeff(5, 1.000000);		D2.coeff(6, 0.000000);		D2.coeff(7, 0.000000);		D2.coeff(8, 0.000000);		D2.coeff(9, 0.000000);		D2.coeff(10, 0.000000);		D2.fVal(0.000000);
		D2.kVal(26.000000);
	}



	//	D1.table();
	//	D1.vars();

	while (true)
	{
		Simplex current(D1);
		if (current.fVal() == D1.fVal())
		{
			current.table();
			current.vars();
			break;
		}
		D1 = current;
	}

	cout << endl << "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||" << endl << endl;

	//	D2.table();
	//	D2.vars();

	while (true)
	{
		Simplex current(D2);
		if (current.fVal() == D2.fVal())
		{
			current.table();
			current.vars();
			break;
		}
		D2 = current;
	}

	return 0;
}
