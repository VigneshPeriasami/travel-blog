package commons

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
)

type DynamoDbClient struct {
	session *session.Session
}

func NewDynamoDbClient() *DynamoDbClient {
	session := session.Must(session.NewSession(&aws.Config{
		Region: aws.String("us-east-2"),
	}))
	return &DynamoDbClient{
		session: session,
	}
}

func (d *DynamoDbClient) GetClient() *dynamodb.DynamoDB {
	return dynamodb.New(d.session)
}
