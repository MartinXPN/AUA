#pragma once
#include "Doodads.h"

#ifndef BUNNIE_PAW
#define BUNNIE_PAW

class BunniePaw : public Doodads
{
public:
	BunniePaw(std::string name, int minAge = 2);
	BunniePaw(int minAge, std::string name = "BG Doodad");
	~BunniePaw();

	int howFar();
	std::string style();
	double calculatePrice(int val);

	friend std::ostream& operator << (std::ostream& stream, BunniePaw& item);
};


#endif // !BUNNIE_PAW
