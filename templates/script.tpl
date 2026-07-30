function geminiAIImpl() {
class GeminiAI {
  constructor() {
    this.initAI();
  }

  initVariables() {
    this.version = {{{json PACKAGE_VERSION}}};

    this.unFinishFlag = 'data-code-input';
    this.aiTextQueue = [];
    this.typingFrame = undefined;
    this.typingElement = undefined;
    this.typingDone = false;
    this.typingResolve = undefined;
    this.typingPromise = Promise.resolve();
    this.hasResponseText = false;
    this.isInCode = false;
    this.openCodeElement = undefined;
    this.outputContainer = undefined;
    this.outputTextNode = undefined;
    this.segmenter =
      typeof Intl.Segmenter === 'function'
        ? new Intl.Segmenter(undefined, { granularity: 'grapheme' })
        : undefined;

    /**
     * Dom selector
     */
    // svg element
    this.aiTriggerSelctor = '.ai-summary-trigger';

    /**
     * AI Area
     */
    this.aiConfig = {
      api: {{{json aiSummaryApi}}},
      tagConfig: {
        {{#each tagConfig}}
         {{{json @key}}}: {{{json this}}},
        {{/each}}
      },
      maxToken: {{{json maxToken}}},
      model: {{{json aiConfig.model}}},
      apiMode: {{{json aiConfig.apiMode}}},
      temperature: {{{json aiConfig.temperature}}},
      stream: {{{json aiConfig.stream}}},
      prompt: {{{json prompt}}},
      {{#ifOr aiConfig.headers aiConfig.idempotentHeader }}
        headers: {
        {{#if aiConfig.idempotentHeader }}
        'X-Ca-Nonce': window.crypto.randomUUID(),
        {{/if}}
        {{#each aiConfig.headers}}
         {{{json @key}}}: {{{json this}}},
        {{/each}}
      },
      {{/ifOr}}
    };

    // ai-summaries wrap
    this.postAI = document.querySelector('.post-gemini-ai');
    this.postTile = document.querySelector(this.aiConfig.tagConfig.title)?.textContent;
  }

  initAI() {
    this.initVariables();

    queueMicrotask(() => {
      this.initBrandInfo();
      this.initAiTrigger();
      this.initAiSummaries();
    });
  }

  /**
   * log brand information: https://patorjk.com/software/taag/#p=display&f=Doom&t=ai-summaries
   */
  initBrandInfo() {
    if (this.initBrandBefore || window.initAIBrandBefore) {
      return;
    }
    const information = [
      `  .--.  .-. .----..-. .-..-.   .-..-.   .-.  .--.  .----. .-..----. .----.
 / {} \\ | |{ {__  | { } ||  \`.'  ||  \`.'  | / {} \\ | {}  }| || {_  { {__
/  /\\  \\| |.-._} }| {_} || |\\ /| || |\\ /| |/  /\\  \\| .-. \\| || {__ .-._} }
\`-'  \`-'\`-'\`----' \`-----'\`-' \` \`-'\`-' \` \`-'\`-'  \`-'\`-' \`-'\`-'\`----'\`----' `,
    ];

    console.log(`%c WELCOME TO USE AI SUMMARIES.`, 'color:white; background-color:#4f90d9');
    console.log(
      `%cCURRENT VERSION: %cv${this.version}`,
      '',
      'color:white; background-color:#4fd953',
    );
    console.log(`%c${information[0]}`, 'color:#ff69b4;');
    this.initBrandBefore = window.initAIBrandBefore = true;
  }

  /**
   * init svg text, replace with data-content
   * solve posts description
   */
  initAiTrigger() {
    setTimeout(() => {
      const trigger = document.querySelector(this.aiTriggerSelctor);
      const textEl = trigger.querySelectorAll('text');
      textEl?.forEach((el) => {
        el.textContent = el.dataset.content;
      });
    });
  }

  initAiSummaries() {
    this.postAI.addEventListener('click', this.onAIClick.bind(this));
  }

  segmentText(text) {
    if (this.segmenter) {
      return Array.from(this.segmenter.segment(text), ({ segment }) => segment);
    }

    return Array.from(text);
  }

  startTyping(element) {
    this.cancelTyping();
    this.typingElement = element;
    this.outputContainer = element;
    this.typingDone = false;
    this.hasResponseText = false;
    this.typingPromise = new Promise((resolve) => {
      this.typingResolve = resolve;
    });
  }

  enqueueText(text) {
    if (typeof text !== 'string' || !text.length) {
      return;
    }

    this.hasResponseText = true;
    this.aiTextQueue.push(...this.segmentText(text));
    this.scheduleTypingFrame();
  }

  scheduleTypingFrame() {
    if (this.typingFrame === undefined) {
      this.typingFrame = requestAnimationFrame(() => this.renderTypingFrame());
    }
  }

  renderTypingFrame() {
    this.typingFrame = undefined;

    if (this.aiTextQueue.length) {
      const batchSize = Math.min(12, Math.max(1, Math.ceil(this.aiTextQueue.length / 24)));
      this.appendRenderedText(this.aiTextQueue.splice(0, batchSize).join(''));

      if (this.aiTextQueue.length) {
        this.scheduleTypingFrame();
      }
    }

    if (this.typingDone && this.aiTextQueue.length === 0) {
      this.resolveTyping();
    }
  }

  appendRenderedText(text) {
    for (const segment of this.segmentText(text)) {
      if (segment === '`') {
        if (this.isInCode) {
          this.openCodeElement.removeAttribute(this.unFinishFlag);
          this.outputContainer = this.typingElement;
          this.openCodeElement = undefined;
        } else {
          this.openCodeElement = document.createElement('code');
          this.openCodeElement.setAttribute(this.unFinishFlag, '');
          this.typingElement.append(this.openCodeElement);
          this.outputContainer = this.openCodeElement;
        }

        this.isInCode = !this.isInCode;
        this.outputTextNode = undefined;
        continue;
      }

      if (!this.outputTextNode || this.outputTextNode.parentNode !== this.outputContainer) {
        this.outputTextNode = document.createTextNode('');
        this.outputContainer.append(this.outputTextNode);
      }
      this.outputTextNode.appendData(segment);
    }
  }

  finishTyping() {
    this.typingDone = true;
    if (this.aiTextQueue.length) {
      this.scheduleTypingFrame();
    } else {
      this.resolveTyping();
    }

    return this.typingPromise;
  }

  resolveTyping() {
    if (this.typingResolve) {
      this.typingResolve();
      this.typingResolve = undefined;
    }
  }

  cancelTyping() {
    if (this.typingFrame !== undefined) {
      cancelAnimationFrame(this.typingFrame);
    }
    this.typingFrame = undefined;
    this.aiTextQueue = [];
    this.typingDone = true;
    this.resolveTyping();
    this.typingElement = undefined;
    this.outputContainer = undefined;
    this.outputTextNode = undefined;
    this.openCodeElement = undefined;
    this.isInCode = false;
  }

  extractStreamText(data) {
    if (data?.type === 'error' || data?.error) {
      throw new Error(data?.error?.message || data?.message || 'AI stream returned an error');
    }

    if (this.aiConfig.apiMode === 'responses') {
      return data?.type === 'response.output_text.delta' ? data.delta : '';
    }

    return data?.choices?.[0]?.delta?.content || '';
  }

  extractJsonText(data) {
    if (this.aiConfig.apiMode === 'responses') {
      if (typeof data?.output_text === 'string') {
        return data.output_text;
      }

      return (data?.output || [])
        .flatMap((output) => output?.content || [])
        .filter((content) => content?.type === 'output_text' && typeof content.text === 'string')
        .map((content) => content.text)
        .join('');
    }

    return data?.choices?.[0]?.message?.content || '';
  }

  handleSseEvent(eventText) {
    const dataText = eventText
      .split(/\r?\n/)
      .filter((line) => line.startsWith('data:'))
      .map((line) => line.slice(5).trimStart())
      .join('\n');

    if (!dataText || dataText === '[DONE]') {
      return;
    }

    this.enqueueText(this.extractStreamText(JSON.parse(dataText)));
  }

  async handleStreamResponse(response) {
    if (!response.body) {
      throw new Error('AI stream response has no body');
    }

    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = '';

    while (true) {
      const { value, done } = await reader.read();
      if (done) {
        buffer += decoder.decode();
        break;
      }

      buffer += decoder.decode(value, { stream: true });
      let separator = buffer.match(/\r?\n\r?\n/);
      while (separator && separator.index !== undefined) {
        this.handleSseEvent(buffer.slice(0, separator.index));
        buffer = buffer.slice(separator.index + separator[0].length);
        separator = buffer.match(/\r?\n\r?\n/);
      }
    }

    if (buffer.trim()) {
      this.handleSseEvent(buffer);
    }
  }

  async handleJsonResponse(response) {
    const text = this.extractJsonText(await response.json());
    if (!text) {
      throw new Error(`AI ${this.aiConfig.apiMode} response contains no text`);
    }

    this.enqueueText(text);
  }

  buildRequestBody(input, updateTime) {
    const commonBody = {
      model: this.aiConfig.model,
      temperature: this.aiConfig.temperature,
      stream: this.aiConfig.stream,
      updateTime,
      title: this.postTile,
    };

    if (this.aiConfig.apiMode === 'responses') {
      return {
        ...commonBody,
        instructions: this.aiConfig.prompt,
        input,
      };
    }

    return {
      ...commonBody,
      messages: [
        { role: 'system', content: this.aiConfig.prompt },
        { role: 'user', content: input },
      ],
    };
  }

  initAiResult() {
    this.postAI.insertAdjacentHTML(
      'afterend',
      '<div class="post-gemini-ai-result-wrap"> <div class="note primary no-icon flat"> <p class="post-gemini-ai-result"></p>  <span class="ai-typed-cursor">|</span></div> </div>',
    );
    this.postAI.classList.add('post-gemini-noclick');
  }

  escapeHtml(str) {
    return str
      .replace(/\n/g, '')
      .replace(/[ ]+/g, ' ')
      .replace(/<pre>[\s\S]*?<\/pre>/g, '');
  }

  onAIClick = async () => {
    const postAiTrigger = document.querySelector(this.aiTriggerSelctor);

    this.initAiResult();
    const resultWrap = document.querySelector('.post-gemini-ai-result-wrap');
    const postAIResult = resultWrap.querySelector('.post-gemini-ai-result');
    const typedCursor = resultWrap.querySelector('.ai-typed-cursor');
    this.startTyping(postAIResult);

    try {
      const input = document.querySelector(this.aiConfig.tagConfig.content).innerText;
      const postToc = document.querySelector(this.aiConfig.tagConfig.toc);
      const updateTimeEl = document.querySelector('.post-meta-date-updated');
      const updateTime = Date.parse(updateTimeEl?.getAttribute('datetime') || '');

      postAiTrigger.classList.add('ai-summary-active');

      const inputContent = this.escapeHtml(input).substring(0, this.aiConfig.maxToken);
      const toAI = `文章标题：${this.postTile}；文章目录：${postToc?.textContent}；具体内容：${inputContent}`;
      const res = await fetch(this.aiConfig.api, {
        method: 'POST',
        headers: this.aiConfig.headers,
        body: JSON.stringify(this.buildRequestBody(toAI, updateTime)),
      });

      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }

      const contentType = (res.headers.get('Content-Type') || '').toLowerCase();
      if (contentType.includes('text/event-stream')) {
        await this.handleStreamResponse(res);
      } else if (contentType.includes('application/json')) {
        await this.handleJsonResponse(res);
      } else {
        throw new Error(`Unsupported content type: ${contentType || 'unknown'}`);
      }

      if (!this.hasResponseText) {
        throw new Error(`AI ${this.aiConfig.apiMode} response contains no text`);
      }

      await this.finishTyping();
      typedCursor.remove();
    } catch (error) {
      this.cancelTyping();
      resultWrap.remove();
      console.error(error);
      this.postAI.classList.remove('post-gemini-noclick');
      postAiTrigger.classList.remove('ai-summary-active');
    }
  };
  }

  new GeminiAI();
}

geminiAIImpl();
