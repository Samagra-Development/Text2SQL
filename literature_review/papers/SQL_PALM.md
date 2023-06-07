To contribute kindly follow the following framework:
1. Name of the paper 
* [SQL-PALM: IMPROVED LARGE LANGUAGE
MODELADAPTATION FOR TEXT-TO-SQL](https://arxiv.org/pdf/2306.00739.pdf)  
2. The datatset Used 
* [Spider](https://yale-lily.github.io/spider)
3. The model Used 
* PaLM-2 and it's variations
4. Novelty introduced
* Fine-tuned SQL-PaLM 
5. How it can be integrated in the project 
* (To be reviewed and discussed)
6. Additional information you believe will be helpful 
* Fine-tuned SQL-PaLM adapts large-sized LLMs (PaLM-2) to domain-specific Text-to-SQL data through fine-tuning on the Spider train split, The fine tuned model further acheives better result than the few-shot model
* Section 3 provides a good summary of the different kinds of datasets and models employed to create a baseline testing enviornmnet 
* **The fine-tuned SQL-PaLM model achieves a test-suite accuracy of 78.2% on the Spider dataset. On the other hand, ChatGPT, evaluated with the OpenAI-default prompt, achieves a test-suite accuracy of 60.1%.**
* The further sections talk about the real life usage of the said models and the future scope they provide and what more work can be done on them