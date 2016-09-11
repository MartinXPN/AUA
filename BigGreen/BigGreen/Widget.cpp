#include "Widget.h"

Widget::Widget(std::string name)
{
	this->name = name;
}


Widget::~Widget()
{
}

std::string Widget::getName()
{
	return name;
}

void Widget::setName(std::string name)
{
	this->name = name;
}

std::ostream & operator<<(std::ostream & stream, Widget & item)
{
	return stream	<< "** Big Green Corp **\n"
					<< item.getName() << ": " << item.calculatePrice()
					<< "\n";
}
