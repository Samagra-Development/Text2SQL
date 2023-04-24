import styles from './index.module.scss';
import Link from 'next/link';
import 'animate.css';

export default function Web() {
  return (
    <div className={styles.container}>
      <div className={styles.glowBall1 + ` animate__animated animate__fadeInLeft`}></div>
      <div className={styles.glowBall2 + ` animate__animated animate__fadeInRight`}></div>
      <h1 className='animate__animated animate__fadeInDown'>Natural Language Data Query</h1>
      <div className={styles.btnContainer}>
        <Link href={'/basicInterface'} className={styles.nextLinks}><div className='animate__animated animate__fadeIn'>Basic Interface</div></Link>
        <Link href={'/chatInterface'} className={styles.nextLinks}><div className='animate__animated animate__fadeIn'>Chat Interface</div></Link>
      </div>
      <style>
        {`
                    body {
                        margin: 0 !important;
                    }
                `}
      </style>
    </div >
  );
}
