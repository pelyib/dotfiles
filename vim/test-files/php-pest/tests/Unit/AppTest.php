<?php

declare(strict_types=1);

namespace Neovim\Pest\Tests\Unit;

describe('App', function () {
    it('should return Hello, World!', function () {
        $app = new \Neovim\Pest\App();
        expect($app->run())->toBe('Hello, World!');
    });

    it('should return Hello and the given name', function () {
        $app = new \Neovim\Pest\App();
        expect($app->run('John'))->toBe('Hello, John!');
    });
});
