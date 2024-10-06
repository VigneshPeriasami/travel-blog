import { Links, Meta, Outlet, Scripts } from '@remix-run/react';
import { useState, useEffect } from 'react';

const getName = () => {
    return 'helo';
};

const HomeComponent = () => {
    return (
        <div>
            <p>Hello!!!</p>
        </div>
    );
};

const Home = ({ message }: { message: string }) => {
    const [count, setCount] = useState(1);

    useEffect(() => {
        if (count == 1) {
            setCount(2);
        }
    }, [count]);
    return (
        <div>
            <p>
                Hello {message}- {count}
            </p>
        </div>
    );
};

export default function App() {
    return (
        <html>
            <head>
                <link rel="icon" href="data:image/x-icon;base64,AA" />
                <Meta />
                <Links />
            </head>
            <body>
                <h1>Hello world!</h1>
                <Home message="Hello tom" />
                <Outlet />

                <Scripts />
            </body>
        </html>
    );
}
