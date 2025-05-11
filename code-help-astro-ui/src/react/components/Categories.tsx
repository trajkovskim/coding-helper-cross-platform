import React, { useEffect, useState } from 'react';
import { publicCoreService } from '../../services';
import type { Category } from '../../generated/core-api';
import useRequest from '../hooks/useRequest.ts';
import Spinner from './Spinner.tsx';
import CategoryCard from './CategoryCard.tsx';

const Categories: React.FC = () => {
  const [categories, setCategories] = useState<Category[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getCategories()
        .then((response) => response.categories)
        .then(setCategories),
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return (
    <>
      {categories.map((category) => (
        <CategoryCard key={category.name} name={category.name} description={category.description} />
      ))}
    </>
  );
};

export default Categories;
