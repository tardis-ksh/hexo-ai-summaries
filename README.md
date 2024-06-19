<div align="center">
<a name="readme-top"></a>

<h1> Hexo AI Summaries </h1>

<a href="https://github.com/tardis-ksh/hexo-ai-summaries/">
    <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&width=435&lines=Hexo AI Summaries;&center=true&size=27" alt="Typing SVG" />
</a>

自动或手动提交您的网站信息至搜索引擎（谷歌，bing，百度）。支持配置 `GitHub Actions` 或 `Coding Jenkins` 来适配不同平台的 `CI`

[![CI status][github-action-image]][github-action-url]
[![NPM version][npm-image]][npm-url]
[![NPM downloads][download-image]][download-url]
</div>

[github-action-image]: https://github.com/tardis-ksh/hexo-ai-summaries/actions/workflows/publish.yml/badge.svg
[github-action-url]: https://github.com/tardis-ksh/hexo-ai-summaries/actions/workflows/publish.yml

[npm-image]: https://img.shields.io/npm/v/hexo-ai-summaries.svg?style=flat-square
[npm-url]: https://npmjs.org/package/hexo-ai-summaries

[download-image]: https://img.shields.io/npm/dm/hexo-ai-summaries.svg?style=flat-square
[download-url]: https://npmjs.org/package/hexo-ai-summaries

## 📦 Install

```bash
pnpm add hexo-ai-summaries
```

## 🔨 Usage
在 `hexo/_config.yml` 中配置 `hexo-ai-summaries`

```yaml root/_config.yml
hexo-ai-summaries:
  enable: true
  generateAfterDate: 2024/05
  aiSummaryApi: https://<cloudflare workers url>.workers.dev/v1/chat/completions
  maxToken: 30000
  prompt:
    You are a highly skilled AI trained in language comprehension and summarization. I would like you to read the text delimited by triple quotes and summarize it into a concise abstract paragraph. Aim to retain the most important points, providing a coherent and readable summary that could help a person understand the main points of the discussion without needing to read the entire text. Please avoid unnecessary details or tangential points.
    Only give me the output and nothing else. Do not wrap responses in quotes. Respond in the Chinese language.
  geminiConfig:
    model: gpt-4o
    temperature: 0.7
    headers: false
  tagConfig:
    title: .post-title
    content: .post-content
    toc: .toc-content
  
  # you can customize the html, js, css file, and then plugin just only insert this file to your post
  # you can check the result in `hexo/public/posts` folder  
  # and generated file in `hexo/public/hexo-ai-summaries/`
  customHtml:
    htmlFile: demo/js/AI/Gemini/customhtml/gemini.html
    jsFile: demo/js/AI/Gemini/customhtml/gemini.js
    styleFile: demo/js/AI/Gemini/customhtml/gemini.css
```

in your post front-matter, add `ai-summaries: false` to disable ai-summaries;

```yaml
title: xxx
date: xxx
categories: xxx
cover: xxx
# add this line to disable ai-summaries
ai-summaries: false
```
