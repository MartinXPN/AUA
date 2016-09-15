#pragma once
#include "Doodads.h"

#ifndef FLUBBER
#define FLUBBER

/*
Fluber is a subclass of Doodads which can be instantiated
*/
class Flubber : public Doodads
{
private:
	const int MIN_DISTANCE = 5;		/// mininum distance set to 5
	int distance;					/// distance provided by a user
public:
	/// Flubber can be constructed by providing a name and a distance
	Flubber(std::string name, int distance);
	/// Flubber can be constructed by providing a name, a distance, and a minimum age
	Flubber(std::string name, int distance, int minAge);

	~Flubber();

	int howFar();			/// user-provided distance
	std::string style();	/// "Walk"

	/// ostream operator for printing the object to a stream
	friend std::ostream& operator << (std::ostream& stream, Flubber& item);
};

#endif // !FLUBBER
