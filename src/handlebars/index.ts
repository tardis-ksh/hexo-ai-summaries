import handlebars from 'handlebars';

// skip parse
handlebars.registerHelper('raw', function (options) {
  return options.toString();
});

// parse if
handlebars.registerHelper('if_eq', function (a, b, opts) {
  if (a === b) {
    return opts.fn(this);
  }
  return opts.inverse(this);
});

const generateTemplate = (content: string, config: Record<string, any>) => {
  const template = handlebars.compile(content, { noEscape: true });
  return template(config);
};

export default generateTemplate;
