# Inlämningsuppgift

Artificiell Intelligens (AI)

Grupp 02:
Alexandra Jansson alja5888,
Tyr Hullmann tyhu6316,
Martin Hansson maha6445

## Beskrivning

Denna uppgift är implementerad i Google Colab. För att köra koden, gå in på [länken](https://colab.research.google.com/drive/13E4HYiQ_05-nc61w_c2PD-_Ta4Df4BlZ?usp=sharing) och kör cellerna en och en. Cellerna har tillhörande beskrivningar som ger kontext till koden för cellen.

Uppgiften baseras på kod från [Tensorflow](https://www.tensorflow.org/decision_forests/tutorials/beginner_colab) för `RandomForestModel` och `GradientBoostedTreesModel` samt kod från [scikit-learn](https://scikit-learn.org/stable/modules/generated/sklearn.tree.DecisionTreeClassifier.html) för `DecisionTreeClassifier`. Modellerna visualiseras med hjälp av [dtreeviz](https://github.com/parrt/dtreeviz) och koden baseras på exemplen för att visualisera träd.

Agenten är en lärandeagent som ska lära sig en modell för att klassificera en klass till ett exempel givet en mängd features. Datasettet som används är [Dry Bean](https://archive.ics.uci.edu/dataset/602/dry+bean+dataset) från UCI Machine Learning Repository. Datasettet innehåller 13 611 exempel, där varje exempel har 16 features och en label. Det finns 7 möjliga klasser: Seker, Barbunya, Bombay, Cali, Horoz, Sira och Dermason. Alla klasserna är typer av bönor. Features är olika karaktärer på bönorna såsom formen, måtten och strukturen på bönan. Agenten ska lära sig att klassificera vilken label som bönan tillhör utav dessa features.

För att uppnå detta använder vi en [DecisionTreeClassifier](https://scikit-learn.org/stable/modules/generated/sklearn.tree.DecisionTreeClassifier.html) från scikit-learn paketet. Vi jämför DecisionTree mot med två varianter av ensemble learning: [RandomForest](https://www.tensorflow.org/decision_forests/api_docs/python/tfdf/keras/RandomForestModel) och [GradientBoostedForest](https://www.tensorflow.org/decision_forests/api_docs/python/tfdf/keras/GradientBoostedTreesModel) från TensorFlow.
