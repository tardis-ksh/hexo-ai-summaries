 .post-gemini-ai {
    cursor: pointer;
    width: max-content;
  }

  .post-gemini-ai > .ai-summary-img {
    margin: 20px 0 !important;
  }

  .post-gemini-ai-result-wrap {
  }

  .post-gemini-ai-result {
    display: inline;
  }

  .ai-typed-cursor {
    opacity: 1;
    animation: ai-type-blink 0.7s infinite;
  }

  .post-gemini-noclick {
    pointer-events: none;
  }

  @keyframes ai-type-blink {
    0% {
      opacity: 1;
    }
    50% {
      opacity: 0;
    }
    100% {
      opacity: 1;
    }
  }
