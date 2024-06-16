import chalk from 'chalk';
import merge from 'lodash.merge';

import generator from '@/generators';
import deploys from '@/deploys';

import { PLUGIN_NAME } from '@/constants';
import { HexoConfig } from '@/types';
import IHexo from '@/types/hexo';

console.log(chalk.bold.bgMagenta(`${PLUGIN_NAME} run, have fun!`));

const DefaultConfig: HexoConfig = {
  enable: true,
};

hexo.config[PLUGIN_NAME] = merge({}, DefaultConfig, hexo.config[PLUGIN_NAME]);

hexo.extend.generator.register(`${PLUGIN_NAME} generator`, generator);

hexo.extend.deployer.register(PLUGIN_NAME, async () => {
  return await deploys(hexo as IHexo);
});
