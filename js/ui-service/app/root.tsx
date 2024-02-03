import React from "react";
import { Links, Meta, Outlet, Scripts, LiveReload } from "@remix-run/react";

export default function App() {
  return (
    <html>
      <head>
        <link rel="icon" href="data:image/x-icon;base64,AA" />
        <Meta />
        <Links />
      </head>
      <body>
        <p>Part of the ship</p>
        <Outlet />
        <Scripts />
        <LiveReload />
      </body>
    </html>
  );
}
