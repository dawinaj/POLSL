#include <string>
#include <iostream>

using namespace std;

class task
{
public:
	string todo = "";
	int date = 0;
	task() {}
	task(int d, string t)
	{
		date = d;
		todo = t;
	}
	~task() {}
	bool operator == (const task& obj)
	{
		return (date == obj.date && todo == obj.todo);
	}
	bool operator > (const task& obj)
	{
		return (date > obj.date);
	}
	bool operator < (const task& obj)
	{
		return (date < obj.date);
	}
	friend ostream& operator << (ostream& out, const task& obj)
	{
		out << "Date: " << obj.date << endl << "Task: " << obj.todo << endl;
		return out;
	}
};

class qel
{
public:
	task task;
	qel* next = nullptr;
	qel* prev = nullptr;
	qel() {}
	qel(int d, string t) : task(d, t) {}
	qel(const qel& old)
	{
		task = old.task;
		if (old.next != nullptr)
			next = new qel(*old.next);
	}
	~qel()
	{
		if (next != nullptr)
			delete next;
	}
	qel* drop_this()
	{
		if (next != nullptr)
			next->prev = prev;
		if (prev != nullptr)
			prev->next = next;
		qel* temp = next;
		next = nullptr;
		delete this;
		return temp;
	}
};

class queue
{
public:
	qel* first = nullptr;
	queue() { }
	queue(const queue& old)
	{
		if (old.first != nullptr)
			first = new qel(*old.first);
	}
	queue(queue&& old) noexcept
	{
		first = old.first;
		old.first = nullptr;
	}
	virtual ~queue()
	{
		if (first != nullptr)
			delete first;
	}
	queue& operator=(const queue& old)
	{
		empty();
		if (old.first != nullptr)
			first = new qel(*old.first);
		return *this;
	}
	queue& operator=(queue&& old) noexcept
	{
		swap(first, old.first);
		return *this;
	}
	virtual qel* addTask(int d = 0, string t = "")
	{
		if (first == nullptr)
		{
			first = new qel(d, t);
			return first;
		}
		else
		{
			qel* temp = first;
			while (temp->next != nullptr)
				temp = temp->next;
			temp->next = new qel(d, t);
			temp->next->prev = temp;
			return temp->next;
		}
	}
	queue& operator+=(const task& rhs)
	{
		this->addTask(rhs.date, rhs.todo);
		return *this;
	}
	void empty()
	{
		if (first != nullptr)
			delete first;
		first = nullptr;
	}
	void print()
	{
		if (first == nullptr)
			cout << "Empty queue." << endl;
		else
		{
			qel* temp = first;
			while (temp)
			{
				cout << temp->task;
				temp = temp->next;
			}
		}
		cout << endl;
	}
	bool contains(const task& obj)
	{
		qel* iter = first;
		while (iter)
		{
			if (iter->task == obj)
				return true;
			iter = iter->next;
		}
		return false;
	}
	qel* where(const task& obj)
	{
		qel* iter = first;
		while (iter)
		{
			if (iter->task == obj)
				return iter;
			iter = iter->next;
		}
		return nullptr;
	}
	friend ostream& operator << (ostream& out, const queue& obj)
	{
		if (obj.first == nullptr)
			out << "Empty queue." << endl;
		else
		{
			qel* temp = obj.first;
			while (temp)
			{
				out << temp->task;
				temp = temp->next;
			}
		}
		out << endl;
		return out;
	}
	friend istream& operator >> (istream& in, queue& obj)
	{
		int d;
		string t;
		cout << "Enter date" << endl;
		in >> d;
		cout << "Enter task" << endl;
		in >> t;
		obj.addTask(d, t);
		return in;
	}
};

class sorted_q : public queue
{
public:
	sorted_q() {}
	sorted_q(const sorted_q& old) : queue(old) {}
	sorted_q(sorted_q&& old) noexcept
	{
		first = old.first;
		old.first = nullptr;
	}
	virtual ~sorted_q() {}
	sorted_q& operator=(const sorted_q& old)
	{
		empty();
		if (old.first != nullptr)
			first = new qel(*old.first);
		return *this;
	}
	sorted_q& operator=(sorted_q&& old) noexcept
	{
		swap(first, old.first);
		return *this;
	}
	qel* addTask(int d = 0, string t = "")
	{
		if (first == nullptr)
		{
			first = new qel(d, t);
			return first;
		}
		else
		{
			qel* obj = new qel(d, t);
			if (obj->task < first->task)
			{
				obj->next = first;
				obj->next->prev = obj;
				first = obj;
			}
			else
			{
				qel* iter = first;
				while (iter->next && obj->task > iter->next->task)
					iter = iter->next;
				obj->next = iter->next;
				iter->next = obj;
				obj->prev = iter;
			}
			return obj;
		}
	}
	friend ostream& operator << (ostream& out, const sorted_q& obj)
	{
		if (obj.first == nullptr)
			out << "Empty queue." << endl;
		else
		{
			qel* temp = obj.first;
			while (temp)
			{
				out << temp->task;
				temp = temp->next;
			}
		}
		out << endl;
		return out;
	}
	friend istream& operator >> (istream& in, sorted_q& obj)
	{
		int d;
		string t;
		cout << "Enter date" << endl;
		in >> d;
		cout << "Enter task" << endl;
		in >> t;
		obj.addTask(d, t);
		return in;
	}
	void complete(queue& cmpl)
	{
		qel* iter = cmpl.first;
		while (iter)
		{
			while (contains(iter->task))
			{
				qel* pos = where(iter->task);
				if (first == pos)
					first = pos->next;
				pos->drop_this();
			}
			iter = iter->next;
		}
	}
};


int main()
{
	sorted_q q;
	q.print();
	q.addTask(123, "xdddd");
	q.addTask(123, "xdddd");
	q.addTask(1, "sthwong");
	q.addTask(75, "yes");
	q.addTask(75, "yes");
	q.addTask(75, "yes");
	q.addTask(1024, "lmao");
	q.addTask(-42, "yeet");
	q.addTask(-42, "yeet");
	q.addTask(-42, "yeet");
	cout << q;


	queue cpl;
	cpl.addTask(75, "yes");
	cpl.addTask(-42, "yeet");
	cpl.addTask(1024, "lmao");

	cout << cpl;

	q.complete(cpl);

	cout << q;
}

