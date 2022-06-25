// https://en.wikipedia.org/wiki/Factorial

function factorial(number: int): int
{
    if (number == 0)
        return 1;

    return (number * factorial(number - 1));
}