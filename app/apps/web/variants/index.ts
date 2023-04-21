export const glowBallVariant1 = {
    initial: {
        x: -1000,
        opacity: 0
    },
    animate: {
        x: 0,
        opacity: 1,
        transition: {
            type: 'spring',
            mass: 0.5,
            duration: 2,
            dealy: 0.5
        }
    }
}

export const glowBallVariant2 = {
    initial: {
        x: 1000,
        opacity: 0
    },
    animate: {
        x: 0,
        opacity: 1,
        transition: {
            type: 'spring',
            mass: 0.5,
            duration: 2,
            delay: 0.7
        }
    }
}

export const rightContainerVariant = {
    initial: {
        x: 100000,
        opacity: 0
    },
    animate: {
        x: 0,
        opacity: 1,
        transition: {
            type: 'spring',
            mass: 0.1,
            duration: 1
        }
    }
}