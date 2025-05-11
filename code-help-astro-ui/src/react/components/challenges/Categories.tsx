import React, { useEffect, useState } from 'react';
import type { Category } from '../../../generated/core-api';
import { publicCoreService } from '../../../services';
import useRequest from '../../hooks/useRequest.ts';
import Spinner from '.././Spinner.tsx';
import CategoriesList from './CategoriesList.tsx';

const Categories: React.FC = () => {
  const [categories, setCategories] = useState<Category[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getCategories()
        .then((response) => response.categories)
        .then(setCategories)
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return <CategoriesList categories={categories} />;
};

export default Categories;
