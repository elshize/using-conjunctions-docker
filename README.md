# Using Conjunctions for Faster Disjunctive Top-k Queries

This repository contains the source code, scripts, and input data to
reproduce the results published in the following paper
(soon to be published in the Proceedings of WSDM'22):

**Using Conjunctions for Faster Disjunctive Top-k Queries**\
Michal Siedlaczek, Antonio Mallia, and Torsten Suel.\
_Proceedings of the 15th ACM International Conference on Web Search and Data Mining._ 2022.

## Dependencies

This repository contains a Docker image that should pull its own dependencies.
However, for an interested reader, these are the projects used in this work:

- [PISA](https://github.com/pisa-engine/pisa/tree/conjunctions-for-disjunctions) (`conjunctions-for-disjunctions` branch)
- [CIFF](https://github.com/pisa-engine/ciff)
- [intersect](https://github.com/elshize/intersect) (intersection selection code)
