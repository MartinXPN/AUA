#pragma once
#include <string>
#include <ostream>

#ifndef WIDGET
#define WIDGET

class Widget
{
protected:
	std::string name;

public:
	Widget( std::string name);
	virtual ~Widget() = 0;	// Widget is an abstract class and cannot have an instance

	std::string getName();	
	void setName(std::string name);

	friend std::ostream& operator << ( std::ostream& stream, Widget& item );
	virtual double calculatePrice() = 0;
};

#endif // !WIDGET