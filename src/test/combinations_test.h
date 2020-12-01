#include <cxxtest/TestSuite.h>
#include "../main/combinations.h"
#include <iostream>

using namespace std;

class Combinations_test : public CxxTest::TestSuite {
public:
    void testAddition(void) {
        Combinations combinations(8, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", 2);
        cout << "start " << endl;

        for (unsigned long i = 0; i < 10; i++) {
            //combinations.next();
            //if (i % 10000000 == 0) {
                cout <<i << " "<< combinations.next() << endl;    
            //}
        }
    }
};