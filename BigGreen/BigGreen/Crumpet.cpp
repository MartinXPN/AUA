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
	double price = calculatePrice();
	double price20 = price + (price * 0.2);
	return price20 - (price20 * 0.1);
}
