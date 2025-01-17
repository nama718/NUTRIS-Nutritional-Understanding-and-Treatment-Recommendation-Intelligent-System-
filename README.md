# NUTRIS-Nutritional-Understanding-and-Treatment-Recommendation-Intelligent-System



Hack Reason Project: Developed by: Aman Balam, Pratik Mukesh Manghwani, Nikhil Sesha Sai Kondapalli

# Inspiration
In India, malnutrition among children remains a significant public health challenge, contributing to malnutrition conditions. With millions of children affected, the consequences can be life-long, affecting education, physical growth, and even cognitive development. The tool was developed to assist in identifying malnutrition risks among children, providing solutions based on symptoms, socioeconomic conditions, and nutritional habits to help improve child health outcomes.

# What it does
Our system is designed to assess the nutritional health of children, diagnose malnutrition levels, and offer tailored interventions. The program classifies children into different malnutrition categories by analyzing factors like body measurements, symptoms, socio-economic background, diet, and lifestyle. It also provides dietary recommendations and guides parents and caregivers on interventions such as breastfeeding, supplementary feeding, sanitation improvements, and medical consultation based on the child’s specific needs.

Once the system identifies the malnutrition status (e.g., stunting, wasting, underweight, or normal), it uses additional data such as dietary intake, activity levels, and micronutrient deficiencies to recommend the necessary actions, including government programs and healthcare services. The system can also track progress over time to adapt the recommendations.

# How we built it
We began by understanding the different aspects contributing to malnutrition. Using available datasets for children’s height, weight, activity, and socioeconomic status, we built logical rules in Prolog that could classify children’s malnutrition levels. The system was designed to integrate data about food intake, lifestyle, and micronutrient status and link this information to relevant medical, social, and governmental resources.

We identified key malnutrition indicators through collaboration and research, including BMI, growth standards, caloric intake, and nutrient deficiencies. These factors, combined with the socio-economic background, allowed us to develop a Prolog program that accurately assesses whether a child is at risk for malnutrition and how best to address these risks.

# Challenges we ran into
Complexity in determining malnutrition that we wanted to factor: Determining the precise nutritional status of children based on multiple factors (growth, activity, and socio-economic conditions) presented a challenge in combining various rules, and deciding what factors to consider in creating the program.

Inconsistent data sources: The data sources for malnutrition indicators, including food intake and socioeconomic background, were limited and inconsistent across regions, which made it challenging to create a universally applicable model.

Debugging the Prolog rules: Understanding syntax and inbuilt properties was a challenge which we had to overcome. 

Defining accurate interventions: While nutritional assessment was clear, determining the specific intervention based on the child’s unique needs was complex, requiring an integrated approach from both healthcare and social resources.


# Accomplishments that we're proud of
Effective use of Prolog for health assessment: We were able to build a system that uses logical programming to assess nutritional health accurately and offer targeted interventions.


Customizable recommendations: Our system is designed to adjust its recommendations based on real-time input, making it adaptable to individual children and their specific needs.
Integration of multiple data sources: By combining growth data, socio-economic conditions, and nutritional information, the system can offer a holistic view of a child’s health status.

Identification of malnutrition levels: The system can effectively classify malnutrition as severe, moderate, mild, or normal, offering actionable insights for parents and caregivers.
What we learned


s(CASP) as a tool for health assessment: We learned how to use s(CASP) to reason about complex health-related data and provide logical, data-driven recommendations.
Holistic approach to health: Our approach helped us realize the importance of integrating multiple health-related factors (diet, growth, socio-economic conditions) to create a more accurate health profile.


Designing for impact: Understanding how our tool can influence the well-being of children and guide interventions has shaped our approach to designing practical health solutions.

# What's next
To enhance our tool further, we plan to integrate more localized data on food availability and nutrition. We also want to extend the tool to include adult malnutrition detection and expand the database to cover more regions. Feedback from healthcare professionals, social workers, and policymakers will be critical in refining the system and ensuring it provides effective, practical interventions. Furthermore, we aim to automate data collection for real-time monitoring and continuous health tracking.

# Built With
Prolog and s(CASP): For logical reasoning and commonsense based reasoning
Integrated Data Sources: ICMR, Official Government Reports
