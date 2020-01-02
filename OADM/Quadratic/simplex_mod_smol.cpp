#include "pch.h"
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

int numlen = 5;

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
	void resize(int h, int w)
	{
		if (h < height)
		{
			body.resize(h * width, 0);
			values.resize(h, 0);
			height = h;
		}
		if (w != width)
		{
			vector<double> temp = body;
			if (w > width)
			{
				fill(body.begin(), body.end(), 0);
				body.resize(w * height, 0);
			}
			else if (w < width)
			{
				body.resize(w * height, 0);
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
			coeffs.resize(w, 0);
			width = w;
		}
		if (h > height)
		{
			body.resize(h * width, 0);
			values.resize(h, 0);
			height = h;
		}
	}
	double xval(int x) const
	{
		int yPos = 0;
		if (coeff(x) == 0)
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
				if (elem(y, x) == 1)
					yPos = y;
			}
			if (minV == 0 && maxV == 1 && total == 1)
				return val(yPos);
		}
		return 0;
	}
	int mx_coeff_indx_mod() const
	{
		int nX = width - 2 * height;
		int nE = 3 * height - width;
		int pivX = 0;
		double maxE = -INFINITY;
		for (int x = 1; x <= width; x++)
		{
			if (coeff(x) > maxE)
			{
				if (x >= 1 && x <= nX)
				{
					Simplex temp(*this, x);
					if (temp.xval(x + nX + 2 * nE) == 0)
					{
						pivX = x;
						maxE = coeff(x);
					}
				}
				else if (x >= (nX + 2 * nE + 1) && x <= (2 * nX + 2 * nE))
				{
					Simplex temp(*this, x);
					if (temp.xval(x - nX - 2 * nE) == 0)
					{
						pivX = x;
						maxE = coeff(x);
					}
				}
				else if ((x >= (nX + 1) && x <= (nX + 2 * nE)) || (x >= (2 * nX + 2 * nE + 1)))
				{
					pivX = x;
					maxE = coeff(x);
				}
			}
		}
		return pivX;
	}
	int smallest_valdiv(int pivX) const
	{
		if (pivX > 0)
		{
			int pivY = 0;
			double minD = INFINITY;
			for (int y = 1; y <= height; y++)
				if (val(y) / elem(y, pivX) < minD && elem(y, pivX) > 0)
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
		int nX = width - 2 * height;
		int nE = 3 * height - width;
		for (int x = 1; x <= nX; x++)
			cout << "x" << x << "  = " << xval(x) << endl;
		for (int x = 1; x <= nE; x++)
			cout << "Zt" << x << " = " << xval(nX + x) << endl;
		for (int x = 1; x <= nE; x++)
			cout << "Xi" << x << " = " << xval(nX + nE + x) << endl;
		for (int x = 1; x <= nX; x++)
			cout << "Mu" << x << " = " << xval(nX + 2 * nE + x) << endl;
		for (int x = 1; x <= nX; x++)
			cout << "U" << x << "  = " << xval(2 * nX + 2 * nE + x) << endl;
		cout << "f(X) = " << fVal() << endl;
	}

	Simplex(const Simplex& obj, int pivX = 0)
	{
		width = obj.width;
		height = obj.height;
		body = obj.body;
		coeffs = obj.coeffs;
		values = obj.values;
		value = obj.value;

		if (pivX < 1 || pivX > width)
			pivX = obj.mx_coeff_indx_mod();

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
	Simplex& operator= (const Simplex& obj)
	{
		if (this != &obj)
		{
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
	Simplex prev(6, 16);
	{
		prev.elem(1, 1, 3.000000);   	prev.elem(1, 2, 2.000000);   	prev.elem(1, 3, 1.000000);   	prev.elem(1, 4, 0.000000);   	prev.elem(1, 5, 0.000000);   	prev.elem(1, 6, 0.000000);   	prev.elem(1, 7, 0.000000);   	prev.elem(1, 8, 0.000000);   	prev.elem(1, 9, 0.000000);   	prev.elem(1, 10, 0.000000);   	prev.elem(1, 11, 0.000000);   	prev.elem(1, 12, 0.000000);   	prev.elem(1, 13, 0.000000);   	prev.elem(1, 14, 0.000000);   	prev.elem(1, 15, 0.000000);   	prev.elem(1, 16, 0.000000);   	prev.val(1, 6.000000);
		prev.elem(2, 1, 1.000000);   	prev.elem(2, 2, 2.000000);   	prev.elem(2, 3, 0.000000);   	prev.elem(2, 4, 1.000000);   	prev.elem(2, 5, 0.000000);   	prev.elem(2, 6, 0.000000);   	prev.elem(2, 7, 0.000000);   	prev.elem(2, 8, 0.000000);   	prev.elem(2, 9, 0.000000);   	prev.elem(2, 10, 0.000000);   	prev.elem(2, 11, 0.000000);   	prev.elem(2, 12, 0.000000);   	prev.elem(2, 13, 0.000000);   	prev.elem(2, 14, 0.000000);   	prev.elem(2, 15, 0.000000);   	prev.elem(2, 16, 0.000000);   	prev.val(2, 4.000000);
		prev.elem(3, 1, 2.000000);   	prev.elem(3, 2, 0.000000);   	prev.elem(3, 3, 0.000000);   	prev.elem(3, 4, 0.000000);   	prev.elem(3, 5, 3.000000);   	prev.elem(3, 6, 1.000000);   	prev.elem(3, 7, -3.000000);   	prev.elem(3, 8, -1.000000);   	prev.elem(3, 9, -1.000000);   	prev.elem(3, 10, -0.000000);   	prev.elem(3, 11, -0.000000);   	prev.elem(3, 12, -0.000000);   	prev.elem(3, 13, 1.000000);   	prev.elem(3, 14, 0.000000);   	prev.elem(3, 15, 0.000000);   	prev.elem(3, 16, 0.000000);   	prev.val(3, 2.000000);
		prev.elem(4, 1, -0.000000);   	prev.elem(4, 2, -0.000000);   	prev.elem(4, 3, -0.000000);   	prev.elem(4, 4, -0.000000);   	prev.elem(4, 5, -2.000000);   	prev.elem(4, 6, -2.000000);   	prev.elem(4, 7, 2.000000);   	prev.elem(4, 8, 2.000000);   	prev.elem(4, 9, 0.000000);   	prev.elem(4, 10, 1.000000);   	prev.elem(4, 11, 0.000000);   	prev.elem(4, 12, 0.000000);   	prev.elem(4, 13, -0.000000);   	prev.elem(4, 14, 1.000000);   	prev.elem(4, 15, -0.000000);   	prev.elem(4, 16, -0.000000);   	prev.val(4, 3.000000);
		prev.elem(5, 1, 0.000000);   	prev.elem(5, 2, 0.000000);   	prev.elem(5, 3, 0.000000);   	prev.elem(5, 4, 0.000000);   	prev.elem(5, 5, 1.000000);   	prev.elem(5, 6, 0.000000);   	prev.elem(5, 7, -1.000000);   	prev.elem(5, 8, -0.000000);   	prev.elem(5, 9, -0.000000);   	prev.elem(5, 10, -0.000000);   	prev.elem(5, 11, -1.000000);   	prev.elem(5, 12, -0.000000);   	prev.elem(5, 13, 0.000000);   	prev.elem(5, 14, 0.000000);   	prev.elem(5, 15, 1.000000);   	prev.elem(5, 16, 0.000000);   	prev.val(5, -0.000000);
		prev.elem(6, 1, 0.000000);   	prev.elem(6, 2, 0.000000);   	prev.elem(6, 3, 0.000000);   	prev.elem(6, 4, 0.000000);   	prev.elem(6, 5, 0.000000);   	prev.elem(6, 6, 1.000000);   	prev.elem(6, 7, -0.000000);   	prev.elem(6, 8, -1.000000);   	prev.elem(6, 9, -0.000000);   	prev.elem(6, 10, -0.000000);   	prev.elem(6, 11, -0.000000);   	prev.elem(6, 12, -1.000000);   	prev.elem(6, 13, 0.000000);   	prev.elem(6, 14, 0.000000);   	prev.elem(6, 15, 0.000000);   	prev.elem(6, 16, 1.000000);   	prev.val(6, -0.000000);
		prev.coeff(1, 6.000000);		prev.coeff(2, 4.000000);		prev.coeff(3, 0.000000);		prev.coeff(4, 0.000000);		prev.coeff(5, 2.000000);		prev.coeff(6, 0.000000);		prev.coeff(7, -2.000000);		prev.coeff(8, 0.000000);		prev.coeff(9, -1.000000);		prev.coeff(10, 1.000000);		prev.coeff(11, -1.000000);		prev.coeff(12, -1.000000);		prev.coeff(13, 0.000000);		prev.coeff(14, 0.000000);		prev.coeff(15, 0.000000);		prev.coeff(16, 0.000000);		prev.fVal(15.000000);
	}

	prev.table();
	prev.vars();

	while (true)
	{

		Simplex current(prev);
		prev = current;
		prev.table();
		prev.vars();
		if (current.fVal() == prev.fVal())
			break;
	}

	return 0;
}
