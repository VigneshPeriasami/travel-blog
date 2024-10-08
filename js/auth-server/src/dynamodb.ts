import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand } from '@aws-sdk/lib-dynamodb';
import type { UserRecord } from './types.js';

const client = new DynamoDBClient({
    region: 'us-east-2',
});

const docClient = DynamoDBDocumentClient.from(client);

type UserCredential = {
    password: string;
    user: UserRecord;
};

export const getUserCredential = async (
    username: string
): Promise<UserCredential> => {
    const command = new GetCommand({
        TableName: 'user_test_01',
        Key: {
            username,
        },
    });

    const result = await docClient.send(command);
    if (!result.Item || !result.Item.password) {
        throw Error('No user record found');
    }
    return {
        password: result.Item.password,
        user: {
            username: result.Item.username,
            email: result.Item.email,
        },
    };
};

export const getUser = async (username: string): Promise<UserRecord> => {
    const response = await getUserCredential(username);
    return response.user;
};
