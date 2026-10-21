module.exports = {
  apps: [
    {
      name: 'mahle-passport',
      // Direct node execution of Next.js binary - works on both Linux and Windows
      script: 'node_modules/next/dist/bin/next',
      args: 'start',
      cwd: './',
      instances: 1, // Single instance recommended for session cookies & DB connection pooling
      exec_mode: 'fork',
      watch: false,

      // --- AUTO RESTART ON CRASH / FAILURE OPTIONS ---
      autorestart: true, // Automatically restart app if it crashes, throws unhandled error, or exits
      max_restarts: 50, // Maximum consecutive restarts before entering errored state
      min_uptime: '10s', // Must run for at least 10s to be considered a stable run
      restart_delay: 2000, // Wait 2 seconds before respawning to allow TCP ports & DB connections to clear
      exp_backoff_restart_delay: 100, // Exponential backoff in case of repeated immediate failures (prevents CPU lockup)
      max_memory_restart: '1G', // Automatically restart if memory leak exceeds 1GB
      kill_timeout: 5000, // Time in ms before sending SIGKILL if app doesn't gracefully exit
      listen_timeout: 10000, // Time in ms to wait for app to start listening

      env: {
        NODE_ENV: 'production',
        PORT: 4000, // Change this to your desired port (e.g. 3000, 4000, 5000, 8080)
      },
      env_production: {
        NODE_ENV: 'production',
        PORT: 4000, // Production environment port
      },
      error_file: './logs/pm2-error.log',
      out_file: './logs/pm2-out.log',
      merge_logs: true,
      time: true,
    },
  ],
};
