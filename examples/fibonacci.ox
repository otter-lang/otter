// https://en.wikipedia.org/wiki/Fibonacci_number

int fibonacci(int number)
{
    if (number <= 1)
        return number;

    return (fibonacci(number - 1) + fibonacci(number - 2));
}