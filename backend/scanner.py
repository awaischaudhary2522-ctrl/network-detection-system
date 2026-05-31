import nmap
from datetime import datetime
from database import insert_devices, read_devices
from database import insert_ports, read_ports
from database import insert_scans, read_scans


class NetworkScanner:
    def __init__(self, IP):
        self.IP = IP
        self.devices = []
        self.ports = []
        self.scan_id = None

# To Scan the IP's that are given to us

    def scan(self, ports='21,22,23,25,53,80,110,143,443,445,993,995,1433,1521,2049,3306,3389,5432,5900,8080,8443'):
        nm = nmap.PortScanner()
        result = nm.scan(self.IP, ports)

        if 'scan' not in result:
            return self.devices, self.ports

        for host in result['scan']:
            host_data = result['scan'][host]
            if 'addresses' not in host_data or 'ipv4' not in host_data['addresses']:
                continue
            ip = host_data['addresses']['ipv4']
            hostname = host_data['hostnames'][0]['name'] if host_data['hostnames'] else ''
            now = datetime.now()
            self.devices.append({'ip_address': ip, 'hostname': hostname,
                                'first_seen': str(now), 'last_seen': str(now)})

            if 'tcp' in host_data:
                for port in host_data['tcp']:
                    portname = host_data['tcp'][port]['name']
                    protocol = 'tcp'
                    self.ports.append(
                        {'ip_address': ip, 'port_number': port, 'service_name': portname, 'protocol': protocol})
        return self.devices, self.ports


# To save the devices info that we get from Scan()

    def save_devices(self):
        for data in self.devices:
            device_id = insert_devices(data['ip_address'], data['hostname'],
                                       data['first_seen'], data['last_seen'])
            data['id'] = device_id


# To save the ports and its info that we get from Scan()

    def save_ports(self):
        for data in self.ports:
            for device in self.devices:
                if device['ip_address'] == data['ip_address']:
                    insert_ports(device['id'], self.scan_id,
                                 data['port_number'], data['service_name'], data['protocol'])

# Saving Scan() info itself

    def save_scans(self):
        self.scan_id = insert_scans(self.IP, datetime.now())


# To test
# network = NetworkScanner('192.168.0.1/24')
# network.scan()
# network.save_scans()
# network.save_devices()
# network.save_ports()
# print(network.scan())
