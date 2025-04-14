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

.post-gemini-ai .ai-summary-active .ai-summary-icon-title text:first-of-type {
    display: none !important;
}
.post-gemini-ai .ai-summary-active .ai-summary-icon-title text:last-child {
    display: initial !important;
}
.post-gemini-ai .ai-summary-active #r rect {
    width: 105px !important;
}
.post-gemini-ai .ai-summary-active .ai-summary-rect {
    width: 80px !important;
}
.post-gemini-ai text::before {
    content: attr(data-content)
}
.post-gemini-ai .ai-summary-pen {
    opacity: 1;
    animation: ai-wink 2s infinite;
}

@keyframes ai-wink {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}
