# aiops-log-analysis
This project demonstrates a proactive AIOps (Artificial Intelligence for IT Operations) pipeline. It consists of a modular Linux-based user management system that generates real-time telemetry, paired with a Machine Learning engine that detects system anomalies.

The goal is to move from reactive monitoring (waiting for things to break) to predictive observability (identifying unusual patterns before they cause downtime).
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

![alt text](https://github.com/dev126712/aiops-log-analysis/blob/e591912b71939a14477bd1c06f1b59bfb95c2d9a/Screenshot%202026-01-01%207.38.30%20PM.png)
