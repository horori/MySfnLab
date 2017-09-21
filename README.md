# MySfnLab
Useful Scripts for Sparkle Formation to generate CloudFormation JSON template easily.

## Requirements
- [Ruby][1]
- Bundler - install Bundler using the `gem` command `gem install bundler`
- [Sparkleformation][3] - install SparkleFormation using the `gem` command `gem install sfn`
- [sfn-lambda][4] - SparkleFormation Callback adds method to create templates for Lambda.

--
[1]: https://www.ruby-lang.org/en/documentation/installation/
[2]: https://github.com/hw-labs/batali
[3]: http://www.sparkleformation.io/docs/
[4]: https://github.com/sparkleformation/sfn-lambda

## Sparkleformation & CloudFormation
[Sparkleformation](http://www.sparkleformation.io/docs/sfn/overview.html) is a great tool to generate CloudFormation template easy by using Ruby.

Here's a few commands to get you started:

``` bash
bundle update
bundle exec sfn print -file step1ec2
bundle exec sfn print -file step2lambda
bundle exec sfn print -file step3custom
``` 

## Info

* Repository: https://github.com/horori/MySfnLab
