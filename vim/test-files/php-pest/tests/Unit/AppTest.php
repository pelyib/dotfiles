<?php

declare(strict_types=1);

namespace Neovim\Pest\Tests\Unit;

it('should return Hello, World!', function () {
    $app = new \Neovim\Pest\App();
    expect($app->run())->toBe('Hello, World!');
});
