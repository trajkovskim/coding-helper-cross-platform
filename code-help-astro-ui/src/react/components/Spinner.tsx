import React from 'react';
import css from './Spinner.module.css';

const Spinner: React.FC = () => {
  return <span className={css.loader} />;
};

export default Spinner;