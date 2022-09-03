#include <modules/std.console.hpp>
#include <modules/std.c.stdio.hpp>

void_t std_console_writeln(string_t std_console_writeln_message)
{
	puts(std_console_writeln_message);
}