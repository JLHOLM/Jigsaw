<img src="https://user-images.githubusercontent.com/8730447/32693954-511faf46-c702-11e7-99a2-fd8249830fec.png" width="150">

A supervised ML application to determine if two records containing PII (Personally Identifiable Information) are the same person. Utilizes the [Gradient Boosted Decision Trees algorithm](https://en.wikipedia.org/wiki/Gradient_boosting) alongside multiple string metric algorithms.

## Concept
Given two (2) records containg PII, determine if they are the same person.

#### Example Dataset
<img alt="example-dataset" src="https://user-images.githubusercontent.com/8730447/32694951-2f491140-c71c-11e7-84e0-560a1007bf7c.png">

In this dataset, we can see that Bob Dylan and Robert Dylan are the same person. Furthermore, we can see that not _all_ data is required for us to come to that deduction. Visually we can conclude that the two are the same, but it's much more difficult for a computer to do the same.

This is a classic example of data matching. Data matching refers to the process of identifying when two entities are the same entity, such as whether or not two tuples (Bob Dylan, California, 1941/05/24) and (Bob Dilon, CA, 1941/05/24) refer to the same real-world identity. This problem is also referred to as record linkage, entity matching, deduplication, etc.

#### Levenshtein Distance
One method we could use to assist in arriving at a conclusion is to utilize the [Levenshtein distance string metric algorithm](https://en.wikipedia.org/wiki/Levenshtein_distance) to provide weighted values on our data.

Levenshtein distance (LD) is a measure of the similarity between two strings, which we will refer to as the source string (s) and the target string (t). The distance is the number of deletions, insertions, or substitutions required to transform s into t. For example:

- If s is "test" and t is "test", then LD(s,t) = 0, because no transformations are needed. The strings are already identical.
- If s is "test" and t is "tent", then LD(s,t) = 1, because one substitution (change "s" to "n") is sufficient to transform s into t.

Using LD on our example dataset and storing each distance in an array `distances` yields:
```
 => [4, 0, 17, 13, 9, 5, 0, 12]
```
The mean of `distances` gives us an averaged distance of `7.5`. As you can see, our data (in its worst case) is too complex for this algorithm to produce a binary classification of `1` or `0` (yes they are the same, no they aren't the same).

As a result, we must turn to other methods of classifying this data while still utilizing a weighted average; like the one we got from LD.

#### Gradient Boosted Decision Trees
The second method we could use in conjuction with the LD metric is a Gradient Boosted Decision Tree (GBDT). I won't go over how Gradient Boosting works as it's very in-depth. If you're interested, [this blog](https://gormanalysis.com/gradient-boosting-explained/) provides a good overview. I will also assume the you're familiar with [Decision Trees](https://en.wikipedia.org/wiki/Decision_tree).

#### Training Dataset Structure
```
{
  '_id': ['1'],
  'ltable_id': ['1'],
  'rtable_id': ['1'],
  'ltable_first_name': ['Bob'],
  'ltable_last_name': ['Dylan'],
  'ltable_address_street': ['1234 Francisco St'],
  'ltable_address_city': ['San Francisco'],
  'ltable_address_state': ['CA'],
  'ltable_address_zipcode': ['12345'],
  'ltable_date_of_birth': ['1941/05/24'],
  'ltable_phone': ['123-456-7890'],
  'rtable_first_name': ['Robert'],
  'rtable_last_name': ['Dilon'],
  'rtable_address_street': ['Francisco Street'],
  'rtable_address_city': [''],
  'rtable_address_state': ['CA'],
  'rtable_address_zipcode': [''],
  'rtable_date_of_birth': ['1941/05/24'],
  'rtable_phone': [''],
  'prediction': ['1']
}
```
#### Patient A Dataset Structure
```
{
  'id': ['1'],
  'first_name': ['Bob'],
  'last_name': ['Dylan'],
  'address_street': ['1234 Francisco St'],
  'address_city': ['San Francisco'],
  'address_state': ['CA'],
  'address_zipcode': ['12345'],
  'date_of_birth': ['1941/05/24'],
  'phone': ['123-456-7890']
}
```
#### Patient B Dataset Structure
```
{
  'id': ['1'],
  'first_name': ['Robert'],
  'last_name': ['Dilon'],
  'address_street': ['Francisco Street'],
  'address_city': [''],
  'address_state': ['CA'],
  'address_zipcode': [''],
  'date_of_birth': ['1941/05/24'],
  'phone': ['']
}
```
