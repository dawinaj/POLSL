#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

int numlen = 8;

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
		if (coeff(x) == 0)
		{
			for (int t = 1; t <= height; t++)
			{
				yPos = 0;
				for (int y = 1; y <= height; y++)
				{
					yPos = t;
					if (!(y == t && elem(y, x) == 1 || y != t && elem(y, x) == 0))
					{
						yPos = 0;
						break;
					}
				}
				if (yPos)
					break;
			}
		}
		if (yPos)
			return val(yPos); // uuuh dirty
		else
			return 0;
	}
	int mx_coeff_indx() const
	{
		int maxcoeffI = max_element(coeffs.begin(), coeffs.end()) - coeffs.begin() + 1;
		double maxcoeffV = coeff(maxcoeffI);
		if (maxcoeffV > 0)
			return maxcoeffI;
		return 0;
	}
	int smallest_valdiv() const
	{
		int pivX = mx_coeff_indx();
		if (pivX > 0)
		{
			int pivY = 0;
			double minD = INFINITY;
			for (int y = 1; y <= height; y++)
				if (val(y) / elem(y, pivX) < minD && val(y) / elem(y, pivX) >= 0)
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
		cout << string((width+1)*(numlen+3), '=') << endl;
		for (int x = 1; x <= width; x++)
			cout << " " << pad(coeff(x)) << " |";
		cout << "| " << pad(fVal()) << endl << endl;
	}
	void vars() const
	{
		for (int x = 1; x <= width; x++)
		{
			cout << "x" << x << " = " << xval(x) << endl;
		}
		cout << "f(X) = " << fVal() << endl;
	}

	
	Simplex(const Simplex & obj)
	{
		width = obj.width;
		height = obj.height;
		body = obj.body;
		coeffs = obj.coeffs;
		values = obj.values;
		value = obj.value;

		int pivX = obj.mx_coeff_indx();
		int pivY = obj.smallest_valdiv();
		if (pivX > 0 && pivY > 0)
		{
			double pivVal = obj.elem(pivY, pivX);
			for (int y = 1; y <= height; y++)
			{
				if (y == pivY)
				{
					for (int x = 1; x <= width; x++)
						elem(pivY, x, obj.elem(pivY, x) / pivVal);
					val(y, val(pivY) / pivVal);
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
	Simplex prev(3, 7);
	{
		//elem(y, x, wartosc);
		prev.elem(1, 1, 1);	 prev.elem(1, 2, -1);	 prev.elem(1, 3, -1);	 prev.elem(1, 6, 1);
		prev.elem(2, 1, 1);	 prev.elem(2, 2, 2);	 prev.elem(2, 4, 1);
		prev.elem(3, 1, 1);	 prev.elem(3, 2, 1);	 prev.elem(3, 5, -1);	 prev.elem(3, 7, 1);

		//value (y, wartosc);
		prev.val(1, 1);
		prev.val(2, 6);
		prev.val(3, 2);

		//coeff(x, wartosc);
		prev.coeff(1, 2); prev.coeff(3, -1); prev.coeff(5, -1);

		// fVal (wartosc)
		prev.fVal(3);
	}

	prev.table();
	prev.vars();

	while (true)
	{
		Simplex current(prev);
		if (current.fVal() == prev.fVal())
			break;
		current.table();
		current.vars();
		prev = current;
	}

	cout << endl << endl << "Second phase:" << endl << endl;

	prev.resize(3, 5);

	prev.coeff(1, 0); prev.coeff(2, 0); prev.coeff(3, 0); prev.coeff(4, 0); prev.coeff(5, 0);

	prev.coeff(3, -1.5); prev.coeff(5, 2.5);

	prev.fVal(-3.5);


	prev.table();
	prev.vars();

	while (true)
	{
		Simplex current(prev);
		if (current.fVal() == prev.fVal())
			break;
		current.table();
		current.vars();
		prev = current;
	}

	return 0;
}
