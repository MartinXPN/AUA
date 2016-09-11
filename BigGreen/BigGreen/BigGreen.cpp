#include "Flubber.h"
#include "BunniePaw.h"
#include "SnuffJacket.h"

#include <iostream>
#include <cstdio>
using namespace std;


/// TEST
int main()
{
	// Doodads doodasObject = Doodads( "Name" ); -> compile error because Doodads is an abstract class
	// Widget widgetObject = Widget( "Name" );   -> compile error because Widget is an abstract class
	Crumpet crumpetObject = Crumpet("Name", 10);
	cout << crumpetObject.getName() << endl;			/// prints Name
	cout << crumpetObject.calculateSalePrice() << endl;	/// prints 39.9492
	cout << crumpetObject << endl;

	SnuffJacket snuffObject = SnuffJacket("Snuff", 100);
	cout << snuffObject.sayHi() << endl;				/// prints Good day fellow traveler
	cout << snuffObject << endl;

	Flubber flubberObject = Flubber("Flub", 200);
	cout << flubberObject.calculatePrice() << endl;
	cout << flubberObject << endl;

	BunniePaw bunnieObject = BunniePaw("Bun", 10);
	cout << bunnieObject << endl;

    return 0;
}