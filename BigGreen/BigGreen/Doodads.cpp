#include "Doodads.h"
#include <cmath>
using namespace std;

Doodads::Doodads(std::string name, int minAge) : Widget( name )
{
	this->minAge = minAge;
}

Doodads::Doodads(int minAge, std::string name) : Doodads( name, minAge )
{
}


Doodads::~Doodads()
{
}

int Doodads::getMinAge()
{
	return minAge;
}

void Doodads::setMinAge(int minAge)
{
	this->minAge = minAge;
}

double Doodads::calculatePrice()
{
	return double( ( abs(minAge) * ageFactor * static_cast <int>(std::pow( 2, name.length() ) ) ) % 100 );
}
