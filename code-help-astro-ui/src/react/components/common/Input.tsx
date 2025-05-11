import React from "react"
import styles from './Input.module.css'

interface Props extends React.InputHTMLAttributes<HTMLInputElement> {
    label?: string;
    error?: string;
    fullWidth?: boolean;
}

const Input = React.forwardRef<HTMLInputElement, Props>(
    ({ label, error, fullWidth = false, className = '', ...props }, ref) => {
        return (
            <div className={`${styles['input-container']} ${fullWidth ? styles['full-width'] : ''}`}>
                {label && (
                    <label className={styles['input-label']}>
                        {label}
                    </label>
                )}
                <input
                    ref={ref}
                    className={`
                        ${styles['input-field']}
                        ${error ? styles['input-error'] : ''} 
                        ${fullWidth ? styles['full-width'] : ''} 
                        ${className}
                    `}
                    {...props}
                />
                {error && (
                    <span className={styles['error-message']}>
                        {error}
                    </span>
                )}
            </div>
        );
    }
);

Input.displayName = 'Input';

export default Input;
