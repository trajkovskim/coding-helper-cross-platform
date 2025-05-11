import React from 'react';
import type { ContestEntry } from '../../../generated/core-api';
import UpcomingContestCard from '../UpcomingContestCard';
import css from './FeaturedContestsList.module.css';

interface Props {
    contests: ContestEntry[];
}

const FeaturedContestsList: React.FC<Props> = (props) => {
    return (
        <div className={css['featured-contests']}>
            {props.contests.map((contest) => <UpcomingContestCard key={contest.id} {...contest} />)}
        </div>
    );
};

export default FeaturedContestsList;