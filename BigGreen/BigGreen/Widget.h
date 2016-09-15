#pragma once
#include <string>
#include <ostream>

#ifndef WIDGET
#define WIDGET

/*
Widget is an abstract class (cannot have an instance)
*/
class Widget
{
protected:
	std::string name;

public:
	/// Widget can only be constructed by providing a name
	Widget( std::string name);

	/// Destructor of a Widget class is virtual in order to have a correct lifecycle when creating a pointer of a child class
	/// ( Widget* ptr = new ChildClass(); )
	/// if the destructor wasn't virtual the destructor of ChildClass wouldn't be called
	virtual ~Widget() = 0;	// Widget is an abstract class and cannot have an instance

	/// getter for variable name
	std::string getName();
	/// setter for variable name
	void setName(std::string name);

	/// ostream operator for printing the object to a stream
	friend std::ostream& operator << ( std::ostream& stream, Widget& item );

	/// abstract function calculatePrice (has to be implemented by subclasses)
	virtual double calculatePrice() = 0;
};

#endif // !WIDGET