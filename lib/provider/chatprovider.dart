import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

class ChatProvider {
  String apiKey = "AIzaSyDy21QzNyTiWKLYhAW-BoT_eW7flqdAG40";
  String nameModelImage = "gemini-1.0-pro-vision-latest";
  String nameModel = "gemini-1.0-pro";
  String instrucoesSistema = """
  Você é um assistente de cozinheiros domésticos, ou seja, só coseguira responder perguntas relacionadas a culinária.
Se caso te perguntarem algo além disso responda que é algo além do seu alcance e você deverá obedecer o estilo json que irei passar.
Se receber uma imagem com uma mensagem, tente associar as duas coisas e me dar uma resposta coerente
Se for somente um texto, tente retornar receitas que correspondem com o que foi pedido
Quero que me retorne um Json exatamente nesse estilo em que as chaves são:
 - result: resultado da requisição
 - textoResposta: seria um texto introdutorio conversando com o usuário, como se tivesse encontrado algumas receitas, ou algum outro tipo de resposta caso não tenha encontrado ou recebeu algo não esperado;
- receitas: é um vetor com várias receitas, ou senão pelo menos uma receita, mas se caso for uma única receita, deve corresponder ao estilo e estar dentro do vetor;
- nomeReceita: é o nome da receita;
- descricao: uma descrição sobre a receita, limite a 150 caracteres
- numPorcoes: seria o número de porções da receita;
- tempo: é quanto tempo gasta para se fazer, deve ser um numero e ele será correpondente a minutos, mas não deve escrever min;
- categoria: é a categoria da receita;
- ingredientes: é um vetor que contem os ingredientes da receita;
- modo de preparo: é um vetor com o passo a passo para se preparar a receita;
      
      Estilo Json:
      {
        "result":
                 {
                  "textoResposta: ,
                  "receitas":[
                               {
                                  "nomeReceita":    ,
                                  "descricao": ,
                                  "numPorcoes":    ,
                                  "tempo": ,
                                  "categoria":  ,
                                  "ingredientes:  [],
                                  "modoDePreparo: []
                                },
		                        ]
                          } 

}
""";
  GenerationConfig config = GenerationConfig(
      temperature: 0.9, topP: 0.95, topK: 32, maxOutputTokens: 2048);

  Future<String?> requestWithImage(String message, File image) async {
    final imageBytes = await image.readAsBytes();
    final model = GenerativeModel(
        model: nameModelImage, apiKey: apiKey, generationConfig: config);
    final content = [
      Content.multi([
        TextPart(instrucoesSistema + message),
        DataPart('image/png', imageBytes),
      ])
    ];
    final response = await model.generateContent(content);
    print(response.text);
    return response.text;
  }

  Future<String?> request(String message) async {
    final model = GenerativeModel(
        model: nameModel, apiKey: apiKey, generationConfig: config);
    final content = [Content.text(instrucoesSistema + message)];
    final response = await model.generateContent(content);
    print(response.text);
    return response.text;
  }

  Future<String?> requestChat(String message, File? image) async{
   return (image != null)? requestWithImage(message, image) :request(message);
  }

  Future<String?> teste() {
    Future<String> str = Future.value("""{
    "result": {
        "textoResposta": "Aqui estão algumas receitas que encontrei para você:",
        "receitas": [
            {
                "nomeReceita": "abacaxi",
                "numPorcoes": 4,
                "tempo": 45,
                "categoria": "Prato Principal",
                "ingredientes": [
                    "4 filés de peito de frango",
                    "Sal e pimenta a gosto",
                    "1 xícara (chá) de farinha de trigo",
                    "2 ovos batidos",
                    "2 xícaras (chá) de farinha de rosca",
                    "Óleo para fritar",
                    "2 xícaras (chá) de molho de tomate",
                    "200g de queijo mussarela fatiado",
                    "100g de presunto fatiado",
                    "Queijo parmesão ralado a gosto"
                ],
                "modoDePreparo": [
                    "Tempere os filés de frango com sal e pimenta a gosto.",
                    "Passe os filés temperados pela farinha de trigo, pelos ovos batidos e, por último, pela farinha de rosca.",
                    "Frite os filés em óleo quente até dourarem dos dois lados. Escorra em papel toalha.",
                    "Em um refratário, coloque uma camada de molho de tomate, os filés de frango fritos, o presunto e a mussarela.",
                    "Repita as camadas até terminarem os ingredientes, finalizando com queijo parmesão ralado por cima.",
                    "Leve ao forno preaquecido a 200°C por cerca de 20 minutos, ou até que o queijo esteja derretido e gratinado.",
                    "Sirva quente acompanhado de arroz branco e salada de alface e tomate."
                ]
            }
        ]
    }
}""");
    return str;
  }


}
