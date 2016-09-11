#include "SnuffJacket.h"

SnuffJacket::SnuffJacket() : Crumpet( "Snuffer Toy", 99.99 )
{
}

SnuffJacket::SnuffJacket(std::string name, double manufacturingCost) : Crumpet( name, manufacturingCost )
{
}

SnuffJacket::~SnuffJacket()
{
}

std::string SnuffJacket::sayHi()
{
	return "Good day fellow traveler";
}

std::string SnuffJacket::sayBye()
{
	return "Have a nice day";
}

double SnuffJacket::calculatePrice(double markUpValue)
{
	return Crumpet::calculatePrice() + markUpValue;
}

double SnuffJacket::calculatePrice()
{
	if (manufacturingCost < cutoff)	return calculatePrice(5.55);
	else							return Crumpet::calculatePrice();
}

std::ostream & operator<<(std::ostream & stream, SnuffJacket & item)
{
	stream << static_cast <Widget&> (item);
	stream << item.sayHi() << '\n';
	return stream;
}
