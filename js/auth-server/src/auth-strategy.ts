import { Strategy } from 'passport-jwt';
import { getUserCredential, getUser } from './dynamodb.js';
import { ExtractJwt } from 'passport-jwt';
import { DigestStrategy } from 'passport-http';

export const JwtStrategy = new Strategy(
    {
        jwtFromRequest: ExtractJwt.fromExtractors([
            ExtractJwt.fromAuthHeaderAsBearerToken(),
        ]),
        secretOrKey: 'secret',
        issuer: 'vikki.localmachine.com',
        audience: 'anybody',
        ignoreExpiration: false,
    },
    function (jwtPayload, done) {
        getUser(jwtPayload.username)
            .then((res) => {
                done(null, res);
            })
            .catch(() => done(null, false));
    }
);

export const DigestAuthStrategy = new DigestStrategy(
    { qop: 'auth', realm: 'mock users' },
    function (username, cb) {
        getUserCredential(username)
            .then((credential) =>
                cb(null, credential.user, credential.password)
            )
            .catch((e) => cb(e, false));
    },
    (params, done) => {
        if (params.nonce) {
            // todo: validate nonce
        }
        done(null, true);
    }
);
