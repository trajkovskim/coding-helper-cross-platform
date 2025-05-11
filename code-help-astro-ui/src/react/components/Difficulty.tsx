import css from './Difficulty.module.css';

interface Props {
  difficulty: 'EASY' | 'MEDIUM' | 'HARD';
}

const Difficulty: React.FC<Props> = ({difficulty}) => {
  return <span className={`${css.difficulty} text-xs ${css[difficulty.toLowerCase()]}`}>{difficulty}</span>;
};

export default Difficulty;