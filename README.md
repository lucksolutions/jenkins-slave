# jenkins-slave

## Jenkins Setup
* The following property will need to be set using the http://<jenkins url>/script URL. See https://issues.jenkins-ci.org/browse/JENKINS-41384
```
jenkins.slaves.DefaultJnlpSlaveReceiver.disableStrictVerification=true
```