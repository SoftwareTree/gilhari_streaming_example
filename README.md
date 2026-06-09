> **Note:** This file is written in Markdown and is best viewed with a Markdown viewer (e.g., GitHub, GitLab, VS Code, or a dedicated Markdown reader). Viewing it in a plain text editor may not render the formatting as intended.

Copyright (c) 2025 Software Tree

# Gilhari Streaming Example

> **Demonstrates streaming queries for efficient processing of large result sets**

Gilhari is a Docker-compatible microservice framework that provides RESTful Object-Relational Mapping (ORM) functionality for JSON objects with any relational database.

Remarkably, Gilhari automates REST APIs (POST, GET, PUT, DELETE, etc.) handling, JSON CRUD operations, and database schema setup — **no manual coding required**.

## About This Example

This repository contains an example showing how to use Gilhari's **streaming query** feature for efficiently retrieving large result sets in manageable chunks, reducing memory consumption and improving response times for queries that return many objects.

The example uses the base Gilhari docker image (softwaretree/gilhari) to easily create a new docker image (gilhari_streaming_example) that can run as a RESTful microservice (server) to persist and stream app specific JSON objects.

This example can be used **standalone as a RESTful microservice** or optionally with the ORMCP Server.

**Related:**
- **Basic example**: [gilhari_simple_example](https://github.com/SoftwareTree/gilhari_simple_example)
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples) - Comprehensive list of examples

**Note:** This example is also included in the Gilhari SDK distribution. If you have the SDK installed, you can use it directly from the `examples/gilhari_streaming_example` directory without cloning.

## Example Overview

The example showcases a JSON object model with one type of object: **Employee** (or **JSON_Employee**)

**Object Model Overview:**
- **JSON_Employee**: Simple employee object (same as gilhari_simple_example)
- **Attributes**: id (int), name (string), exempt (boolean), compensation (double), DOB (long/milliseconds)
- **Database Table**: Employee

### What Makes This Example Different?

This example demonstrates the **streaming query** feature for handling large result sets:

**Streaming Query Feature:**
- **startStream**: Initiates a streaming query and returns the first batch of objects
  - Implicitly starts a database transaction
  - Maintains a server-side cursor for efficient data retrieval
  - Specify `maxObjects` to control batch size
  
- **fetchMore**: Retrieves subsequent batches of objects from the stream
  - Continues from where the previous fetch left off
  - Specify `maxObjects` for each batch (or -1 for all remaining)
  - No need to repeat filter criteria
  
- **closeStream**: Closes the streaming query and releases resources
  - Implicitly closes the database transaction
  - Must be called to free server resources

**Key Benefits:**
- **Memory efficient**: Process large result sets without loading everything into memory
- **Better performance**: Stream objects as they're retrieved from the database
- **Controlled batching**: Fetch exactly the number of objects you need at a time
- **Transaction support**: All streaming operations within a single transaction
- **Reduced latency**: Start processing results before entire query completes

**When to Use Streaming:**
- Queries that return thousands or millions of objects
- Processing large datasets incrementally
- Building paginated interfaces
- Memory-constrained environments
- Real-time data processing pipelines

### Employee Object Structure
```json
{
  "id": 39,
  "name": "John39",
  "compensation": 54039.0,
  "exempt": true,
  "DOB": 381484800390
}
```

### Streaming Query Flow

```
1. startStream (maxObjects=2)  → Returns first 2 objects, keeps cursor open
2. fetchMore (maxObjects=3)    → Returns next 3 objects
3. fetchMore (maxObjects=-1)   → Returns all remaining objects
4. closeStream                 → Closes cursor and transaction
```

## Project Structure

```
gilhari_streaming_example/
├── src/                           # Container domain model classes
│   └── com/softwaretree/...       # JSON_Employee.java and base classes
├── config/                        # Configuration files
│   ├── gilhari_streaming_example.jdx # ORM specification
│   └── classnames_map_example.json
├── bin/                           # Compiled .class files
├── Dockerfile                     # Docker image definition
├── gilhari_service.config         # Service configuration
├── compile.cmd / .sh              # Compilation scripts
├── build.cmd / .sh                # Docker build scripts
├── run_docker_app.cmd / .sh       # Docker run scripts
├── curlCommandsPopulate.cmd / .sh # Sample data population scripts
└── curlCommandsStreamingSync.cmd / .sh # API testing scripts with streaming

```

## Source Code
The `src` directory contains the declarations of the underlying shell (container) classes (e.g., JSON_Employee) that are used to define the object-relational mapping (ORM) specification for the corresponding conceptual domain-specific JSON object model classes:

- **JSON_Employee class**: Simple shell (container) class (.java file) corresponding to the domain-specific JSON object model class (Container domain model class)
- **JDX_JSONObject**: Base class of the container domain model classes for handling persistence of domain-specific JSON objects
- **Container domain model classes**: Only need to define two constructors, with most processing handled by the JDX_JSONObject superclass

**Note:** Gilhari does not require any explicit programmatic definitions (e.g., ES6 style JavaScript classes) for domain-specific JSON object model classes. It handles the data of domain-specific JSON objects using instances of the container domain model classes and the ORM specification.

## Configurations

A declarative ORM specification for the domain-specific JSON object model classes and their attributes is defined in `config/gilhari_streaming_example.jdx` using the container domain model classes. This file defines the mappings between JSON objects and database tables.

**Key points:**
- Update the database URL and JDBC driver in this file according to your setup
- See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide` (.md or .html) for guides on configuring different databases
- The container domain model class (JSON_Employee) is defined as a subclass of the JDX_JSONObject class
- The ORM specification is identical to gilhari_simple_example; the streaming capability is built into the Gilhari framework

For comprehensive details on defining and using container classes and the ORM specification for JSON object models, refer to the **"Persisting JSON Objects"** section in the JDX User Manual.

### Docker Configuration

The `Dockerfile` builds a RESTful Gilhari microservice using:
- Base Gilhari image (softwaretree/gilhari)
- Compiled domain model (.class) files
- Configuration files including the ORM specification and a JDBC driver

### Service Configuration

The `gilhari_service.config` file specifies runtime parameters for the RESTful Gilhari microservice:

```json
{
  "gilhari_microservice_name": "gilhari_streaming_example",
  "jdx_orm_spec_file": "./config/gilhari_streaming_example.jdx",
  "jdbc_driver_path": "/node/node_modules/jdxnode/external_libs/sqlite-jdbc-3.50.3.0.jar",
  "jdx_debug_level": 5,
  "jdx_force_create_schema": "true",
  "jdx_persistent_classes_location": "./bin",
  "classnames_map_file": "config/classnames_map_example.json",
  "gilhari_rest_server_port": 8081
}
```

#### Service Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `gilhari_microservice_name` | Optional name to identify this Gilhari microservice. The name is logged on console during start up | - |
| `jdx_orm_spec_file` | Location of the ORM specification file containing mapping for persistent classes | - |
| `jdbc_driver_path` | Path to the JDBC driver (.jar) file. SQLite driver included by default | - |
| `jdx_debug_level` | Debug output level (0-5). 0 = most verbose, 5 = minimal. Level 3 outputs all SQL statements | 5 |
| `jdx_force_create_schema` | Whether to recreate database schema on each run. `true` = useful for development, `false` = create only once | false |
| `jdx_persistent_classes_location` | Root location for compiled persistent (Container domain model) classes. Can be a directory (e.g., ./bin) or a JAR file path. Used as a Java CLASSPATH  | - |
| `classnames_map_file` | Optional JSON file that can map names of container domain model classes to (simpler) object class (type) names (e.g., by omitting a package name) to simplify REST URL| - |
| `gilhari_rest_server_port` | Port number for the RESTful service. This port number may be mapped to different port number (e.g., 80) by a docker run command. | 8081 |


## Build Files
- `compile.cmd` / `compile.sh`: Compiles the container domain model classes
- `sources.txt`: Lists the names of the container domain model class source (.java) files for compilation
- `build.cmd` / `build.sh`: Creates the Gilhari Docker image (gilhari_streaming_example) using the local Dockerfile

**Note**: Compilation targets JDK version 1.8, which is compatible with the current Gilhari version.

## Quick Start

### For Quick Evaluation (No SDK Required)
If you just want to see this example in action without modifications:

1. **Clone this repository** (pre-compiled classes included)
2. **Install Docker**
3. **Build and run** (skip compilation step)

### For Development and Customization
If you want to modify the object model or create your own Gilhari microservices:

1. **Gilhari SDK**: Download and install from [https://softwaretree.com](https://softwaretree.com)
2. **JX_HOME environment variable**: Set to the root directory of your Gilhari SDK installation
3. **Java Development Kit (JDK 1.8+)** for compilation
4. **Docker** installed on your system

**Note:** The Gilhari SDK contains necessary libraries (JARs) and base classes required for compiling container domain model classes. While pre-compiled `.class` files are included in this repository for immediate use, you'll need the SDK to make any modifications to the object model or to create your own Gilhari microservices.

## Build and Run

### Option 1: Quick Run (Using Pre-compiled Classes)

**Skip compilation** and go straight to Docker:

```bash
# Windows
build.cmd
run_docker_app.cmd

# Linux/Mac
./build.sh
./run_docker_app.sh
```

### Option 2: Compile and Run (For Modifications)

**If you've made changes to the source code:**

1. **Ensure JX_HOME is set** to your Gilhari SDK installation directory

2. **Compile the classes**:
   ```bash
   # Windows
   compile.cmd
   
   # Linux/Mac
   ./compile.sh
   ```

3. **Build and run the Docker container**:
   ```bash
   # Windows
   build.cmd
   run_docker_app.cmd
   
   # Linux/Mac
   ./build.sh
   ./run_docker_app.sh
   ```

## REST API Usage

Once running, access the Gilhari microservice at:

```
http://localhost:<port>/gilhari/v1/:className
```

**Example endpoints:**
```
http://localhost:80/gilhari/v1/Employee
http://localhost:80/gilhari/v1/Employee/startStream
http://localhost:80/gilhari/v1/Employee/fetchMore
http://localhost:80/gilhari/v1/Employee/closeStream
```

### Streaming API Methods

| Method | Purpose | Parameters | Transaction |
|--------|---------|------------|-------------|
| startStream | Begin streaming query | `maxObjects`, `filter` (optional) | Starts transaction |
| fetchMore | Get next batch | `maxObjects` (-1 for all remaining) | Within transaction |
| closeStream | End streaming query | None | Closes transaction |

### Example: Streaming Query Operations

**1. Start Stream (get first 2 employees):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Employee/startStream?maxObjects=2" \
  -H "Content-Type: application/json"
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "John1",
    "compensation": 50000,
    "exempt": true,
    "DOB": 381484800000
  },
  {
    "id": 2,
    "name": "Jane2",
    "compensation": 55000,
    "exempt": false,
    "DOB": 381484800000
  }
]
```

**2. Fetch More (get next 3 employees):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Employee/fetchMore?maxObjects=3" \
  -H "Content-Type: application/json"
```

**3. Fetch Remaining (get all remaining employees):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Employee/fetchMore?maxObjects=-1" \
  -H "Content-Type: application/json"
```

**4. Close Stream:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Employee/closeStream" \
  -H "Content-Type: application/json"
```

**Response:** (confirmation message)

### Start Stream with Filter

**Stream only exempt employees:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Employee/startStream?maxObjects=5&filter=exempt=1" \
  -H "Content-Type: application/json"
```

### Standard (Non-Streaming) Operations

All standard CRUD operations are also available:
```bash
# Standard query (returns all at once)
curl -X GET "http://localhost:80/gilhari/v1/Employee" \
  -H "Content-Type: application/json"

# Create employees
curl -X POST http://localhost:80/gilhari/v1/Employee \
  -H "Content-Type: application/json" \
  -d '{"entity": {"id": 1, "name": "John1", "compensation": 50000, "exempt": true, "DOB": 381484800000}}'
```

### Testing the API

**Test scripts:**
- `curlCommandsPopulate.cmd / .sh`     : Demonstrates populating sample employee data
- `curlCommandsStreamingSync.cmd / .sh`: Demonstrates streaming query operations

The scripts demonstrates:
- Populating employee data
- Starting a streaming query with batch size
- Fetching subsequent batches
- Fetching all remaining objects
- Properly closing the stream
- Standard query comparison

Run the script to generate a `curl.log` file with all responses:
```bash
# Windows
curlCommandsPopulate.cmd
curlCommandsStreamingSync.cmd

# Linux/Mac
chmod +x curlCommandsPopulate.sh
./curlCommandsPopulate.sh
chmod +x curlCommandsStreamingSync.sh
./curlCommandsStreamingSync.sh


# Custom port
# Windows
curlCommandsPopulate.cmd 8899
curlCommandsStreamingSync.cmd 8899

# Linux/Mac
curlCommandsStreamingSync.sh 8899
./curlCommandsStreamingSync.sh 8899
```

**Other options:**
- **Postman**: Import the endpoints for interactive testing
- **Browser**: Access GET endpoints directly (for simple queries)
- **Any REST Client**: Standard HTTP methods work with any REST client
- **ORMCP Server** (optional): Use ORMCP Server tools for AI-powered interactions

## Using with ORMCP Server (Optional)

This Gilhari microservice can be used with the ORMCP Server for AI-powered database interactions:

1. **Start this Gilhari microservice** (as shown in Quick Start)
2. **Configure ORMCP Server** to connect to this microservice endpoint
3. **Use ORMCP tools** to query and manipulate Employee objects through natural language

The ORMCP Server can leverage streaming queries for processing large result sets efficiently.

For more information on ORMCP Server:
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples)
- **Product Website**: [https://www.softwaretree.com/products/ormcp/](https://www.softwaretree.com/products/ormcp/)

## Development Tools

### Docker Container Access
Shell into a running container:
```bash
# Find container ID
docker ps

# Access container
docker exec -it <container-id> bash
```

### View Logs
```bash
docker logs <container-id>
```

### Stop Container
```bash
docker stop <container-id>
```

## Additional Resources

- **JDX User Manual**: "Persisting JSON Objects" section for detailed ORM specification documentation
- **Gilhari SDK Documentation**: The SDK available for download at [https://softwaretree.com](https://softwaretree.com)
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **Database Configuration Guide**: See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide.md`
- **operationDetails Documentation**: See `operationDetails_doc.md` for GraphQL-like query capabilities
- **Basic example**: [gilhari_simple_example](https://github.com/SoftwareTree/gilhari_simple_example)

## Platform Notes

Script files are provided for both Windows (`.cmd`) and Linux/Mac (`.sh`). 

**Linux/Mac users**: Make scripts executable before running:
```bash
chmod +x *.sh
```

## Troubleshooting

### Common Issues

**Problem**: Docker image build fails
- **Solution**: Ensure the base Gilhari image is pulled: `docker pull softwaretree/gilhari`

**Problem**: Compilation errors
- **Solution**: Verify JDK 1.8+ is installed and JX_HOME environment variable is set correctly

**Problem**: Port 80 already in use
- **Solution**: Modify `run_docker_app` script to use a different port (e.g., `-p 8080:8081`)

**Problem**: Database connection errors
- **Solution**: Check `config/gilhari_streaming_example.jdx` for correct database URL and JDBC driver path

**Problem**: fetchMore returns empty results
- **Solution**: Make sure you called startStream first. fetchMore only works with an active stream

**Problem**: Stream appears "stuck" or not releasing resources
- **Solution**: Always call closeStream to properly close the transaction and release resources. If the stream isn't closed, subsequent streaming queries may fail

**Problem**: Cannot start a new stream
- **Solution**: Only one stream can be active at a time per session. Close the previous stream with closeStream before starting a new one

**Problem**: Memory issues with large result sets
- **Solution**: Use smaller maxObjects values in startStream and fetchMore to process data in smaller batches

## Support

For issues or questions:
- **ORMCP Documentation & Issues**: [https://github.com/softwaretree/ormcp-docs/issues](https://github.com/softwaretree/ormcp-docs/issues)
- **This example**: [https://github.com/SoftwareTree/gilhari_streaming_example/issues](https://github.com/SoftwareTree/gilhari_streaming_example/issues)
- **Gilhari SDK**: Contact support at [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com)

## License

This example code is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important:** This license applies ONLY to the example code in this repository. The Gilhari software (including the softwaretree/gilhari Docker image and Gilhari SDK) and the embedded JDX ORM software are proprietary products owned by Software Tree.

The Gilhari Docker image includes an evaluation license for testing purposes. For production use or licensing beyond the evaluation period, please visit [https://www.softwaretree.com](https://www.softwaretree.com) or contact [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com).

---

**Ready to try it?** Start with the [Quick Start](#quick-start) section above!