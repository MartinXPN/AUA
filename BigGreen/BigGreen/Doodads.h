#pragma once
#include "Widget.h"

#ifndef DOODADS
#define DOODADS

class Doodads : public Widget
{
protected:
	int minAge;
	int ageFactor = 12;

public:
	Doodads(std::string name, int minAge = 2);
	Doodads(int minAge, std::string name = "BG Doodad");
	virtual ~Doodads() = 0;									/// =0 for making Doodas an abstract class

	int getMinAge();
	void setMinAge(int minAge);

	virtual double calculatePrice();
};


#endif // !DOODADS
