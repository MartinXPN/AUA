#pragma once
#include "Widget.h"

#ifndef DOODADS
#define DOODADS

/*
Doodads is a subclass of Widget.
It's an abstract class (cannot have an instance)
*/
class Doodads : public Widget
{
protected:
	int minAge;				/// minimum age of Doodads
	int ageFactor = 12;		/// age factor (can be modified in subclasses)

public:
	/// Doodads can be constructed with a default minAge = 2
	Doodads(std::string name, int minAge = 2);
	/// Doodads can be constructed with a default name = "BG Doodad"
	Doodads(int minAge, std::string name = "BG Doodad");
	virtual ~Doodads() = 0;									/// =0 for making Doodas an abstract class

	/// getter for minAge
	int getMinAge();
	/// setter for minAge
	void setMinAge(int minAge);

	/// override the calculatePrice method inherited from Widget
	/// ( |minAge| * ageFactor * 2^len(name) )%100
	virtual double calculatePrice();
};


#endif // !DOODADS
