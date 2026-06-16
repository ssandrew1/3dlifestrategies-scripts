# Test the config:
# sudo nginx -t

# If it says "syntax is ok" and "test is successful," proceed to step 2.
# Apply the changes:
# Reload (Recommended): This applies changes without dropping active user connections.
# sudo systemctl reload nginx

# Restart (Full): Use this if you made major changes like updating ports or installing new modules.
sudo systemctl restart nginx

