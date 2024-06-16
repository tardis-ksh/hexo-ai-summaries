import Hexo from '@/types/hexo';

const generator = async (local: Hexo['Site']): Hexo['Return'] => {
  console.log(local);
  return {
    path: 'path',
    data: 'data',
  };
};

export default generator;
