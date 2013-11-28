# define U as a Bernoulli distribution, whis is just a special case of
# a binomial distribution, where n = 1 (thank you, Wikipedia:
# http://en.wikipedia.org/wiki/Bernoulli_distribution#Properties).
#
# When calling U:
#   trials is how many times the "coin is flipped", so to speak;
#   p is the probability of success, defaults to 0.5 as stipulated in the definition of Bernoulli dist.
#   reps is the number of times we should repeat the number of coin flips specified in <trials>.
#
# Returns the number of successes as a n-element vector, where n == reps.
#
# Example:
#   > U()
#     [1] 0
#   > U(trials=10)
#     [1] 4
#   > U(trials=10, reps=100)
#     [1]  4  6  6  3  6  6  5  5  3  6  3  7  3  8  5  4  4  3  7  8  5  7  5  5  5  5  5  4  7  7 10
#     [32]  0  4  0  7  7  5  4  3  5  1  4  6  4  3  6  6  7  5  8  4  5  4  5  5  3  7  5  6  3  4  3
#     [63]  6  8  6  2  7  2  6  6  8  4  6  2  3  4  7  4  7  6  6  7  2  5  7  5  5  5  4  7  3  4  4
#     [94]  7  7  2  3  4  4  2
U <- function(trials = 1, p = 0.5, reps = 1)
{
    return(rbinom(size = trials, n = reps, prob = p))
}

mixture <- function(m1, sd1, m2, sd2, p)
{
    if(U(p = p))
    {
        # U is 1, therefore sample from X_1 (i.e. use m1 and sd1)
        # cat("True!")
        return(rnorm(mean = m1, sd = sd1, n = 1))
    } else
    {
        return(rnorm(mean = m2, sd = sd2, n = 1))
    }
}