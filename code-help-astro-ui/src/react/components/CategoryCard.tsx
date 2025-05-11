import React from "react";
import css from './CategoryCard.module.css';

interface Props {
    name: string;
    description: string;
}

const CategoryCard: React.FC<Props> = (props) => {
  return (
    <div className="card">
      <div className={`text-lg ${css['category-card-header']} pb-sm`}>{props.name}</div>
      <p className={css['category-card-body']}>{props.description}</p>
    </div>
  );
};

export default CategoryCard;
