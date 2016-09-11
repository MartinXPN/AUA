#pragma once
#include "Crumpet.h"


#ifndef SNUFF_JACKET
#define SNUFF_JACKET

class SnuffJacket : public Crumpet
{

protected:
	double cutoff = 26.99;

public:
	SnuffJacket();
	SnuffJacket(std::string name, double manufacturingCost);
	~SnuffJacket();

	std::string sayHi();
	std::string sayBye();

	double calculatePrice(double markUpValue);
	virtual double calculatePrice();

	friend std::ostream& operator << (std::ostream& stream, SnuffJacket& item);
};

#endif // !SNUFF_JACKET