import psycopg2


def get_connection(host='localhost', user='postgres', database='network_monitor', password='admin123', port=5432):
    conn = psycopg2.connect(
        host=host,
        user=user,
        database=database,
        password=password
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
