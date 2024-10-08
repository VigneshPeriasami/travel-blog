package home

import (
	"log"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/vigneshperiasami/backend-server/pkg/commons"
)

type Repo struct {
	dynamoClient *commons.DynamoDbClient
	logger       *log.Logger
}

func NewRepo(client *commons.DynamoDbClient, logger *log.Logger) *Repo {
	return &Repo{
		dynamoClient: client,
		logger:       logger,
	}
}

func (r *Repo) readAllTables() ([]string, error) {
	result, err := r.dynamoClient.GetClient().ListTables(&dynamodb.ListTablesInput{})

	if err != nil {
		return nil, err
	}

	tables := []string{}

	for _, v := range result.TableNames {
		tables = append(tables, *v)
	}

	return tables, nil
}

func (r *Repo) insertPrimaryUser() {
	item := map[string]*dynamodb.AttributeValue{}
	item["username"] = &dynamodb.AttributeValue{
		S: aws.String("vikki"),
	}
	item["password"] = &dynamodb.AttributeValue{
		S: aws.String("password"),
	}
	output, err := r.dynamoClient.GetClient().PutItem(&dynamodb.PutItemInput{
		Item:      item,
		TableName: aws.String("user_test_01"),
	})

	if err != nil {
		r.logger.Printf("Error inserting record: %s", err.Error())
		return
	}

	r.logger.Printf("Insert complete: %s", output.String())
}
