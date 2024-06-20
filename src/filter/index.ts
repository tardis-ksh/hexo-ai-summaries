import fsp from 'node:fs/promises';
import path from 'node:path';

import { HtmlPath, PLUGIN_NAME } from '@/constants';
import { PluginConfig } from '@/types';
import * as process from 'node:process';

const getHtmlContent = (content?: string) => {
  return `<link rel="stylesheet" href="/${PLUGIN_NAME}/${HtmlPath.CSS}">
${
  content ||
  `<div class="post-gemini-ai">
  <img
    class="no-lightbox ai-summary-img"
    src="https://api-shields.edui.fun/badge/Gemini-文章摘要-blue.svg?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxZW0iIGhlaWdodD0iMWVtIiB2aWV3Qm94PSIwIDAgMjQgMjQiPjxwYXRoIGZpbGw9Im5vbmUiIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIiBzdHJva2Utd2lkdGg9IjIiIGQ9Im0yMS42NCAzLjY0bC0xLjI4LTEuMjhhMS4yMSAxLjIxIDAgMCAwLTEuNzIgMEwyLjM2IDE4LjY0YTEuMjEgMS4yMSAwIDAgMCAwIDEuNzJsMS4yOCAxLjI4YTEuMiAxLjIgMCAwIDAgMS43MiAwTDIxLjY0IDUuMzZhMS4yIDEuMiAwIDAgMCAwLTEuNzJNMTQgN2wzIDNNNSA2djRtMTQgNHY0TTEwIDJ2Mk03IDhIM20xOCA4aC00TTExIDNIOSIvPjwvc3ZnPg=="
  />
</div>`
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
  data.content = getHtmlContent(htmlContent) + data.content;
  return data;
};

export default addAiContentFilter;
