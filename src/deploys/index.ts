import Hexo from '@/types/hexo';
import { PLUGIN_NAME } from '@/constants';

const deploys = async (local: Hexo) => {
  const pluginConfig = local.config[PLUGIN_NAME];

  console.log(pluginConfig);
};

export default deploys;
