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

    def scan(self, ports='1-8000'):
        nm = nmap.PortScanner()
        result = nm.scan(self.IP, ports)

        for host in result['scan']:
            ip = result['scan'][host]['addresses']['ipv4']
            hostname = result['scan'][host]['hostnames'][0]['name']
            now = datetime.now()
            first_seen = now
            last_seen = now
            self.devices.append({'ip_address': ip, 'hostname': hostname,
                                'first_seen': str(now), 'last_seen': str(now)})

            if 'tcp' in result['scan'][host]:
                for port in result['scan'][host]['tcp']:
                    portname = result['scan'][host]['tcp'][port]['name']
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
