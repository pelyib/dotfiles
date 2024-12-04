import React, { useEffect, useState } from 'react';

const Title = () => {
    const [titleText, setTitleText] = useState('Banane');

    useEffect(() => {
        // A DOM teljes betöltése után cseréljük le a szöveget
        const handleLoad = () => {
            setTitleText('Neovim Javascript test app');
        };

        // Használjuk az `DOMContentLoaded` eseményt
        window.addEventListener('DOMContentLoaded', handleLoad);

        // Tisztítás: eltávolítjuk az eseményhallgatót, ha a komponens unmountolódik
        return () => {
            window.removeEventListener('DOMContentLoaded', handleLoad);
        };
    }, []);

    return <h1 data-testid="title">{titleText}</h1>;
};

export default Title;

