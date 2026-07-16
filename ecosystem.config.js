module.exports = {
  apps: [{
    name: 'LunaWeb',
    script: 'server.js',
    cwd: '/opt/LunaWeb',
    watch: false,
    max_memory_restart: '100M',
    env: {
      NODE_ENV: 'production',
      PORT: 313,
    },
    error_file: '/var/log/lunaweb-error.log',
    out_file: '/var/log/lunaweb-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss',
  }]
};