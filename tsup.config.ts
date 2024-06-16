import { defineConfig } from 'tsup';
import * as path from 'node:path';

export default defineConfig([
  {
    format: ['cjs'], // CommonJS
    platform: 'node',
    dts: false, // 生成 .d.ts 声明文件
    sourcemap: false,
    clean: true, // 构建前清理输出目录
    minify: true, // 压缩代码
    bundle: true, // 启用代码打包

    esbuildOptions: (options) => {
      options.alias = {
        '@': path.resolve(process.cwd(), 'src'),
      };
    },

    entry: ['src/index.ts'],
    outDir: 'dist',
  },
]);
