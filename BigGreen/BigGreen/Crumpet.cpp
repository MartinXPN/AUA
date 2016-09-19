#include "Crumpet.h"

Crumpet::Crumpet(std::string name, double manufacturingCost) : Widget( name )
{
	this->manufacturingCost = manufacturingCost;
}

Crumpet::~Crumpet()
{
}

double Crumpet::calculatePrice()
{
	return manufacturingCost + markUpValue;
}

double Crumpet::calculateSalePrice()
{
	double price = calculatePrice();		/// get current price
	double price20 = price + (price * 0.2);	/// get + 20% of the price
	return price20 - (price20 * 0.1);		/// get - 10% of the price
}
