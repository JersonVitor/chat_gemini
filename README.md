# Chat_Gemini

## Descrição

O Chat_Gemini é um projeto que utiliza o modelo Gemini para interpretar imagens e textos enviados pelos usuários, fornecendo receitas culinárias de acordo com a solicitação. Os usuários podem enviar fotos de pratos ou ingredientes, ou simplesmente textos pedindo receitas específicas.

## Funcionalidades

- Envio de fotos de pratos ou ingredientes para obter a receita correspondente.
- Envio de textos com pedidos de receitas específicas.
- Retorno de receitas detalhadas incluindo nome, descrição, número de porções, tempo de preparo, categoria, ingredientes e modo de preparo.

## Estrutura da Resposta

O modelo Gemini retorna um JSON no seguinte formato:

```json
{
  "result": {
    "textoResposta": "",
    "receitas": [
      {
        "nomeReceita": "",
        "descricao": "",
        "numPorcoes": "",
        "tempo": "",
        "categoria": "",
        "ingredientes": [],
        "modoDePreparo": []
      }
    ]
  }
}
```
## Requisitos
- Gemini 1.0 para interpretação de textos.
- Gemini 1.0 Pro Vision para interpretação de imagens e textos.
