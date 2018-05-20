# Troubleshooting

### LDAP
#### Problem 1: "Could not authenticate you from Ldapmain because "Ssl connect returned=1 errno=0 state=error: certificate verify failed"
`gitlab-rake gitlab:ldap:check --trace` shows:
```bash
[root@test2-gitlab gitlab]# gitlab-rake gitlab:ldap:check --trace
** Invoke gitlab:ldap:check (first_time)
** Invoke environment (first_time)
** Execute environment
** Execute gitlab:ldap:check
Checking LDAP ...

Server: ldapmain
rake aborted!
Net::LDAP::Error: SSL_connect returned=1 errno=0 state=error: certificate verify failed
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/net-ldap-0.16.0/lib/net/ldap/connection.rb:72:in `open_connection'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/net-ldap-0.16.0/lib/net/ldap/connection.rb:698:in `socket'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/net-ldap-0.16.0/lib/net/ldap.rb:1321:in `new_connection'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/net-ldap-0.16.0/lib/net/ldap.rb:713:in `block in open'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/net-ldap-0.16.0/lib/net/ldap/instrumentation.rb:19:in `instrument'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/net-ldap-0.16.0/lib/net/ldap.rb:711:in `open'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/net-ldap-0.16.0/lib/net/ldap.rb:644:in `open'
/opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/ldap/adapter.rb:7:in `open'
/opt/gitlab/embedded/service/gitlab-rails/lib/tasks/gitlab/check.rake:356:in `block in check_ldap'
/opt/gitlab/embedded/service/gitlab-rails/lib/tasks/gitlab/check.rake:352:in `each'
/opt/gitlab/embedded/service/gitlab-rails/lib/tasks/gitlab/check.rake:352:in `check_ldap'
/opt/gitlab/embedded/service/gitlab-rails/lib/tasks/gitlab/check.rake:341:in `block (3 levels) in <top (required)>'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/task.rb:250:in `block in execute'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/task.rb:250:in `each'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/task.rb:250:in `execute'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/task.rb:194:in `block in invoke_with_call_chain'
/opt/gitlab/embedded/lib/ruby/2.3.0/monitor.rb:214:in `mon_synchronize'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/task.rb:187:in `invoke_with_call_chain'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/task.rb:180:in `invoke'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:152:in `invoke_task'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:108:in `block (2 levels) in top_level'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:108:in `each'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:108:in `block in top_level'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:117:in `run_with_threads'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:102:in `top_level'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:80:in `block in run'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:178:in `standard_exception_handling'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/lib/rake/application.rb:77:in `run'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/rake-12.0.0/exe/rake:27:in `<top (required)>'
/opt/gitlab/embedded/bin/rake:23:in `load'
/opt/gitlab/embedded/bin/rake:23:in `<top (required)>'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/cli/exec.rb:74:in `load'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/cli/exec.rb:74:in `kernel_load'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/cli/exec.rb:27:in `run'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/cli.rb:332:in `exec'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/vendor/thor/lib/thor/command.rb:27:in `run'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/vendor/thor/lib/thor/invocation.rb:126:in `invoke_command'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/vendor/thor/lib/thor.rb:359:in `dispatch'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/cli.rb:20:in `dispatch'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/vendor/thor/lib/thor/base.rb:440:in `start'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/cli.rb:11:in `start'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/exe/bundle:34:in `block in <top (required)>'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/lib/bundler/friendly_errors.rb:100:in `with_friendly_errors'
/opt/gitlab/embedded/lib/ruby/gems/2.3.0/gems/bundler-1.13.7/exe/bundle:26:in `<top (required)>'
/opt/gitlab/embedded/bin/bundle:23:in `load'
/opt/gitlab/embedded/bin/bundle:23:in `<main>'
Tasks: TOP => gitlab:ldap:check

```

#### Potential Cause 1: LDAP configuration in `gitlab.rb` is not correct
* Sometimes GitLab introduces configuration changes with new versions. I experienced this error when updating from version 9.4 to 10.0. 

#### Troubleshooting: 
* Be sure to check the release notes and compare the `gitlab.rb.template` file with your version of `gitlab.rb`. 
    * Download the raw version of the most recent template: 
    ```bash
    wget https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template
    ```
    * Compare the template with your version:
    ```bash
    vimdiff gitlab.rb gitlab.rb.template
    ```
#### Potential Solution:
* This is what I had to do to resolve the LDAP errors:
    1. Deleted unnecessary LDAP configuration options from the file (e.g. the secondary LDAP option)
    2. Add the location to my `.crt` file to the `ca_file` field
    3. Set `verify_certificates` to `false`. See the [Release Notes](https://about.gitlab.com/2017/09/22/gitlab-10-0-released/#ldap-config-%22verify_certificates%22-defaults-to-secure) for notes on how this field changed in version 10 