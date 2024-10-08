import express from 'express';
import passport from 'passport';
import morgan from 'morgan';

import jwt from 'jsonwebtoken';
import { JwtStrategy, DigestAuthStrategy } from './auth-strategy.js';
import { UserRecord } from './types.js';

// 24 hr
const TOKEN_EXPIRY_SECONDS = 86400;

const getAuthToken = (user: UserRecord): string => {
    return jwt.sign(user, 'secret', {
        issuer: 'vikki.localmachine.com',
        expiresIn: TOKEN_EXPIRY_SECONDS,
        audience: 'anybody',
        algorithm: 'HS256',
    });
};

passport.use(JwtStrategy);

passport.use(DigestAuthStrategy);

const app = express();
app.use(morgan('dev'));

app.get('/', async (_req, res) => {
    res.send('Hello from auth server, Yess!!!');
});

// curl -v --user vikki:password --digest "http://127.0.0.1:3000/authenticate"
app.get(
    '/login',
    passport.authenticate('digest', { session: false }),
    (req, res) => {
        res.setHeader('X-Auth-Subject', req.user.username);
        res.setHeader('X-Auth-Email', req.user.email);

        res.send({
            ...req.user,
            token: getAuthToken(req.user),
        });
    }
);

app.get(
    '/auth',
    passport.authenticate('jwt', { session: false }),
    (req, res) => {
        res.setHeader('X-Auth-Subject', req.user.username);
        res.setHeader('X-Auth-Email', req.user.email);
        // res.setHeader('X-Auth-Issuer', req.user.issuer);
        res.send(`Hi there!! ${JSON.stringify(req.user, null, 2)}`);
    }
);

app.listen(3000, () => {
    console.log('Running server in:', 3000);
});
