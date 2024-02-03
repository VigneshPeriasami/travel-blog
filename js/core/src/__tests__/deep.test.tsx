import React from "react";
import { render, screen } from "@testing-library/react";
import { SaySomething } from "../deep";

test("Mount", () => {
  render(<SaySomething name={"hello"} job="king" />);
  expect(screen.getByText(/hello/i)).not.toBeNull();
});
