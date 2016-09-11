#include "BunniePaw.h"


BunniePaw::BunniePaw(std::string name, int minAge) : Doodads( name, minAge )
{
}

BunniePaw::BunniePaw(int minAge, std::string name) : Doodads( minAge, name )
{
}

BunniePaw::~BunniePaw()
{
}

int BunniePaw::howFar()
{
	return 4;
}

std::string BunniePaw::style()
{
	return "Roll";
}

double BunniePaw::calculatePrice(int val)
{
	return val * howFar();
}

std::ostream & operator<<(std::ostream & stream, BunniePaw & item)
{
	stream << static_cast <Widget&> (item);
	stream	<< "For all Ages"
			<< '\n';
	return stream;
}
