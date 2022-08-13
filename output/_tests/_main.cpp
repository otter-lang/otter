#include <_tests/_main.hpp>
#include <_tests/_io.hpp>
#include <_tests/_tests.hpp>

long_t main_get_exit_code(void)
{
	return 0;
}

int main(void)
{
	global_writeln("Hello, World!");
	global_test();
	return main_get_exit_code();
}