import React, { useEffect, useState } from "react";

const Title = () => {
  const [titleText, setTitleText] = useState("Banane");

  useEffect(() => {
    const handleLoad = () => {
      setTitleText("Neovim Javascript test app");
    };

    window.addEventListener("DOMContentLoaded", handleLoad);

    return () => {
      window.removeEventListener("DOMContentLoaded", handleLoad);
    };
  }, []);

  return <h1 data-testid="title">{titleText}</h1>;
};

export default Title;
