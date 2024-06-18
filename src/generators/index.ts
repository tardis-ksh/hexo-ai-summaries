import fsp from 'node:fs/promises';
import path from 'node:path';

import generateTemplate from '@/handlebars';

import { HtmlPath, PLUGIN_NAME } from '@/constants';

import Hexo from '@/types/hexo';
import { PluginConfig } from '@/types';
import * as process from 'node:process';

interface HtmlConfig {
  htmlContent?: string;
  jsContent: string;
  cssContent: string;
}

const generateHtml = (htmlConfig: HtmlConfig) => {
  const { htmlContent, jsContent, cssContent } = htmlConfig;
  return [
    htmlContent
      ? { path: `${PLUGIN_NAME}/${HtmlPath.HTML}`, data: htmlContent }
      : undefined,
    { path: `${PLUGIN_NAME}/${HtmlPath.JS}`, data: jsContent },
    { path: `${PLUGIN_NAME}/${HtmlPath.CSS}`, data: cssContent },
  ].filter(Boolean);
};

const aiFileGenerator = async (): Hexo['Return'] => {
  const config = hexo.config[PLUGIN_NAME] as PluginConfig;
  const { customHtml } = config;
  if (customHtml) {
    const htmlConfig = {
      htmlContent: await fsp.readFile(
        path.resolve(process.cwd(), customHtml.htmlFile),
        'utf8',
      ),
      jsContent: await fsp.readFile(
        path.resolve(process.cwd(), customHtml.jsFile),
        'utf8',
      ),
      cssContent: await fsp.readFile(
        path.resolve(process.cwd(), customHtml.styleFile),
        'utf8',
      ),
    };
    return generateHtml(htmlConfig);
  }

  const htmlConfig = {
    jsContent: generateTemplate(
      await fsp.readFile(
        path.join(__dirname, '../templates/script.tpl'),
        'utf8',
      ),
      config,
    ),
    cssContent: generateTemplate(
      await fsp.readFile(
        path.join(__dirname, '../templates/style.tpl'),
        'utf8',
      ),
      config,
    ),
  };
  return generateHtml(htmlConfig);
};

export default aiFileGenerator;
