import express from 'express';
import passport from 'passport';
import morgan from 'morgan';
import { Strategy as JwtStrategy, ExtractJwt } from 'passport-jwt';
import { DigestStrategy } from 'passport-http';
import jwt from 'jsonwebtoken';

const userItself = {
    id: '1234567',
    username: 'vikki',
    email: 'mail2vikki@gmail.com',
    exp: Math.floor(Date.now() / 1000) + 86400,
};

const tokenUserMap = {
    '1234567': {
        id: '1234567',
        username: 'vikki',
        email: 'mail2vikki@gmail.com',
    },
};

const userCreds = {
    vikki: 'password',
};

passport.use(
    new JwtStrategy(
        {
            jwtFromRequest: ExtractJwt.fromExtractors([
                ExtractJwt.fromAuthHeaderAsBearerToken(),
            ]),
            secretOrKey: 'secret',
            issuer: 'vikki.localmachine.com',
            audience: 'anybody',
        },
        function (jwtPayload, done) {
            console.log('incoming', jwtPayload);
            if (jwtPayload.id in tokenUserMap) {
                return done(null, userItself);
            }
            return done(null, false);
        }
    )
);

passport.use(
    new DigestStrategy(
        { qop: 'auth', realm: 'mock users' },
        function (username, cb) {
            if (username in userCreds) {
                return setTimeout(() => {
                    cb(
                        null,
                        userItself,
                        userCreds[username as keyof typeof userCreds]
                    );
                }, 3000);
            }
            return cb(null, false);
        },
        (params, done) => {
            if (params.nonce) {
                // todo: validate nonce
            }
            done(null, true);
        }
    )
);

const app = express();
app.use(morgan('dev'));

app.get('/', (_req, res) => {
    res.send('Hello from auth server');
});

// curl -v --user vikki:password --digest "http://127.0.0.1:3000/authenticate"
app.get(
    '/login',
    passport.authenticate('digest', { session: false }),
    (req, res) => {
        res.send({
            ...req.user,
            token: jwt.sign(req.user, 'secret', {
                issuer: 'vikki.localmachine.com',
                audience: 'anybody',
                algorithm: 'HS256',
            }),
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
        res.send(`Hi there!! ${req.user}`);
    }
);

app.listen(3000, () => {
    console.log('Running server in:', 3000);
});
