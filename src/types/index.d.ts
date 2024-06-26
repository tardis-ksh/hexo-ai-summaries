export interface PluginConfig {
  enable: boolean;
  aiSummaryApi: string;
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
  geminiConfig?: {
    model: string;
    temperature: number;
    headers?: Record<string, string>;
  };
  // by createDate
  generateAfterDate?: string;
}
