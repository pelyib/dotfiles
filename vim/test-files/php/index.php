<?php

declare(strict_types=1);

class Foo
{
    public function bar(): void
    {
    }
}

$a = new Foo();
$a->bar();

$b = new DateTime();
echo $b->format(DateTimeInterface::RFC3339) . PHP_EOL . PHP_EOL;
