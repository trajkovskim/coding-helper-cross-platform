import React from 'react';
import Difficulty from './Difficulty.tsx';
import css from './ChallengeCard.module.css';

interface Props {
  id: number;
  name: string;
  description: string;
  category: string;
  difficulty: 'EASY' | 'MEDIUM' | 'HARD';
  likes: number;
}

const ChallengeCard: React.FC<Props> = (props) => {
  return (
    <div className="card">
      <div className={css['card-header']}>
        <div>
          <span className={`text-lg ${css.title}`}>{props.name}</span>
          <div className={`text-sm ${css.category}`}>{props.category}</div>
        </div>
        <Difficulty difficulty={props.difficulty} />
      </div>
      <div className={css['card-body']}>{props.description}</div>
      <div className={`${css['card-footer']} text-sm`}>Liked by {props.likes} users</div>
    </div>
  );
};

export default ChallengeCard;
