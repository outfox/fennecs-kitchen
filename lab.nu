docker run -it --rm -p 8888:8888 -v $"($env.PWD)/book:/home/jovyan/workspace" fennecs-kitchen jupyter lab --NotebookApp.default_url=/lab/ --ip=0.0.0.0 --port=8888
