import fsp from 'node:fs/promises';
import path from 'node:path';

import { HtmlPath, PLUGIN_NAME } from '@/constants';
import { PluginConfig } from '@/types';
import * as process from 'node:process';
import generateTemplate from '@/handlebars';

// img.shields.io
const getHtmlContent = async (content?: string) => {
  return `<link rel="stylesheet" href="/${PLUGIN_NAME}/${HtmlPath.CSS}">
${
  content ||
  generateTemplate(
    await fsp.readFile(path.join(__dirname, '../templates/html.tpl'), 'utf8'),
    {},
  )
}
<script src="/${PLUGIN_NAME}/${HtmlPath.JS}"></script>
`;
};

const addAiContentFilter = async (data: any) => {
  const { generateAfterDate, customHtml } = hexo.config[
    PLUGIN_NAME
  ] as PluginConfig;
  // post front 中定义
  if (data['ai-summaries'] === false) {
    return data;
  }

  const isAfterDate = generateAfterDate
    ? Date.parse(generateAfterDate) <=
      // moment startOf(Day) 会修改原始数据
      Date.parse(`${data.date.format('yyyy-MM-DD')} 00:00`)
    : false;
  if (!isAfterDate) {
    return data;
  }
  let htmlContent;
  if (customHtml) {
    htmlContent = await fsp.readFile(
      path.resolve(process.cwd(), customHtml.htmlFile),
      'utf-8',
    );
  }
  const extraContent = await getHtmlContent(htmlContent);
  data.content = extraContent + data.content;
  return data;
};

export default addAiContentFilter;
