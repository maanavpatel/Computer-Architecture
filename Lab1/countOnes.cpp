/**
 * @file
 * Contains an implementation of the countOnes function.
 */
unsigned countOnes(unsigned input) {

	//rm signifies right masks, lm for left //
	//rc signifies right counters, lc for left //

	//step 1
	unsigned rm = 0x55555555;
	unsigned lm = 0xAAAAAAAA;
	unsigned rc = input & rm;
	unsigned lc = input & lm;
	
	unsigned x = rc + (lc >> 1);

	//step 2
	unsigned rm2 = 0x33333333;
	unsigned lm2 = 0xCCCCCCCC;

	unsigned rc2 = x & rm2;
	unsigned lc2 = x & lm2;

	unsigned y = rc2 + (lc2 >> 2);

	//step 3
	unsigned rm3 = 0x0F0F0F0F;
	unsigned lm3 = 0xF0F0F0F0;

	unsigned rc3 = y & rm3;
	unsigned lc3 = y & lm3;

	unsigned z = rc3 + (lc3 >> 4);

	//step 4
	unsigned rm4 = 0x00FF00FF;
	unsigned lm4 = 0xFF00FF00;

	unsigned rc4 = z & rm4;
	unsigned lc4 = z & lm4;

	unsigned a = rc4 + (lc4 >> 8);

	//step 5
	unsigned rm5 = 0x0000FFFF;
	unsigned lm5 = 0xFFFF0000;

	unsigned rc5 = a & rm5;
	unsigned lc5 = a & lm5;

	unsigned b = rc5 + (lc5 >> 16);
	return b;
}
