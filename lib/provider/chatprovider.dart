import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

class ChatProvider{
   String apiKey = "AIzaSyDy21QzNyTiWKLYhAW-BoT_eW7flqdAG40";
   String nameModelImage = "gemini-1.0-pro-vision-latest";
   String nameModel = "gemini-1.0-pro";
   GenerationConfig config = GenerationConfig(
     temperature: 0.9,
     topP: 0.95,
     topK: 32,
     maxOutputTokens: 1024
   );
   String instrucoesSistema = """\nQuero a saida nesse formato Json:
                                "request":
                                         {
                                            "textoIntroducao: ,
                                            "receitas":{
                                                          "nomeReceita":    ,
                                                          "ingredientes:  [],
                                                          "modoDePreparo: []
                                            }
                                         } 
                              """;

   Future<String?> requestWithImage(String message, File image) async{
     final imageBytes = await image.readAsBytes();
     final model = GenerativeModel(
         model: nameModelImage,
         apiKey: apiKey,
         generationConfig: config);
     final content = [
       Content.multi([
         TextPart(instrucoesSistema+message),
         DataPart('image/png',imageBytes),
       ])
     ];
     final response = await model.generateContent(content);
     print(response.text);
     return response.text;
   }
   Future<String?> request(String message) async{
     final model = GenerativeModel(
         model: nameModel,
         apiKey: apiKey,
         generationConfig: config);
     final content = [
       Content.text(instrucoesSistema+message)
     ];
     final response = await model.generateContent(content);
     print(response.text);
     return response.text;
   }
   Future<String?> teste(){
     Future<String> str = Future.value( """{
    "result": {
        "textoResposta": "Aqui estão algumas receitas que encontrei para você:",
        "receitas": [
            {
                "nomeReceita": "Frango à Parmegiana",
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