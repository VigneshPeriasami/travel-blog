import { Outlet } from "@remix-run/react";
import React from "react";

export default function Auth() {
  return (
    <div>
      <p>Part of the crew</p>
      <Outlet />
    </div>
  );
}
