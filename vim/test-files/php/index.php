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
