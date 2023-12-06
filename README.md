## API APP_BOOK

>BaseURL: http://app-book-api.cloudns.org:8080/ 

## Rotas e End-Points:

### /auth:
  -  **POST:** */auth/register*
  >Registrar um usuário no sistema

            {
                "name": "teste",
                "username": "teste",
                "password": "teste123"
            }
            
  - **POST:** */auth/*             
  >Efetuar autenticação a partir de JSON

            {
                "username": "delandilucas",
                "password": "admin"
            }

  - **GET:** */auth/{code}*        >
  >Retornar usuário por ID

### /book:
  - **POST:** */book/register*     
  >Registrar um livro no sistema

            {
                "title": "testando",
                "author": "book.testando",
                "gender": "book.testando",
                "sinopse": "book.testando",
                "codeuser": 2
            }

  - **GET:** */book/{code}*        
  >Retornar um livro por ID
  - **GET:** */book/*              
  >Retornar todos os livros do sistema
  - **GET:** */book/user/{code}*   
  >Retornar todos os livros de um Usuário
  - PUT: /book/{code}        
  >Atualizar um livro por ID

            {
                "title": "testando",
                "author": "book.testando",
                "gender": "book.testando",
                "createdat": "2023-11-22 01:54:48.126563",
                "sinopse": "book.testando",
                "codeuser": 2
            }

  - **DELETE:** */book/{code}*     
  >Deletar um livro por ID

### /note:
  -  **POST:** */note/register*    
  >Registrar uma nota no sistema a um livro especifico

            {
                "value": 5,
                "description": "entity.description",
                "codeuser": 2,
                "codebook": 4
            }

  -  **GET:** */note/*             
  >Retornar todas as notas cadastradas no sistema
  -  **GET:** */note/{code}*       
  >Retornar uma nota especifica por ID
  -  **GET:** */note/user/{code}*  
  >Retornar todas as notas de um usuário especifico
  -  **GET:** */note/book/{code}*  
  >Retornar todas as notas de um livro especifico
  -  **PUT:** */note/{code}*       
  >Atualizar uma nota especifica

            {
                "value": 5,
                "description": "entity.description",
                "createdat": "2023-11-22",
                "codeuser": 2,
                "codebook": 4
            }

  -  **DELETE:** */note/{code}*    
  >Deletar uma nota por ID
  


