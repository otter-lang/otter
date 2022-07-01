#include <_tests/_test.hpp>

/*
	namespace: global
*/

void_t global_writeln(const char_t *global_writeln_content)
{
	puts(global_writeln_content);
}

/*
	namespace: main
*/

int main_main(void)
{
	global_writeln("hi");
	return 0;
}