import styles from './index.module.scss';
import 'animate.css';
import { useRef } from 'react';
import { useOutsideAlerter } from '../../customHooks/useOutsideAlerter';

const CommonModal = (props) => {
    const { closeModal, customStyle = {} } = props;
    const wrapperRef = useRef<any>();
    useOutsideAlerter(wrapperRef, closeModal)
    return (
        <div className={`${styles.container} animate__animated animate__fadeIn animate__faster`}>
            <div className={`${styles.innerContainer}  animate__animated animate__slideInUp animate__faster`} ref={wrapperRef} style={{ ...customStyle }}>
                {props.children}
            </div>
        </div>
    )
}

export default CommonModal;