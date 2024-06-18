import handlebars from 'handlebars';

// skip parse
handlebars.registerHelper('raw', function (options) {
  return options.toString();
});

const generateTemplate = (content: string, config: Record<string, any>) => {
  const template = handlebars.compile(content, { noEscape: true });
  return template(config);
};

export default generateTemplate;
