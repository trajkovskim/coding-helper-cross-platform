import apis from 'service/forum/apis';

export const getCategories = () => {
  return apis.categoryApi.getAllCategories();
};
