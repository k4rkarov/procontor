<h3 align="center">Procontor</h3>
<h1 align="center"> <img src="https://github.com/k4rkarov/Procontor/blob/main/carbon.png" alt="procontor" width="500px"></h1>

The idea behind Procontor is to automate the creation of LUKS-encrypted containers for securing sensitive projects. This ensures that all data related to a specific project is protected with a password. Always remember to store your passwords securely, such as in a password vault like `keepassxc`.

Procontor not only creates the container but also automatically mounts it, providing a convenient and secure way for you to use it for storing your data.


# Download

```
  git clone https://github.com/k4rkarov/procontor && cd procontor
```

# Usage

```
$ ./procontor.sh
Usage:
  ./procontor.sh [OPTIONS]
Options:
  -h, --help             Show this help message
  -p, --project PROJECT  Specify the project name
  -s, --size SIZE        Specify the container size (e.g., 500M, 5G)
Description:
  Procontor is a Project Container Creator designed to create LUKS-encrypted containers for handling sensitive projects and subsequently mount them for further use. Please remember the password you've set for your container!
Note:
  The ideal container naming should follow these rules: it should have the client's name followed by the date of the project start. For instance: evilcorp_14-02-24
```

# Example

```
$ ./procontor.sh -p evilcorp_23-07-24 -s 200M
```
