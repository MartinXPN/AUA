#pragma once
#include "Widget.h"

#ifndef CRUMPET
#define CRUMPET

class Crumpet : public Widget
{
private:
	double markUpValue = 26.99;

protected:
	double manufacturingCost;

public:
	Crumpet(std::string name, double manufacturingCost);
	~Crumpet();

	virtual double calculatePrice();
	double calculateSalePrice();
};


#endif // !CRUMPET
