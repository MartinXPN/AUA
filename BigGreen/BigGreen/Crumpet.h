#pragma once
#include "Widget.h"

#ifndef CRUMPET
#define CRUMPET

/*
Crumpet is a subclass of Widget
it can be instantiated
*/
class Crumpet : public Widget
{
private:
	double markUpValue = 26.99;

protected:
	double manufacturingCost;	/// has to be provided by a user

public:
	/// Crumpet can only be constructed by providing both name and manufacturingCost
	Crumpet(std::string name, double manufacturingCost);
	~Crumpet();

	/// override calculatePrice inherited from Widget
	virtual double calculatePrice();
	/// define new method of calculating sale price + 20% - 10%
	double calculateSalePrice();
};


#endif // !CRUMPET
