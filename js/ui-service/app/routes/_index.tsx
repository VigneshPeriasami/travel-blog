import React from "react";
import { Link } from "@remix-run/react";
import { sayHello } from "core";
import { SaySomething } from "core/deep";

export default function App() {
  return (
    <>
      <h1>Landing Page {sayHello()}!!!!!</h1>
      <SaySomething name="Hey" job="free" />
      <ul>
        <li>
          <Link to="/home">Home</Link>
        </li>
        <li>
          <Link to="/outdoors">Outdoors</Link>
        </li>
      </ul>
    </>
  );
}
