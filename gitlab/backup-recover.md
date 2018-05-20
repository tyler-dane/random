# Backup

How to automatically send GitLab backups to AWS S3

### References:
- https://coderuse.com/2016/09/Configure-GitLab-Backup-Into-Amazon-S3/ 
- https://docs.gitlab.com/ce/raketasks/backup_restore.html#uploading-backups-to-a-remote-cloud-storage 
- https://cloudkul.com/blog/automate-gitlab-backups-within-amazon-s3-bucket/
- http://cobwwweb.com/backup-gitlab-data-and-repositories-to-amazon-s3 

## AWS Configuration
### Create S3 Bucket
* Sign in to your [AWS S3 homepage](https://s3.console.aws.amazon.com/s3/home)
* Click `Create Bucket`
    * It's a good idea to review the AWS's [Bucket Name Restrictions](http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html). 
    * To illustrate why you should use DNS-friendly Bucket names, here is an error message I received when attempting to send a GitLab backup to a bucket with '.'s in the bucket name:
    ```ruby
    Uploading backup archive to remote storage gitlab.example.com ... [fog][WARNING] fog: the specified s3 bucket name(gitlab.example.com) contains a '.' so is not accessible over https as a virtual hosted bucket, which will negatively impact performance.  For details see: http://docs.amazonwebservices.com/AmazonS3/latest/dev/BucketRestrictions.html
    rake aborted!
    ```
* Bucket name: `gitlab-backup-example`
* Region: `Asia Pacific (Sydney)`
* `Next`
* `Tags` > `Add Tag`  (optional)
    * Key: backup
    * Value: gitlab
* `Next`
* Finish
#### Add Lifecycle rule to bucket:
* Open bucket > `Management` > `Add lifecycle rule`
* Enter rule name (e.g., `TransitionToGlacierRule`)
* (Fill out transition period and other settings to your liking)


#### Create Permissions Policy:
* From the AWS [IAM console dashboard](https://console.aws.amazon.com/iam/home), click `Policies` > `Create policy` > `Create Your Own Policy`
* Policy Name: `GitLab-Backups`
* Description: 
* Create policy using JSON formatting:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::gitlab.example.local",
                "arn:aws:s3:::gitlab.example.local/*"
            ]
        }
    ]
}
```
* `Validate` to make sure formatting is correct
* `Create Policy`
* You should see a message saying, **GitLab-Backups has been created. You are now ready to attach your policy to users, groups, and roles.**

#### Create IAM user and attach GitLab-Backups policy
* https://console.aws.amazon.com/iam/home
* Users > Add user 
    * User name = `backup-gitlab`
    * Check `Programmatic access`
    * Next: `Permissions`
    * `Attach existing policies directly`
    * Check `GitLab-Backups`
    * Click `Next: Review`
    * `Create user`
    * Record the Access key ID and Secret access key
    * Downlad CSV and save in secure place

#### Attach IAM Policy to user:
* Click `backup-gitlab` from `Users` dashboard
* `Add permissions`
* `Attach existing policies directly`
* Search for `Backup`
* Check the box to the left of `GitLab-Backups`
* Click `Next:Review` > `Add permissions`
* `Add permissions`

### GitLab Configuration

#### Edit main configuration file   
`vim /etc/gitlab/gitlab.rb`
* This path applies to the Omnibus versions of GitLab
* Uncomment relevant lines and add information. See below for an example of the config file and further notes
* More details can be found in [GitLab's Documentation](https://docs.gitlab.com/ce/raketasks/backup_restore.html)

```ruby
### Backup Settings
###! Docs: https://docs.gitlab.com/omnibus/settings/backups.html

 gitlab_rails['manage_backup_path'] = true
 gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"

###! Docs: https://docs.gitlab.com/ce/raketasks/backup_restore.html#backup-archive-permissions
# gitlab_rails['backup_archive_permissions'] = 0644

# gitlab_rails['backup_pg_schema'] = 'public'

###! The duration in seconds to keep backups before they are allowed to be deleted
 gitlab_rails['backup_keep_time'] = 172800

 gitlab_rails['backup_upload_connection'] = {
   'provider' => 'AWS',
   'region' => 'us-east-1',
   'aws_access_key_id' => 'enter-your-access-key-id-here',
   'aws_secret_access_key' => 'enter-your-access-key-here'
 }
 gitlab_rails['backup_upload_remote_directory'] = 'your-AWS-bucket'
 gitlab_rails['backup_multipart_chunk_size'] = 104857600

###! **Turns on AWS Server-Side Encryption with Amazon S3-Managed Keys for
###!   backups**
 gitlab_rails['backup_encryption'] = 'AES256'


```
* To check the region of your AWS bucket, first navigate to your S3 home page in AWS:
https://s3.console.aws.amazon.com/s3/home
* Note the region under the Region column
* Then, go to [AWS's Regions List](https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region) and find the correct **Region** that corresponds to your **Region Name**
    * For example, **EU (London)** would be **eu-west-2**
* The `aws_access_key_id` and `aws_secret_access_key` entries were dispalyed when you initially created the IAM user. If you backed up those credentials to a CVS, they can also be found there.
* Replace `your-AWS-bucket` with the name of the AWS bucker that will hold your GitLab backups

#### Reconfigure GitLab to apply changes
`gitlab-ctl reconfigure`
* This command only applies to the Omnibus version of GitLab

#### Test creating a backup
`sudo gitlab-rake gitlab:backup:create`
* The backup should be uploaded to the `gitlab-backup-exmpale` bucket immediately after its created locally

# Disaster Recovery
----
### References:
* [Backing up and Restoring GitLab](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/raketasks/backup_restore.md)

* [GitLab High Availability](https://about.gitlab.com/high-availability/)

## Recommendations:
1.  Use the Omnibus version of GitLab instead of attempting to build from source. Here's why:
    * Unlike source-built versions of GitLab, there is adequate documentation for the Omnibus version. 
    * There is more community and enterprise support for the Omnibus package.
    * `rake` commands are simpler to run with Omnibus
    * New features (like remote backups) are more likely to be included in the Omnibus version first
    * Backup and restore operations are easier with Omnibus. 
2. Use off-site backups.
* This became easier, now that GitLab natively supports backups to 3rd parties like AWS and Rackspace.