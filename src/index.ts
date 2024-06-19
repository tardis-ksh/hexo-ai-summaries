import chalk from 'chalk';
import merge from 'lodash.merge';

import addAiContentFilter from '@/filter';
import aiFileGenerator from '@/generators';

import { PLUGIN_NAME } from '@/constants';
import { PluginConfig } from '@/types';

console.log(chalk.bold.bgMagenta(`${PLUGIN_NAME} run, have fun!`));

const DefaultConfig: PluginConfig = {
  aiSummaryApi: undefined,
  tagConfig: {
    content: '.post-content',
    title: '.post-title',
    toc: '.toc-content',
  },
  enable: false,
  maxToken: 30000,
  prompt: `You are a highly skilled AI trained in language comprehension and summarization. I would like you to read the text delimited by triple quotes and summarize it into a concise abstract paragraph. Aim to retain the most important points, providing a coherent and readable summary that could help a person understand the main points of the discussion without needing to read the entire text. Please avoid unnecessary details or tangential points.\nOnly give me the output and nothing else. Do not wrap responses in quotes. Respond in the Chinese language.`,
  geminiConfig: {
    model: 'gpt-4o',
    temperature: 0.7,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': '*',
    },
  },
  // generateAfterDate: '2024/04',
};

hexo.config[PLUGIN_NAME] = merge({}, DefaultConfig, hexo.config[PLUGIN_NAME]);

const pluginConfig = hexo.config[PLUGIN_NAME];

// first run hexo clean then run filter
if (pluginConfig?.enable) {
  hexo.extend.generator.register(`${PLUGIN_NAME}-generator`, aiFileGenerator);
  hexo.extend.filter.register('after_post_render', addAiContentFilter);
}
