import React, { useEffect } from "react";
import { useFetcher } from "@remix-run/react";

export default function Outdoors() {
  const fetcher = useFetcher();
  useEffect(() => {
    fetcher.submit(
      {
        user: "get me",
      },
      {
        method: "POST",
        action: "/data/user",
        encType: "application/json",
      }
    );
  }, []);
  return (
    <>
      This is outdoors
      <p>{JSON.stringify(fetcher.data)}</p>
    </>
  );
}
