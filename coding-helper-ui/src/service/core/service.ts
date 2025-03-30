import apis from 'service/core/apis';

export const getProblems = () => {
  return apis.problemApi.getProblemEntries();
};

export const getCategories = () => {
  return apis.categoryApi.getCategories();
};
