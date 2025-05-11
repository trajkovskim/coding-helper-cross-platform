import React from 'react';
import type { Category } from '../../../generated/core-api';
import styles from './CategoriesList.module.css';

interface Props {
  categories: Category[];
  onCategorySelect?: (category: Category) => void;
}

const CategoriesList: React.FC<Props> = ({ categories, onCategorySelect }) => {
  return (
    <div className={styles['categories-list']}>
      <h2 className="text-xl font-bold mb-4 pb-md">Categories</h2>
      <div className={styles.categories}>
        {categories.map((category) => (
          <span key={category.name} className={styles.category} onClick={() => onCategorySelect?.(category)}>
            {category.name} - {category.problemsCount}
          </span>
        ))}
      </div>
    </div>
  );
};

export default CategoriesList;
