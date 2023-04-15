Shortify - a personal url shortener
====================================

Shortify is a 100% cloud based URL shortener service which makes it simple to
remember long- and hard-to-reach URLs.

The entire service is deployed on AWS using Terraform and uses different AWS
services such as API Gateway, AWS Lambda and DynamoDB.

Table Of Contents
=================
- [Shortify - a personal url shortener](#shortify---a-personal-url-shortener)
- [Table Of Contents](#table-of-contents)
- [Background](#background)
- [Description](#description)
- [Installation](#installation)
  - [Requirements](#requirements)
  - [Steps](#steps)
- [Related](#related)
  - [Shortify-Alfred](#shortify-alfred)

Background
==========

This project was inspired by
[goalie-url-shortener](https://github.com/AxisCommunications/goalie-url-shortener),
which in turn is inspired by the
[`go/`](https://web.archive.org/web/20200202103026/http://blog.goatcodes.com/2018/04/18/go-origin)
services deployed by companies such as Google. These services are used by
these companies internally as a way to shorten otherwise hard to remember
URLs. E.g. `go/payroll` would redirect to the payroll page.

What I wanted initially was to deploy such a service for personal use. There
are other repositories on Github that offer such a service, however all of
them are made to be deployed to servers.

Given my usage, having a VM always running would be too expensive compared to
the value it provides. Enter serverless functions and [AWS
Lambda](https://aws.amazon.com/lambda/). With it's pay-for-what-you-use
model, it fits my use case perfectly. I can have an always-ready service
running and paying only when I use it.


Description
===========

The entire infrastructure is documented in code using
[IaC](https://en.wikipedia.org/wiki/Infrastructure_as_code) tool
[Terraform](https://www.terraform.io/). API Gateway is used to expose
endpoints that will result in Lambda function invocations. The lambda
functions will then query the DynamoDB database for the desired shortcut, and
redirect the user there.

An S3 bucket and another DynamoDB table will also be used as a [remote
backend](https://www.terraform.io/docs/backends/types/s3.html) to maintain
the terraform [state](https://www.terraform.io/docs/state/index.html).

So in total the following AWS services are used (almost all of these have
[free tier](https://aws.amazon.com/free/) offerings):

* API Gateway
* 2x Lambda functions
* 2x DynamoDB tables
* 1x S3 bucket


Installation
============

Requirements
------------
* [Terraform](https://www.terraform.io/)

* AWS account credentials setup either as environment variables or in
`credentials` file. Read more
[here](https://www.terraform.io/docs/providers/aws/index.html#authentication).

See the instructions in [examples/example-deployment](examples/example-deployment/) for a full deployment example you can run.

Related
=======
Shortify-Alfred
---------------

[Shortify - Alfred](https://github.com/enniomara/shortify-alfred) is an
integration/workflow for [Alfred](https://www.alfredapp.com/) 3. Alfred is a
MacOS productivity tool similar to Spotlight. Shortcuts in Shortify can be
accessed by entering `Ctrl + Space` and then entering `sh `. It will list all
saved shortcuts and allow you to fuzzy-search them. See installation steps
[here](https://github.com/enniomara/shortify-alfred).
