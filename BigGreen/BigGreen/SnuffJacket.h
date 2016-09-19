#pragma once
#include "Crumpet.h"


#ifndef SNUFF_JACKET
#define SNUFF_JACKET

/*
SnuffJacket is a subclass of Crumpet
it can be instantiated
*/
class SnuffJacket : public Crumpet
{

protected:
	/// cutoff is declated protected in case one would need to change its value in one of the subclasses
	double cutoff = 26.99;

public:
	/// default constructor
	SnuffJacket();
	/// SnuffJacket can be constructed by providing a name and manufacturingCost
	SnuffJacket(std::string name, double manufacturingCost);
	~SnuffJacket();

	std::string sayHi();	/// say hi (return string)
	std::string sayBye();	/// say bye (return string)

	/// calculate price by adding a markUpValue to regular calculatePrice
	double calculatePrice(double markUpValue);
	
	// manufacturingCost < cutoff => calculatePrice(5.55)
	// else	super( calculatePrice() )
	virtual double calculatePrice();

	/// ostream operator for printing the object to a stream
	friend std::ostream& operator << (std::ostream& stream, SnuffJacket& item);
};

#endif // !SNUFF_JACKET