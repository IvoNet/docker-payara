# Payara Full server


The ful profile [Payara 5](https://www.payara.fish/) application server on a centos 7 java 1.8.0_191 base.

The images here are part of my maven archetype setup TODO


# Usage

```bash
docker run -d --name payara -p 8080:8080 -p 8181:8181 -p 4848:4848 -e $(pwd)/artifact:/autodeploy ivonet/payara:5.184
```

or in interactive mode: 

```bash
docker run -it --name payara -p 8080:8080 -p 8181:8181 -p 4848:4848 -e $(pwd)/artifact:/autodeploy ivonet/payara:5.184
```

This will run the server with all the relevant ports exposed and the ./artifact folder mounted to the inner /autodeploy folder.
If you put a war in the ./artifact folder it will be auto deployed to the server which would make testing easy as you do not need to create a new image every time to test your war.



## Admin Console

The default login for the [admin console](https://localhost:4848) is admin/secret
To change the password:

on a running container (started without --rm)
e.g.

```bash
echo "Starting parara with container name payara"
docker run -d --name payara -p 8080:8080 -p 8181:8181 -p 4848:4848 -e $(pwd)/artifact:/autodeploy ivonet/payara:latest
echo "Changing admin password..."
echo "Please follow instructions:"
docker exec -it payara asadmin --user admin change-admin-password
docker restart payara
```

Now the password has been changed for that container as long as that container lives.
New containers based on this image will again have the default password.

If you do not want to expose the admin console you can just omit to expose port 4848.


## Dockerfiles

For the Dockerfile definitions please look here:

* [ivonet-docker-images](https://github.com/IvoNet/ivonet-docker-images)


# ToDo

* run payara under user other than root
* create production version without autodeploy
* 
