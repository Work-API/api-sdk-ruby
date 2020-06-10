# api-sdk-ruby

# Development

In order to create or update specs that run against the live API you will need:

1. an account
2. an environment
3. the keys to the account
4. an Account Provider Token (APT) for the environment
5. a user associated with the environment

## An account

Visit https://dashboard.work-api.com/ and create an account.

## An environment

On the dashboard, create an environment.

## The keys to the account

When creating the environment, save the private and public keys to the `keys` directory.

## An Account Provider Token (APT) for the environment

To generate an APT, run `ENVIRONMENT_GUID=[your env guid] rake generate:apt`. A JSON file containing the token will be created at `tmp/tokens.json` directory and used by the test suite.

## A user associated with the environment

To create a new user in your environment, run `ENVIRONMENT_GUID=[the guid of your environment] rake user:create`. A JSON file containing the user info will be created at `tmp/user.json` and used by the test suite.
