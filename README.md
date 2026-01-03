# AIOps Log Analysis & Anomaly Detection
This project demonstrates a production-grade AIOps pipeline. It features a modular Linux-based telemetry generator (Bash) paired with an unsupervised Machine Learning engine (Python) that detects system anomalies and routes alerts to Slack.

#### Why bash script?
- To demonstrate my bash skill like file I/O operations and persistent data storage managements, script-to-script execution. Other example can be a bash script that check the health of a machine and send alert to Slacks if the AI feels an anomaly and something is about to break. Automate the script that run in the background at specific times or intervals automated with the cron deamon on linux based machine.

he goal is to move from reactive monitoring (waiting for things to break) to predictive observability (identifying unusual patterns before they cause downtime).
## Bash Script:
```` bash
./main.bash user.txt
````
- **Modular Scripts**: Separate logic for CRUD operations (create, see, delete) to simulate a microservices environment.
- **Logging**: Implements a custom log_event function to ensure all telemetry follows a consistent schema: LEVEL: MESSAGE: TIMESTAMP: MODULE
- **Chaos Engineering Simulation**: Includes a simulation engine that injects pseudo-random anomalies, such as disk space saturation (99% usage) and buffer overflows, to test the resilience of the monitoring stack.
## Detection Engine (Python & Scikit-Learn):
- **Isolation Forest Algorithm**: A tree-based model that isolates anomalies rather than profiling normal points. It evaluates logs based on severity_level and message_length
- **Feature Engineering**: Converts raw text logs into numerical features (level_score, message_length) that the model can process
- **Observability Visualization**: Generates a scatter plot via Matplotlib, mapping system health and highlighting detected outliers in red.
- **ChatOps Integration**: Automated alerts sent via Slack Webhooks including statistical summaries of detected anomalies.

## Prerequisites with Docker:
- Docker


Make sure to have the log-analisys.py, Dockerfile, requirements.txt & the log file( system_log.csv ) in the same folder.
````
├── aiops-log-analysis/
│   ├── log-analisys.py
│   ├── Dockerfile    
│   ├── requirements.txt
│   ├── system_log.csv
````

## Docker Build and Execution:
### Configuration & Environment

| Variable | Description | Example |
|--------|--------|--------|
| ````SLACK_URL```` | Your Slack Incoming Webhook URL | ````https://hooks.slack.com/services/...```` |
````
  docker build -t aiops-analyzer .
  docker run --rm \
    -e SLACK_URL="https://hooks.slack.com/services/YOUR/LINK/HERE" \
    -v $(pwd):/app \
    aiops-analyzer
````
## Prerequisites (without Docker):
- Linux/Debian environment
- Python 3.11+
- python3-venv
## Installation (Without Docker):
1. Clone the repo
2. Setup virtual environment:
  ````
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    export SLACK_URL="https://hooks.slack.com/services/YOUR/LINK/HERE"
  ````
## Execution (Without Docker)

4. Analyze logs:
````
python3 log-analisys.py
````
## Deactivate the Environment
````
deactivate
````
## Delete The Virtual Environment Folder
````
# In the project directory
rm -rf .venv
````
![alt text](https://github.com/dev126712/aiops-log-analysis/blob/1b9e96bdd7f454f4d2397dcda6aa9867298de17d/Screenshot%202026-01-01%207.41.47%20PM.png)
![alt text](https://github.com/dev126712/aiops-log-analysis/blob/b96d915f1cc08974a0387ccd76c20e4c843ec575/image.png)
