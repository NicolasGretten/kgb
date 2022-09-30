class WorldOfWarcraft {
  static questions() {
    const jsonsString = {
      "data": [
        {
          "id":"1",
          "content": "Qui est-ce ?",
          "rightAnswer": "Le Roi Liche",
          "propositions": ["papa", "Bébou <3", "Le roi liche", "Arthas"],
          "image":
              "https://static.wikia.nocookie.net/wow/images/b/b0/WotLKArthasPose.jpg/revision/latest?cb=20110130191540&path-prefix=fr",
        },
        {
          "id":"2",
          "content": "Qui est Sargeras ?",
          "rightAnswer": "Un titan",
          "propositions": ["Un titan", "le méchant", "Bébou ?", "le sauveur"],
        },
        {
          "id":"3",
          "content": "Quel est le level max à l'extension Woltk ?",
          "rightAnswer": "80",
          "propositions": ["60", "110", "80", "10"],
        },
        {
          "id":"4",
          "content": "Comment s'apelle le raid disponible aux pic foudroyés ?",
          "rightAnswer": "Ulduar",
          "propositions": [],
        },
        {
          "id":"5",
          "content": "Comment s'apelle la monture du roi liche ?",
          "rightAnswer": "l'invinsible",
          "propositions": [
            "l'invinsible",
            "les cendres d'Alar",
            "la tête de mimiron",
            "un cheval"
          ],
        },
      ]
    };

    return jsonsString;
  }
}
