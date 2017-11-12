<img src="https://user-images.githubusercontent.com/8730447/32693954-511faf46-c702-11e7-99a2-fd8249830fec.png" width="150">

A supervised ML application to determine if two records containing PII (Personally Identifiable Information) are the same person. Utilizes the [Gradient Boosted Decision Trees algorithm](https://en.wikipedia.org/wiki/Gradient_boosting).

## Concept
Given two (2) records containg PII, determine if they are the same person.

#### Example Dataset
<img alt="example-dataset" src="https://user-images.githubusercontent.com/8730447/32694951-2f491140-c71c-11e7-84e0-560a1007bf7c.png">

In this dataset, we can see that Bob Dylan and Robert Dylan are the same person. Furthermore, we can see that not _all_ data is required for us to come to that deduction. Visually we can conclude that the two are the same, but it's much more difficult for a computer to do the same.

#### Proposed Original Method
One other method we could use to arrive at a conclusion is to utilize the [Levenshtein distance string metric algorithm](https://en.wikipedia.org/wiki/Levenshtein_distance), though, this can become very slow depending on the size of our dataset and is sometimes unreliable.

##### What is Levenshtein distance?
Levenshtein distance (LD) is a measure of the similarity between two strings, which we will refer to as the source string (s) and the target string (t). The distance is the number of deletions, insertions, or substitutions required to transform s into t. For example:

- If s is "test" and t is "test", then LD(s,t) = 0, because no transformations are needed. The strings are already identical.
- If s is "test" and t is "tent", then LD(s,t) = 1, because one substitution (change "s" to "n") is sufficient to transform s into t.
