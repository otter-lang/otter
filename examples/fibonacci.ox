// https://en.wikipedia.org/wiki/Fibonacci_number

function fibonacci(number: int): int
{
    if (number <= 1)
        return number;

    return (fibonacci(number - 1) + fibonacci(number - 2));
}