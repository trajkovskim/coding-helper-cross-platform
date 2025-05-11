import React from 'react';
import css from './CommunityCard.module.css';

interface Props {
  name: string;
  description: string;
}

const CommunityCard: React.FC<Props> = (props) => {
  return (
    <div className="card">
      <div>
        <div className={`text-lg ${css.title}`}>{props.name}</div>
        <div className="description">{props.description}</div>
      </div>
    </div>
  );
};

export default CommunityCard;
