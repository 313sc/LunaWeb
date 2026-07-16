module.exports = {
  apps: [{
    name: 'LunaWeb',
    script: 'npx',
    args: 'serve -l 313 -s dist',
    cwd: '/opt/LunaWeb',
    watch: false,
    max_memory_restart: '100M',
    env: {
      NODE_ENV: 'production',
    },
    error_file: '/var/log/lunaweb-error.log',
    out_file: '/var/log/lunaweb-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss',
  }]
};