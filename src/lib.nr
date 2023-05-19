use dep::std;

struct Signed {
    x: u124,
    is_neg: bool,
}

impl Signed {
    fn add(self, other: Self) -> Self {
        let mut val: u124 = 0;
        let mut is_neg = false;

        if (!(self.is_neg ^ other.is_neg)) { //if signs are the same
            val = self.x + other.x;
            is_neg = self.is_neg;
        } else {
            if (self.x > other.x) {
                val = self.x - other.x;
                is_neg = self.is_neg;
            } else {
                val = other.x - self.x;
                is_neg = other.is_neg;
            }

            if (val == 0) {
              is_neg = false;
            }
        }

        Self {
            x: val,
            is_neg: is_neg,
        }
    }

    fn sub(self, other: Self) -> Self {
        self.add(other.flip())
    }

    fn mul(self, other: Self) -> Self {
        let val = self.x * other.x;
        let mut is_neg: bool = false;
        if (val != 0) {
            is_neg = self.is_neg ^ other.is_neg;
        }

        Self {
            x: val,
            is_neg: is_neg,
        }
    }

    fn div(self, other: Self) -> Self {
        let val = self.x / other.x;
        let mut is_neg: bool = false;
        if (val != 0) {
            is_neg = self.is_neg ^ other.is_neg;
        }

        Self {
            x: val,
            is_neg: is_neg,
        }
    }

    fn muli(self, other: u124) -> Self {
        Self {
            x: self.x * other,
            is_neg: self.is_neg,
        }
    }

    fn eq(self, other: Self) -> bool {
        (self.x == other.x) & (self.is_neg == other.is_neg)
    }

    fn squared(self) -> Self {
        Self {
            x: self.x * self.x,
            is_neg: false,
        }
    }

    fn flip(self) -> Self {
        Self {
            x: self.x,
            is_neg: !self.is_neg & (self.x != 0),
        }
    }

    fn abs(self) -> Self {
        Self {
            x: self.x,
            is_neg: false,
        }
    }

    fn absi(self) -> u124 {
        self.x
    }

    fn zero() -> Self {
        Self {
            x: 0,
            is_neg: false,
        }
    }

    fn toSigned(val: u124) -> Self {
        Self {
            x: val,
            is_neg: false,
        }
    }
}

#[test]
fn test_commutativity() {
    let a1 = Signed::toSigned(5);           // 5
    let a2 = Signed::toSigned(8).flip();    // -8

    constrain a1.add(a2).eq(a2.add(a1));
}

#[test]
fn test_identites() {
    let zero = Signed::zero();
    let one = Signed::toSigned(1);

    let a1 = Signed::toSigned(5);           // 5
    let a2 = Signed::toSigned(8).flip();    // -8

    constrain a1.mul(zero).eq(zero);
    constrain a2.mul(zero).eq(zero);

    // Additive identity
    constrain one.add(zero).eq(one);
    constrain a1.add(zero).eq(a1);
    constrain a2.add(zero).eq(a2);
    constrain a1.add(zero).absi() == 5;      // Sanity check on eq

    // Multiplicative identity
    constrain zero.mul(one).eq(zero);
    constrain a1.mul(one).eq(a1);
    constrain a2.mul(one).eq(a2);
}

#[test]
fn test_inverse() {
    let zero = Signed::zero();
    let a1 = Signed::toSigned(5);           // 5
    let a2 = Signed::toSigned(8).flip();    // -8

    constrain a1.add(a1.flip()).eq(zero);
    constrain a2.add(a2.flip()).eq(zero);
}

#[test]
fn test_general() {
    let a1 = Signed::toSigned(5);           // 5
    let a2 = Signed::toSigned(2);           // 2
    let a3 = Signed::toSigned(8).flip();    // -8
    let a4 = Signed::toSigned(10).flip();   // -10

    constrain a1.add(a2).eq(Signed::toSigned(7));               // 5+2=7
    constrain a1.add(a3).eq(Signed::toSigned(3).flip());        // 5+(-8)=-3
    constrain a4.add(a3).eq(Signed::toSigned(18).flip());       // -8+(-10)=-18
    
    constrain a3.sub(a4).eq(Signed::toSigned(2));               // -8-(-10)=2
    constrain a2.sub(a1).eq(Signed::toSigned(3).flip());        // 2-5=-3
    constrain a4.sub(a1).eq(Signed::toSigned(15).flip());       // -10-5=-15
    constrain a1.sub(a4).eq(Signed::toSigned(15));              // 5-(-10)=15

    constrain Signed::zero().is_neg == false;
    constrain Signed::zero().flip().is_neg == false;
}