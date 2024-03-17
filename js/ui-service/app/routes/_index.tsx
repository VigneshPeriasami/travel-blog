import React from "react";
import { Link } from "@remix-run/react";

export default function App() {
  return (
    <>
      <h1>Landing Page</h1>
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
