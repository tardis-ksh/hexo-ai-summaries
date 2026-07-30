export interface PluginConfig {
  PACKAGE_VERSION: string;
  enable: boolean;
  aiSummaryApi?: string;
  prompt?: string;
  maxToken?: number;
  customHtml?: {
    htmlFile: string;
    jsFile: string;
    styleFile: string;
  };
  tagConfig?: Partial<{
    title: string;
    content: string;
    toc: string;
  }>;
  aiConfig?: {
    model: string;
    apiMode?: 'chat-completions' | 'responses';
    temperature?: number;
    headers?: Record<string, string>;
    idempotentHeader?: boolean;
    stream?: boolean;
  };
  // by createDate
  generateAfterDate?: string;
}
