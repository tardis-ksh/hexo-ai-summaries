import { defineConfig } from 'tsup';
import * as path from 'node:path';
import fsp from 'node:fs/promises';

const getVersion = async () => {
  const packageJson = await fsp.readFile(
    path.resolve(__dirname, 'package.json'),
    'utf8',
  );

  return JSON.parse(packageJson)?.version;
};

export default defineConfig([
  {
    format: ['cjs'], // CommonJS
    platform: 'node',
    dts: false, // 生成 .d.ts 声明文件
    sourcemap: false,
    clean: true, // 构建前清理输出目录
    minify: false, // 压缩代码
    bundle: true, // 启用代码打包
    define: {
      PACKAGE_VERSION: JSON.stringify(await getVersion()),
    },
    esbuildOptions: (options) => {
      options.alias = {
        '@': path.resolve(process.cwd(), 'src'),
      };
    },

    entry: ['src/index.ts'],
    outDir: 'dist',
  },
]);
