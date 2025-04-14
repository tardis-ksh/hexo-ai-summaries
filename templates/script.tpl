function geminiAIImpl() {
class GeminiAI {
  constructor() {
    this.initAI();
  }

  initVariables() {
    this.version = '{{{PACKAGE_VERSION}}}';

    /**
     * stream input area
     */

    /**
     * unFinish code flag. half code symbol(`).
     * eg: `some code input => <code data-code-input="">some code input</code>
     */
    this.unFinishFlag = 'data-code-input';
    this.lastUnFinishCodeReg = new RegExp(`<code\\s${this.unFinishFlag}="">(.*?)<\\/code>`);
    this.aiTextQueue = [];
    // random number between 1 and 3
    this.aiTextLimit = () => Math.max(Math.round(Math.random() * 3), 1);

    /**
     * Dom selector
     */
    // svg element
    this.aiTriggerSelctor = '.ai-summary-trigger';

    /**
     * AI Area
     */
    this.aiConfig = {
      api: '{{{aiSummaryApi}}}',
      tagConfig: {
        {{#each tagConfig}}
         '{{@key}}': '{{this}}',
        {{/each}}
      },
      maxToken: {{{maxToken}}},
      model: '{{{ aiConfig.model }}}',
      {{#if aiConfig.temperature}}
      temperature: {{{ aiConfig.temperature }}},
      {{/if}}
      {{#if aiConfig.stream}}
      stream: {{{ aiConfig.stream }}},
      {{/if}}
      prompt: "{{{prompt}}}",
      {{#ifOr aiConfig.headers aiConfig.idempotentHeader }}
        headers: {
        {{#if aiConfig.idempotentHeader }}
        'X-Ca-Nonce': window.crypto.randomUUID(),
        {{/if}}
        {{#each aiConfig.headers}}
         '{{@key}}': '{{this}}',
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

    /**
     * @Description:
     * @param {String} (content)
     * @param {Element} (contentElement)
     * @param {Boolean} (needEscape)
     * @return String
     */
    parseCodeString(content, contentElement, needEscape) {
      let replaceEscapeString = needEscape
        ? content
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
        : content;

      const codeSymbol = '`';
      let result = '';
      let codeContent = '';
      let isInCode = false;

      const fullContent = contentElement.innerHTML;
      const hasUnFinishCode = fullContent.includes(this.unFinishFlag);
      // 处理未结束的 code
      if (hasUnFinishCode) {
        const codeEndIndex = replaceEscapeString.indexOf(codeSymbol);
        // 说明当前 string 仍没有 end
        if (codeEndIndex < 0) {
          contentElement.innerHTML = fullContent.replace(
            this.lastUnFinishCodeReg,
            `<code ${this.unFinishFlag}>$1${replaceEscapeString}</code>`,
          );
          return '';
        }

        contentElement.innerHTML = fullContent.replace(
          this.lastUnFinishCodeReg,
          `<code>$1${replaceEscapeString.slice(0, codeEndIndex)}</code>`,
        );

        replaceEscapeString = replaceEscapeString.slice(codeEndIndex + 1);

        if (!replaceEscapeString) {
          return '';
        }
      }

      /**
       * 处理剩下 code
       * 将字符串中符合条件的 code 内容，先储存，等遇到完整的 `` 的符号后再设置为标签
       * 通过 isInCode 变量作为 flag，每次遇到 ` 符号时取反，默认 false
       * 后面根据 isInCode 当前字符是否为 code 内容，再存储至 codeContent 变量中
       *
       * 若循环结束 isInCode 仍为 true，说明后面还有剩余的 code 内容，通过给 code 增加标签来处理
       */
      for (let i = 0; i < replaceEscapeString.length; i += 1) {
        const str = replaceEscapeString[i];
        if (str === codeSymbol) {
          if (isInCode) {
            // end code
            result += `<code>${codeContent}</code>`;
          }

          codeContent = '';
          isInCode = !isInCode;
        } else if (isInCode) {
          codeContent += str;
        } else {
          result += str;
        }
      }

      // code 仍剩余
      if (isInCode) {
        result += `<code ${this.unFinishFlag}>${codeContent}</code>`;
      }

      return result;
    }

    /**
     * @Description: fakeStreamInput
     * @param {String} (text)
     * @param {Element} (element)
     * @return
     */
    async fakeStreamInput(text, element) {
      return new Promise(async (resolve) => {
        if (text.length) {
          this.aiTextQueue.push(text);
        }
        if (this.aiTextQueue.length === 0) {
          resolve();
          return;
        }
        const paragraph = this.aiTextQueue.shift();

        const typeIn = async (textContent, index = 0) => {
          if (!textContent.length || index >= textContent.length) {
            await new Promise((resolveContent) => {
              setTimeout(resolveContent);
            });
            resolve();
            return;
          }

          const slicedContent = String(textContent).slice(index, index + this.aiTextLimit());
          const nextContent = this.parseCodeString(slicedContent, element);

          if (nextContent) {
            element.innerHTML += nextContent;
          }

          setTimeout(() => {
            requestAnimationFrame(() => {
              typeIn(textContent, index + slicedContent.length);
            });
          }, 50);
        };

        typeIn(paragraph);
      });
    }

    /**
     * @Description:
     * @param {Response} (response) openAI style response (only work on stream)
     * @param {Element} (postAIResultEl)
     */
    async handleStreamResponse(response, postAIResultEl) {
      /** @type {ReadableStreamDefaultReader<Uint8Array>} */
      const reader = response.body.getReader();
      while (true) {
        const { value, done } = await reader.read();
        if (done) {
          break;
        }
        const text = new TextDecoder().decode(value);
        const strList = text.split('\n').filter(Boolean);

        const str = strList.reduce((acc, currentValue) => {
          if (currentValue.includes('DONE') || !currentValue.includes('data:')) {
            return acc;
          }

          /**
           * @type \{{
           *   choices: Array<{
           *     delta: {
           *       content?: string
           *     }
           *   }>
           * \}}
           */
          const data = JSON.parse(currentValue.substring(6)); // remove "data: "
          const nextStr = data?.choices[0].delta.content;
          if (!nextStr) {
            return acc;
          }
          return `${acc}${nextStr}`;
        }, '');

        await this.fakeStreamInput(str, postAIResultEl);
      }
    }

    /**
     * @Description:
     * @param {Object<{ choices: [{ message: { content: String } }] }>} (data) openAI style data (only work on json)
     * @param {Element} (postAIResultEl)
     */
    async handleJsonResponse(data, postAIResultEl) {
      await this.fakeStreamInput(data?.choices[0].message.content, postAIResultEl);
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

      try {
        let postAIResult = document.querySelector('.post-gemini-ai-result');
        let input = document.querySelector(this.aiConfig.tagConfig.content).innerText;
        const postToc = document.querySelector(this.aiConfig.tagConfig.toc);
        const updateTimeEl = document.querySelector('.post-meta-date-updated');
        const updateTime = Date.parse(updateTimeEl.getAttribute('datetime'));

        // 修改 trigger style
        postAiTrigger.classList.add('ai-summary-active');

        let inputContent = this.escapeHtml(input)
          // max-token
          .substring(0, this.aiConfig.maxToken);
        let toAI = `文章标题：${this.postTile}；文章目录：${postToc?.textContent}；具体内容：${inputContent}`;
        const res = await fetch(this.aiConfig.api, {
          method: 'POST',
          headers: this.aiConfig.headers,
          body: JSON.stringify({
            model: this.aiConfig.model,
            messages: [
              {
                role: 'system',
                content: this.aiConfig.prompt,
              },
              { role: 'user', content: toAI },
            ],
            temperature: this.aiConfig.temperature,
            stream: this.aiConfig.stream,
            updateTime,
            title: this.postTile,
          }),
        });

        if (!res.ok) {
          // 抛出错误，以便在 catch 块中捕获
          throw new Error(`HTTP error! status: ${res.status}`);
        }

        const contentType = res.headers.get('Content-Type');
        if (contentType && contentType.includes('text/event-stream')) {
          // 处理 SSE
          await this.handleStreamResponse(res, postAIResult);
        } else if (contentType && contentType.includes('application/json')) {
          // 处理 JSON
          res.json().then((data) => this.handleJsonResponse(data, postAIResult));
        } else {
          throw new Error('Unsupported content type');
        }
      } catch (error) {
        document.querySelector('.post-gemini-ai-result-wrap').remove();
        console.log(error);

        // 恢复 trigger style
        postAiTrigger.classList.remove('ai-summary-active');
      }
    }
  }

  new GeminiAI();
}

geminiAIImpl();
