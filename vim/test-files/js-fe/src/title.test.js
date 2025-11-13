import React from "react";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";
import Title from "./title";

describe("Title test", () => {
  it("title is correct", () => {
    render(<Title />);
    expect(screen.getByTestId("title")).toBeInTheDocument();
  });
});
