#!/bin/bash

# Update packages
apt-get update

# Install some basic tools
apt-get install -y nginx git htop curl

# Configure nginx
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Terraform GCP Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
        }
        h1 {
            color: #1a73e8;
        }
        .container {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h1>Terraform GCP Infrastructure Demo</h1>
    <div class="container">
        <p>This server was provisioned using Terraform!</p>
        <p>Infrastructure as Code makes deployments repeatable and reliable.</p>
        <p>Server time: <span id="server-time"></span></p>
    </div>
    <script>
        function updateTime() {
            document.getElementById('server-time').textContent = new Date().toLocaleString();
        }
        updateTime();
        setInterval(updateTime, 1000);
    </script>
</body>
</html>
EOF

# Start nginx
systemctl enable nginx
systemctl start nginx

# Set up a simple metadata endpoint
mkdir -p /var/www/html/metadata
cat > /var/www/html/metadata/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>VM Metadata</title>
</head>
<body>
    <h1>VM Metadata</h1>
    <pre id="metadata">Loading...</pre>
    
    <script>
        // This is just an example - in production you'd want more secure methods
        fetch('http://metadata.google.internal/computeMetadata/v1/instance/?recursive=true', {
            headers: {
                'Metadata-Flavor': 'Google'
            }
        })
        .then(response => response.json())
        .then(data => {
            document.getElementById('metadata').textContent = JSON.stringify(data, null, 2);
        })
        .catch(error => {
            document.getElementById('metadata').textContent = 'Error fetching metadata: ' + error;
        });
    </script>
</body>
</html>
EOF

# Log startup completion
echo "Startup script completed at $(date)" > /var/log/startup-script.log
