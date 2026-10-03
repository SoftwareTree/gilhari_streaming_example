# Creating a docker image for a simple RESTful server, which provides 
# the functionality of JSON objects persistence, starting with a base image
# (gilhari) that already has jdxnode_rest_server installed
# and the appropriate environment varaibles (JX_HOME, NODE_PATH) set.

FROM softwaretree/gilhari
#FROM gilhari:0.8
WORKDIR /opt/gilhari_streaming_example

# The build context is the project root (see gilhari/build.cmd and build.sh:
# docker build -f gilhari/Dockerfile .), so the ADD source paths below are
# relative to the project root, not to this gilhari/ directory.
ADD bin ./bin
ADD config ./config
ADD gilhari/gilhari_service.config .

EXPOSE 8081 
CMD ["node", "/node/node_modules/gilhari_rest_server/gilhari_rest_server.js",  "gilhari_service.config"]
