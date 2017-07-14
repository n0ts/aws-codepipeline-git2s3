# aws-codepipeline-git2s3

- This repository is [Integrating Git with AWS CodePipeline](https://aws.amazon.com/blogs/devops/integrating-git-with-aws-codepipeline/) porting another region.

## How to a AWS CloudFormation stack via aws-cli

1. Set AWS environtment variables for aws-cli
  ```
$ export AWS_ACCESS_KEY_ID=<ACCESS KEY>
$ export AWS_SECRET_ACCESS_KEY=<SECRET KEY>
$ export AWS_DEFAULT_REGION=<REGION>
  ```

2. Create the AWS CloudFormation stack. <BUCKET> must be unique name.
  ```
$ ./create.sh <BUCKET>
  {
    "StackId": "arn:aws:cloudformation:<REGION>:<ACCOUNT ID>:stack/Git2CodePipeline/<STACK ID>"
  }
  ```

### for GitHub Enterprise

1. Add Webook from Hooks & services
   - Payload URL: The value of outputs for the output key is `ZipDownloadWebHookApi` in `Git2CodbePipeline` stack
   - Secret: Any secret key

2. Update `Git2CodbePipeline` stack.
   - Select Template: Use current template
   - Paramers
       - ApiSecret: The value of webhook secret in GitHub Enterprise
       - GitToken: The value of personal access token in GitHub Enterprise

3. Test
   - Push the test code in GitHub Enterprise
   - Check S3 bucket, Bucket name is the value of outputs for the output key is `OutputBucketName` in `Git2CodbePipeline` stack
