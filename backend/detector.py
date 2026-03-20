from database import get_ports_by_scan, get_recent_scans, insert_alerts, get_device_ip, get_all_scan_features
from datetime import datetime
from sklearn.ensemble import IsolationForest
import numpy as np


class ThreatDetector:

    def __init__(self, scan_id):
        self.scan_id = scan_id
        self.ports = get_ports_by_scan(scan_id)
        self.dan_ports = [21, 23, 445, 3389, 8000]

    def rule_based_detection(self):

        for data in self.ports:
            if data[3] in self.dan_ports:
                if data[3] == 21:
                    ip = get_device_ip(data[1])
                    insert_alerts("FTP Port Open", "High",
                                  ip, datetime.now(), False)

                if data[3] == 23:
                    ip = get_device_ip(data[1])
                    insert_alerts("Telnet Port Open",
                                  "Critical", ip, datetime.now(), False)

                if data[3] == 445:
                    ip = get_device_ip(data[1])
                    insert_alerts("SMB Port Open", "Critical",
                                  ip, datetime.now(), False)
                if data[3] == 3389:
                    ip = get_device_ip(data[1])
                    insert_alerts("RDP Port Open", "High",
                                  ip, datetime.now(), False)
                if data[3] == 8000:
                    ip = get_device_ip(data[1])
                    insert_alerts("Dev Server Exposed",
                                  "High", ip, datetime.now(), False)

    def ml_detection(self):
        port_count = len(self.ports)
        device_count = len(set(data[1] for data in self.ports))
        suspicious_count = sum(
            1 for data in self.ports if data[3] in self.dan_ports)
        all_features = get_all_scan_features()
        current_features = [device_count, port_count,
                            suspicious_count]
        training_data = np.array([[row[1], row[2], row[3]]
                                 for row in all_features])
        model = IsolationForest()
        model.fit(training_data)
        result = model.predict([current_features])
        if result[0] == -1:
            insert_alerts(
                f"Anomalous Scan Detected on {self.scan_id}", "high", "N/A", datetime.now(), False)

    def master_detection(self):
        self.rule_based_detection()
        self.ml_detection()
