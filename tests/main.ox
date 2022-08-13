module main;

long get_exit_code() => 0;

int main()
{
    writeln("Hello, World!");

    // Start the tests.
    test();

    return get_exit_code();
}