import { json } from "@remix-run/node";

export const action = async ({ request }: { request: any }) => {
  try {
    console.log(request);
    const j = await request.json();
    console.log(j);
  } catch (e) {
    console.error(e);
  }
  return json({
    username: "Some random guy",
  });
};
