#pragma once
#include "Doodads.h"

#ifndef BUNNIE_PAW
#define BUNNIE_PAW

/*
BunniePaw is a subclass of Doodads
it can be instantiated
*/
class BunniePaw : public Doodads
{
public:
	/// BunniePaw can be constructed with a default minimum age of 2
	BunniePaw(std::string name, int minAge = 2);
	/// BunniePaw can be constructed with a default name of "BG Doodad"
	BunniePaw(int minAge, std::string name = "BG Doodad");
	~BunniePaw();


	int howFar();					/// 4
	std::string style();			/// "Roll"
	double calculatePrice(int val);	/// val * howFar

	/// ostream operator for printing the object to a stream
	friend std::ostream& operator << (std::ostream& stream, BunniePaw& item);
};


#endif // !BUNNIE_PAW
