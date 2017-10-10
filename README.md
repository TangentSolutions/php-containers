PHP Containers
==============

Base PHP containers with added security.

## Versions

Currently we support **5.6**, **7.0**, and **7.1** versions.

## Security

These containers have a few extra configuration options for added security.

### Apache

By default the following config is in place:

```
ServerTokens Prod
ServerSignature Off
FileETag None
Header set X-XSS-Protection "1; mode=block"
```