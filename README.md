# workspace
Basic DevEnv Setup to work from within the container

```
git clone https://github.com/asukiasyan/workspace.git && cd workspace/
docker build -t workspace . && docker run --name workspace -it -d workspace /bin/bash
```
