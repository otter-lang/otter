#include <modules/global.hpp>

int_t global_magic(void)
{
	return 0;
}

int main(void)
{
	int_t global_main_code = global_magic();
	return global_main_code;
}