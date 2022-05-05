# Payara Full server


The full profile [Payara 5](https://www.payara.fish/) application server on a centos 7 java 11 base.

The images here are part of my [maven archetype setup](https://ivonet.github.io/archetype/)

# Exposed Ports

| Port number | Description                                               |
|:------------|:----------------------------------------------------------|
| 8080        | internal address where the server runs                    |
| 4848        | internal address where the admin panel can be accessed.   |
| 8181        | internal address where the self signed https version runs |  

# Volumes

| Volume path                                      | Description                                                                                                     |
|:-------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| /opt/payara/glassfish/domains/domain1/autodeploy | The auto deploy folder for web archives (war) can be accessed in a Dockerfile with the `${DEPLOY_DIR}` variable |

# Environment variables

| Variable name    | Description                                                                                   | Default      |
|:-----------------|:----------------------------------------------------------------------------------------------|:-------------|
| ADMIN_PASSWORD   | The admin password for [http://localhost:4848](http://localhost:4848). | \<generated> |



# Usage

```bash
docker run                                                               \
    -d                                                                   \
    --name payara                                                        \
    -p 8080:8080                                                         \
    -p 4848:4848                                                         \
    -e ADMIN_PASSWORD=s3cr3t                                             \
    -v $(pwd)/artifact:/opt/payara/glassfish/domains/domain1/autodeploy  \
    ivonet/payara
```

or in interactive mode: 

```bash
docker run                                                              \
   -it                                                                  \
   --name payara                                                        \
   -p 8080:8080                                                         \
   -p 8181:8181                                                         \
   -p 4848:4848                                                         \
   -v $(pwd)/artifact:/opt/payara/glassfish/domains/domain1/autodeploy  \
   ivonet/payara
```

This will run the server with all the relevant ports exposed and the ./artifact folder mounted to the inner `/opt/payara/payara5/glassfish/domains/domain1/autodeploy` folder.
If you put a war in the ./artifact folder it will be auto deployed to the server which would make testing easy as you do not need to create a new image every time to test your war.


## Admin Console


```bash
echo "Starting parara with container name payara"
docker run -d --name payara -p 8080:8080 -p 8181:8181 -p 4848:4848 -e ADMIN_PASSWORD=secret -v $(pwd)/artifact:/opt/payara/payara5/glassfish/domains/domain1/autodeploy ivonet/payara:latest
```
Now the password has been changed for that container as long as that container lives.

If you do not want to expose the admin console you can just omit to expose port 4848.


