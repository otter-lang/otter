module tests.main;

version (Windows) import tests.windows_hello;
version (Linux  ) import tests.linux_hello  ;

i32 main()
{
    hello();
    return 0;
}