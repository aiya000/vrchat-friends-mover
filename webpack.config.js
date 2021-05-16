const path = require('path')

module.exports = {
  mode: 'development',
  entry: './src/main.ts',

  resolve: {
    extensions: ['.ts', '.js'],
    alias: {
      '@/': path.join(__dirname, './src'),
    },
  },

  module: {
    rules: [
      {
        test: /^\.ts$/,
        use: 'ts-loader',
      },
    ],
  },
}
