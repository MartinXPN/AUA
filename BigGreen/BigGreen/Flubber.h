#pragma once
#include "Doodads.h"

#ifndef FLUBBER
#define FLUBBER

class Flubber : public Doodads
{
private:
	const int MIN_DISTANCE = 5;
	int distance;
public:
	Flubber(std::string name, int distance);
	Flubber(std::string name, int distance, int minAge);
	~Flubber();

	int howFar();
	std::string style();

	friend std::ostream& operator << (std::ostream& stream, Flubber& item);
};

#endif // !FLUBBER
