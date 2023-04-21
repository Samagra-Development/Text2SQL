import styles from './index.module.scss';
import { motion } from 'framer-motion';
import { glowBallVariant1, glowBallVariant2 } from '../variants';
import Link from 'next/link';
import 'animate.css';

export default function Web() {
  return (
    <div className={styles.container}>
      <div className={styles.glowBall1 + ` animate__animated animate__fadeInLeft`}></div>
      <div className={styles.glowBall2 + ` animate__animated animate__fadeInRight`}></div>
      <h1>Natural Language Data Query</h1>
      <div className={styles.btnContainer}>
        <Link href={'/basicInterface'} className={styles.nextLinks}><div>Basic Interface</div></Link>
        <Link href={'/chatInterface'} className={styles.nextLinks}><div>Chat Interface</div></Link>
      </div>
    </div >
  );
}
