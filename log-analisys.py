import pandas as pd
import numpy as np
from sklearn.ensemble import IsolationForest
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# 1. Load the data
log_file_path = "system_log.csv"
data = []

with open(log_file_path, "r") as file:
    for line in file:
        line = line.strip()
        if not line or ":" not in line:
            continue
        
        # We split by ": " (colon + space) which matches your log_event function
        parts = line.split(": ")
        
        if len(parts) >= 3:
            # Format: LEVEL: MESSAGE: TIMESTAMP: FROM MODULE
            level = parts[0].strip()
            # The message is everything in the middle
            message = parts[1].strip()
            # The timestamp is the 3rd part
            timestamp = parts[2].strip()
            data.append([timestamp, level, message])

df = pd.DataFrame(data, columns=["timestamp", "level", "message"])

# --- Safety Check: Did we get any data? ---
if df.empty:
    print("❌ ERROR: No logs found! Your CSV format might not match the script.")
    print("Ensure your logs look like 'INFO: message: Thursday,January01...'")
    exit()

# 2. Convert timestamp
# We use format='%A,%B%d,%Y-%H:%M' to match 'Thursday,January01,2026-18:05'
df["timestamp"] = pd.to_datetime(df["timestamp"], format="%A,%B%d,%Y-%H:%M", errors='coerce')

# Remove any lines that failed to convert (NaT)
df = df.dropna(subset=["timestamp"])

if df.empty:
    print("❌ ERROR: Data was found, but the Timestamps are in the wrong format.")
    exit()

# 3. Numeric Mapping for AIOps (The rest of your script stays the same)
level_mapping = {"DEBUG": 0, "INFO": 1, "WARNING": 2, "ERROR": 3, "CRITICAL": 4}
df["level_score"] = df["level"].map(level_mapping).fillna(1)
df["message_length"] = df["message"].apply(len)

# 4. Train the Isolation Forest
model = IsolationForest(contamination=0.1, random_state=42)
df["anomaly"] = model.fit_predict(df[["level_score", "message_length"]])

# 5. Result Formatting and Plotting (Your existing code...)
df["status"] = df["anomaly"].apply(lambda x: "❌ ANOMALY" if x == -1 else "✅ NORMAL")

print(f"\n✅ Analysis Complete! Processed {len(df)} log lines.")
anomalies = df[df["status"] == "❌ ANOMALY"]
if not anomalies.empty:
    print(anomalies[["timestamp", "level", "message", "status"]])
else:
    print("No anomalies detected.")

# Assign colors: Red for anomalies, Green for normal
colors = df['anomaly'].map({1: 'tab:green', -1: 'tab:red'})
plt.figure(figsize=(10, 6))
plt.scatter(df['level_score'], df['message_length'], c=colors, alpha=0.6)
plt.title('AIOps Log Anomaly Detection')
plt.xlabel('Log Severity (1=INFO, 4=CRITICAL)')
plt.ylabel('Message Length (Characters)')
plt.grid(True)
plt.savefig('anomaly_report.png')
print("\n📈 Graph saved successfully as 'anomaly_report.png'")
