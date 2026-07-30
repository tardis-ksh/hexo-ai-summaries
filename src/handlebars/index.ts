import handlebars from 'handlebars';

// skip parse
handlebars.registerHelper('raw', function (options) {
  return options.toString();
});

handlebars.registerHelper('json', function (value) {
  return value === undefined ? 'undefined' : JSON.stringify(value);
});

// parse if
handlebars.registerHelper('if_eq', function (this: unknown, a, b, opts) {
  if (a === b) {
    return opts.fn(this);
  }
  return opts.inverse(this);
});

// ifOr
handlebars.registerHelper(
  'ifOr',
  function (this: unknown, arg1, arg2, options) {
    if (arg1 || arg2) {
      return options.fn(this);
    }
    return options.inverse(this);
  },
);

const generateTemplate = (content: string, config: object) => {
  const template = handlebars.compile(content, { noEscape: true });
  return template(config);
};

export default generateTemplate;
