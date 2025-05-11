import React from 'react';
import css from './UpcomingContestCard.module.css';

interface Props {
  id: number;
  name: string;
  description: string;
  startDate: Date;
  duration: string;
}

const UpcomingContestCard: React.FC<Props> = (props) => {
  const getStartDateWeekday = () => {
    return props.startDate.toLocaleDateString(undefined, { weekday: 'long' }).toUpperCase();
  };

  return (
    <div className={`card ${css.card}`}>
      <div className={css['start-date-container']}>
        <div className="text-xl">{getStartDateWeekday()}</div>
        <div>{props.startDate.toLocaleDateString()}</div>
        <div>{props.startDate.toLocaleTimeString()}</div>
      </div>
      <div className={css['card-content']}>
        <div>
          <div className={`text-lg ${css.title}`}>{props.name}</div>
          <div className={css.duration}>
            Duration:
            <span>{props.duration}</span>
          </div>
        </div>
        <div className={css.body}>{props.description}</div>
      </div>
    </div>
  );
};

export default UpcomingContestCard;
