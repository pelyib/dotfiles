<?php

declare(strict_types=1);

class Foo
{
    public function __construct(private string $fruit) {

    }

    public function bar(): void
    {
    }
}

$a = new Foo(fruit: "banan");
$a->bar();

$b = new DateTime();
echo "<pre>";
echo $b->format(DateTimeInterface::RFC3339);
echo "</pre>";
