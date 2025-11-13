const path = require('path')

/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    serverActions: {
      bodySizeLimit: '50mb',
    },
  },
  // Explicitly configure webpack for path resolution
  webpack: (config, { isServer }) => {
    // Ensure resolve exists
    if (!config.resolve) {
      config.resolve = {};
    }
    // Ensure alias exists
    if (!config.resolve.alias) {
      config.resolve.alias = {};
    }
    // Add @ alias pointing to project root
    config.resolve.alias['@'] = path.resolve(__dirname);
    return config;
  },
}

module.exports = nextConfig

