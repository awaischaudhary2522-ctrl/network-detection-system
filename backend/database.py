import psycopg2
from config import DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME


def get_connection(host=DB_HOST, user=DB_USER, database=DB_NAME, password=DB_PASSWORD, port=DB_PORT):
    conn = psycopg2.connect(
        host=host,
        user=user,
        database=database,
        password=password,
        port=port
    )
    return conn


def insert_devices(ip_address, hostname, first_seen, last_seen, mac_address=None):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO devices (ip_address, mac_address, hostname, first_seen, last_seen) VALUES(%s,%s,%s,%s,%s) RETURNING id",
                (ip_address, mac_address, hostname, first_seen, last_seen))
    conn.commit()
    fetch = cur.fetchone()[0]
    cur.close()
    conn.close()
    return fetch


def read_devices():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM devices')
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results


def read_devices_paginated(page=1, per_page=50, search=''):
    conn = get_connection()
    cur = conn.cursor()
    offset = (page - 1) * per_page
    if search:
        like = f'%{search}%'
        cur.execute(
            "SELECT COUNT(*) FROM devices WHERE ip_address ILIKE %s OR hostname ILIKE %s",
            (like, like))
        total = cur.fetchone()[0]
        cur.execute(
            "SELECT * FROM devices WHERE ip_address ILIKE %s OR hostname ILIKE %s ORDER BY id LIMIT %s OFFSET %s",
            (like, like, per_page, offset))
    else:
        cur.execute("SELECT COUNT(*) FROM devices")
        total = cur.fetchone()[0]
        cur.execute(
            "SELECT * FROM devices ORDER BY id LIMIT %s OFFSET %s", (per_page, offset))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results, total


def update_devices(last_seen, device_id):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('UPDATE devices SET last_seen = %s WHERE id = %s',
                (last_seen, device_id))
    conn.commit()
    cur.close()
    conn.close()


def delete_devices(device_id):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('DELETE FROM devices WHERE id = %s', (device_id,))
    conn.commit()
    cur.close()
    conn.close()


def insert_alerts(alert_type, severity, source_ip, created_at, resolved):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO alerts (alert_type, severity, source_ip, created_at, resolved) VALUES(%s,%s,%s,%s,%s)",
                (alert_type, severity, source_ip, created_at, resolved))
    conn.commit()
    cur.close()
    conn.close()


def read_alerts():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM alerts')
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results


def read_alerts_paginated(page=1, per_page=50, search=''):
    conn = get_connection()
    cur = conn.cursor()
    offset = (page - 1) * per_page
    if search:
        like = f'%{search}%'
        cur.execute(
            "SELECT COUNT(*) FROM alerts WHERE alert_type ILIKE %s OR source_ip ILIKE %s",
            (like, like))
        total = cur.fetchone()[0]
        cur.execute(
            "SELECT * FROM alerts WHERE alert_type ILIKE %s OR source_ip ILIKE %s ORDER BY id LIMIT %s OFFSET %s",
            (like, like, per_page, offset))
    else:
        cur.execute("SELECT COUNT(*) FROM alerts")
        total = cur.fetchone()[0]
        cur.execute(
            "SELECT * FROM alerts ORDER BY id LIMIT %s OFFSET %s", (per_page, offset))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results, total


def update_alerts(resolved, alert_id):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('UPDATE alerts SET resolved = %s WHERE id = %s',
                (resolved, alert_id))
    conn.commit()
    cur.close()
    conn.close()


def insert_logs(event, created_at):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO logs (event, created_at) VALUES(%s,%s)",
                (event, created_at))
    conn.commit()
    cur.close()
    conn.close()


def read_logs():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM logs')
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results


def read_logs_paginated(page=1, per_page=50):
    conn = get_connection()
    cur = conn.cursor()
    offset = (page - 1) * per_page
    cur.execute("SELECT COUNT(*) FROM logs")
    total = cur.fetchone()[0]
    cur.execute(
        "SELECT * FROM logs ORDER BY id LIMIT %s OFFSET %s", (per_page, offset))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results, total


def insert_scans(subnet_scanned, scanned_at):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO scans (subnet_scanned, scanned_at) VALUES(%s,%s) RETURNING id",
                (subnet_scanned, scanned_at))
    fetch = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return fetch


def read_scans():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM scans')
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results


def read_scans_paginated(page=1, per_page=50):
    conn = get_connection()
    cur = conn.cursor()
    offset = (page - 1) * per_page
    cur.execute("SELECT COUNT(*) FROM scans")
    total = cur.fetchone()[0]
    cur.execute(
        "SELECT * FROM scans ORDER BY id LIMIT %s OFFSET %s", (per_page, offset))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results, total


def insert_ports(device_id, scan_id, port_number, service_name, protocol):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO ports (device_id, scan_id, port_number, service_name, protocol) VALUES(%s,%s,%s,%s,%s)",
                (device_id, scan_id, port_number, service_name, protocol))
    conn.commit()
    cur.close()
    conn.close()


def read_ports():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM ports')
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results


def read_ports_paginated(page=1, per_page=50, search=''):
    conn = get_connection()
    cur = conn.cursor()
    offset = (page - 1) * per_page
    if search:
        like = f'%{search}%'
        cur.execute(
            "SELECT COUNT(*) FROM ports WHERE service_name ILIKE %s OR port_number::text ILIKE %s",
            (like, like))
        total = cur.fetchone()[0]
        cur.execute(
            "SELECT * FROM ports WHERE service_name ILIKE %s OR port_number::text ILIKE %s ORDER BY id LIMIT %s OFFSET %s",
            (like, like, per_page, offset))
    else:
        cur.execute("SELECT COUNT(*) FROM ports")
        total = cur.fetchone()[0]
        cur.execute(
            "SELECT * FROM ports ORDER BY id LIMIT %s OFFSET %s", (per_page, offset))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results, total


def get_ports_by_scan(scan_id):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM ports WHERE scan_id =%s", (scan_id,))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results


def get_recent_scans(hours):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        "SELECT COUNT(*) FROM scans WHERE scanned_at > NOW() - INTERVAL '%s mins'", (hours,))
    results = cur.fetchone()[0]
    cur.close()
    conn.close()
    return results


def get_device_ip(device_id):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        "SELECT ip_address FROM devices WHERE id = %s", (device_id,))
    results = cur.fetchone()[0]
    cur.close()
    conn.close()
    return results


def get_all_scan_features():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("""SELECT scan_id, COUNT(*) as port_count,
                 COUNT(DISTINCT device_id) as device_count,
                SUM(CASE WHEN port_number IN (21,23,445,3389,8000) THEN 1 ELSE 0 END) as suspicious_count
                FROM ports 
                GROUP BY scan_id""")
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results
