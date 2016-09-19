#include "Flubber.h"


Flubber::Flubber(std::string name, int distance) : Doodads( name )
{
	this->distance = distance;
	if (distance >= MIN_DISTANCE)
		minAge = -1;				/// no age restriction
}

Flubber::Flubber(std::string name, int distance, int minAge) : Doodads( name, minAge )
{
	this->distance = distance;
}

Flubber::~Flubber()
{
}

int Flubber::howFar()
{
	return distance;
}

std::string Flubber::style()
{
	return "Walk";
}

std::ostream & operator<<(std::ostream & stream, Flubber & item)
{
	stream << static_cast <Widget&> (item);
	if (item.minAge == -1)	stream << "Age unrestricted\n";
	else					stream << "Age: " << item.minAge << " and above\n";
	return stream;
}
