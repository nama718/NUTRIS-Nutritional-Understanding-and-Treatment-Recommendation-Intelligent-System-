% s(CASP) Programming
:- use_module(library(scasp)).
:- use_module(library(lists)).

% Suppress warnings
:- style_check(-discontiguous).
:- style_check(-singleton).
%:- set_prolog_flag(scasp_unknown, fail).

/* 
Main predicate: assess/8
Usage: assess(+Age, +Weight, +Height, +Illness, +Diet, +Breastfeeding, +Sanitation, -Assessment)
Parameters:
- Age: Age in months (number)
- Weight: Weight in kg (number)
- Height: Height in meters (number)
- Illness: yes/no
- Diet: limited/diverse
- Breastfeeding: adequate/inadequate
- Sanitation: poor/good
- Assessment: List of recommendations and explanations
*/

% Input validation
validate_inputs(Age, Weight, Height, Illness, Diet, Breastfeeding, Sanitation) :-
    number(Age), Age >= 0, Age =< 1200,
    number(Weight), Weight > 0,
    number(Height), Height > 0,
    member(Illness, [yes, no]),
    member(Diet, [limited, diverse]),
    member(Breastfeeding, [adequate, inadequate]),
    member(Sanitation, [poor, good]).

% Safe list operations
safe_append([], L, L) :- !.
safe_append([H|T], L, [H|R]) :- 
    safe_append(T, L, R).

% Age categories
child_under_6months(Age) :- Age =< 6, !.
child_6months_to_2years(Age) :- Age > 6, Age =< 24, !.
child_2_to_15years(Age) :- Age > 24, Age =< 180, !.
adult(Age) :- Age > 180, Age =< 1200, !.

% BMI Classification with age-specific ranges
bmi_range(BMI, Age, Category) :-
    child_under_6months(Age),
    (BMI >= 13 -> Category = normal
    ;BMI >= 12 -> Category = mild_malnutrition
    ;BMI >= 11 -> Category = moderate_malnutrition
    ;Category = severe_malnutrition
    ), !.

bmi_range(BMI, Age, Category) :-
    child_6months_to_2years(Age),
    (BMI >= 16 -> Category = normal
    ;BMI >= 15 -> Category = mild_malnutrition
    ;BMI >= 14 -> Category = moderate_malnutrition
    ;Category = severe_malnutrition
    ), !.

bmi_range(BMI, _, Category) :- % Default ranges for older children/adults
    (BMI >= 18.5 -> Category = normal
    ;BMI >= 17 -> Category = mild_malnutrition
    ;BMI >= 16 -> Category = moderate_malnutrition
    ;Category = severe_malnutrition
    ), !.

% BMI calculation and categorization
bmi_category(Weight, Height, Age, Category) :-
    BMI is Weight / (Height * Height),
    BMI > 0,
    bmi_range(BMI, Age, Category).

% Feeding recommendations
feeding_recommendation(Age, _, Recommendations) :-
    child_under_6months(Age),
    Recommendations = [
        exclusive_breastfeeding,
        frequent_feeding_8_12_times,
        proper_latching_technique
    ], !.

feeding_recommendation(Age, _, Recommendations) :-
    child_6months_to_2years(Age),
    Recommendations = [
        continued_breastfeeding,
        soft_nutritious_foods,
        feeding_frequency_5_6_times,
        diverse_food_groups
    ], !.

feeding_recommendation(_, _, [regular_balanced_diet]) :- !.

% Nutrient recommendations
nutrient_recommendations(Category, _, Recommendations) :-
    (Category = moderate_malnutrition; Category = severe_malnutrition),
    Recommendations = [
        protein_rich_foods,
        energy_dense_foods,
        micronutrient_supplements,
        therapeutic_foods
    ], !.

nutrient_recommendations(_, _, []) :- !.

% Follow-up schedule
follow_up_schedule(mild_malnutrition, Schedule) :-
    Schedule = [
        first_follow_up(weeks(2)),
        regular_follow_up(months(3)),
        growth_monitoring,
        dietary_assessment
    ], !.

follow_up_schedule(moderate_malnutrition, Schedule) :-
    Schedule = [
        first_follow_up(weeks(1)),
        regular_follow_up(months(1)),
        weight_monitoring(weekly),
        dietary_compliance_check
    ], !.

follow_up_schedule(severe_malnutrition, Schedule) :-
    Schedule = [
        immediate_follow_up(days(1)),
        hospital_monitoring(daily),
        weight_monitoring(daily),
        clinical_assessment(daily)
    ], !.

follow_up_schedule(normal, [routine_checkup(months(6))]) :- !.
follow_up_schedule(_, []) :- !.

% Sanitation recommendations
sanitation_recommendations(poor, Recommendations) :-
    Recommendations = [
        hand_washing_practices,
        safe_water_storage,
        food_hygiene,
        proper_waste_disposal,
        environmental_cleanliness
    ], !.

sanitation_recommendations(_, []) :- !.

% Meal planning module interface
meal_plan_needed(Category, Diet, true) :-
    (Category = moderate_malnutrition; 
     Category = severe_malnutrition;
     Diet = limited), !.
meal_plan_needed(_, _, false) :- !.

meal_plan_parameters(Age, Category, Diet, Parameters) :-
    meal_plan_needed(Category, Diet, true),
    calculate_calorie_requirement(Age, Category, CaloriesPerDay),
    calculate_meal_frequency(Age, Category, MealFreq),
    Parameters = [
        age(Age),
        category(Category),
        current_diet(Diet),
        meal_frequency(MealFreq),
        calories_per_day(CaloriesPerDay)
    ], !.
meal_plan_parameters(_, _, _, []) :- !.

% Helper predicates for meal planning
calculate_calorie_requirement(Age, Category, CaloriesPerDay) :-
    base_calories(Age, BaseCalories),
    calorie_multiplier(Category, Multiplier),
    CaloriesPerDay is BaseCalories * Multiplier.

base_calories(Age, Calories) :-
    child_under_6months(Age), !, Calories = 550;
    child_6months_to_2years(Age), !, Calories = 850;
    child_2_to_15years(Age), !, Calories = 1500;
    Calories = 2000.

calorie_multiplier(severe_malnutrition, 1.5) :- !.
calorie_multiplier(moderate_malnutrition, 1.3) :- !.
calorie_multiplier(mild_malnutrition, 1.1) :- !.
calorie_multiplier(_, 1.0) :- !.

calculate_meal_frequency(Age, Category, Freq) :-
    child_under_6months(Age), !, Freq = 8;
    child_6months_to_2years(Age), !, Freq = 6;
    (Category = severe_malnutrition; Category = moderate_malnutrition), !, Freq = 6;
    Freq = 3.

% Treatment plans
treatment_plan(_, normal, _, _, _, _, [no_action_needed]) :- !.

treatment_plan(_, severe_malnutrition, _, _, _, _, Plan) :-
    Plan = [
        immediate_hospitalization,
        custom_feeding_plan,
        regular_testing,
        therapeutic_feeding,
        medical_monitoring
    ], !.

treatment_plan(Age, Category, Illness, Diet, Breastfeeding, Sanitation, Plan) :-
    (Category = mild_malnutrition; Category = moderate_malnutrition),
    (child_under_6months(Age) -> 
        build_infant_plan(Illness, Breastfeeding, Sanitation, Category, Plan)
    ;child_6months_to_2years(Age) -> 
        build_toddler_plan(Illness, Diet, Breastfeeding, Sanitation, Category, Plan)
    ;build_general_plan(Illness, Diet, Sanitation, Category, Plan)
    ).

% Build specific treatment plans
build_infant_plan(Illness, Breastfeeding, Sanitation, Category, Plan) :-
    base_plan(Category, BasePlan),
    (Illness = yes -> safe_append([doctor_consultation], BasePlan, P1) ; P1 = BasePlan),
    (Breastfeeding = inadequate -> 
        safe_append([breastfeeding_support, milk_supplementation], P1, P2) 
    ; P2 = P1),
    (Sanitation = poor -> safe_append([sanitation_improvement], P2, Plan) ; Plan = P2).

build_toddler_plan(Illness, Diet, Breastfeeding, Sanitation, Category, Plan) :-
    base_plan(Category, BasePlan),
    (Illness = yes -> safe_append([doctor_consultation], BasePlan, P1) ; P1 = BasePlan),
    (Diet = limited -> safe_append([balanced_diet_recommendation], P1, P2) ; P2 = P1),
    (Breastfeeding = inadequate -> 
        safe_append([breastfeeding_support, soft_home_food], P2, P3) 
    ; P3 = P2),
    (Sanitation = poor -> safe_append([sanitation_improvement], P3, Plan) ; Plan = P3).

build_general_plan(Illness, Diet, Sanitation, Category, Plan) :-
    base_plan(Category, BasePlan),
    (Illness = yes -> safe_append([doctor_consultation], BasePlan, P1) ; P1 = BasePlan),
    (Diet = limited -> safe_append([balanced_diet_recommendation], P1, P2) ; P2 = P1),
    (Sanitation = poor -> safe_append([sanitation_improvement], P2, Plan) ; Plan = P2).

% Base treatment plans
base_plan(mild_malnutrition, [dietary_recommendations, retest_3_months]).
base_plan(moderate_malnutrition, [supplementary_feeding_program, counseling, retest_1_month]).

% Government policy recommendations
govt_policy_recommendation(Age, Recommendations) :-
    (child_under_6months(Age) -> 
        Recommendations = [anganwadi_services, ngo_support, nutrition_counseling]
    ;child_6months_to_2years(Age) -> 
        Recommendations = [anganwadi_services, ngo_support, supplementary_nutrition]
    ;child_2_to_15years(Age) -> 
        Recommendations = [midday_meal_scheme, ngo_support, school_health_program]
    ;Recommendations = [public_distribution_system, ngo_support, community_kitchen]
    ), !.

% Explanation generation
generate_detailed_explanation(Plan, Age, Category, Explanation) :-
    AgeYears is Age/12,
    format(string(Header), "Assessment for age ~2f years with ~w condition:\n", [AgeYears, Category]),
    flatten_and_explain_plan(Plan, ExplanationBody),
    atomic_list_concat([Header|ExplanationBody], '\n', Explanation).

% Helper predicate to flatten and explain nested plans
flatten_and_explain_plan([], []).
flatten_and_explain_plan([H|T], Explanations) :-
    is_list(H),
    !,
    flatten_and_explain_plan(H, ExplanationsH),
    flatten_and_explain_plan(T, ExplanationsT),
    append(ExplanationsH, ExplanationsT, Explanations).
flatten_and_explain_plan([Action|Rest], [ExplanationText|Explanations]) :-
    explain_action(Action, ExplanationText),
    flatten_and_explain_plan(Rest, Explanations).

% Action explanations (unchanged)
explain_action(immediate_hospitalization, "URGENT: Immediate hospitalization required for severe malnutrition treatment.").
explain_action(custom_feeding_plan, "Specialized feeding plan will be developed based on nutritional needs.").
explain_action(regular_testing, "Regular monitoring required to track progress and adjust treatment.").
explain_action(doctor_consultation, "Medical consultation needed to address underlying health issues.").
explain_action(balanced_diet_recommendation, "Dietary diversity needs improvement - specific recommendations will be provided.").
explain_action(breastfeeding_support, "Support needed to improve breastfeeding practices.").
explain_action(milk_supplementation, "Additional milk supplementation recommended due to inadequate intake.").
explain_action(sanitation_improvement, "Better sanitation practices needed to prevent infections.").
explain_action(supplementary_feeding_program, "Enrollment in community feeding program recommended.").
explain_action(counseling, "Nutritional counseling will be provided to caregivers.").
explain_action(dietary_recommendations, "Specific dietary guidelines will be provided.").
explain_action(retest_3_months, "Follow-up assessment scheduled after 3 months.").
explain_action(retest_1_month, "Follow-up assessment scheduled after 1 month.").
explain_action(therapeutic_feeding, "Therapeutic feeding required under medical supervision.").
explain_action(medical_monitoring, "Close medical monitoring required for recovery.").
explain_action(soft_home_food, "Introduction of appropriate soft home-made foods recommended.").
explain_action(no_action_needed, "Current nutritional status is normal, maintain healthy practices.").
explain_action(exclusive_breastfeeding, "Exclusive breastfeeding is recommended.").
explain_action(frequent_feeding_8_12_times, "Feed 8-12 times per day.").
explain_action(proper_latching_technique, "Ensure proper latching technique during breastfeeding.").
explain_action(continued_breastfeeding, "Continue breastfeeding along with complementary foods.").
explain_action(soft_nutritious_foods, "Introduce soft, nutritious complementary foods.").
explain_action(feeding_frequency_5_6_times, "Feed 5-6 times per day.").
explain_action(diverse_food_groups, "Include foods from all major food groups.").
explain_action(protein_rich_foods, "Increase intake of protein-rich foods.").
explain_action(energy_dense_foods, "Include energy-dense foods in diet.").
explain_action(micronutrient_supplements, "Supplementation with essential micronutrients recommended.").
explain_action(therapeutic_foods, "Special therapeutic foods will be provided.").
explain_action(hand_washing_practices, "Maintain proper hand washing practices.").
explain_action(safe_water_storage, "Ensure safe storage and handling of drinking water.").
explain_action(food_hygiene, "Follow proper food hygiene practices.").
explain_action(proper_waste_disposal, "Practice proper waste disposal.").
explain_action(environmental_cleanliness, "Maintain clean living environment.").

% Default explanation for unknown actions
explain_action(Action, Explanation) :-
    atom(Action),
    atomic_list_concat(['Action required: ', Action], Explanation).

% Main assessment integration with error handling
safe_assess(Age, Weight, Height, Illness, Diet, Breastfeeding, Sanitation, Assessment) :-
    catch(
        assess(Age, Weight, Height, Illness, Diet, Breastfeeding, Sanitation, Assessment),
        Error,
        (print_message(error, Error), fail)
    ).

% Main assessment predicate
% Main assessment predicate
assess(Age, Weight, Height, Illness, Diet, Breastfeeding, Sanitation, Assessment) :-
    validate_inputs(Age, Weight, Height, Illness, Diet, Breastfeeding, Sanitation),
    bmi_category(Weight, Height, Age, Category),
    treatment_plan(Age, Category, Illness, Diet, Breastfeeding, Sanitation, TreatmentPlan),
    feeding_recommendation(Age, Category, FeedingRecs),
    nutrient_recommendations(Category, Age, NutrientRecs),
    follow_up_schedule(Category, FollowUp),
    sanitation_recommendations(Sanitation, SanitationRecs),
    govt_policy_recommendation(Age, PolicyRecs),
    Assessment = [
        category(Category),
        treatment_plan(TreatmentPlan),
        feeding(FeedingRecs),
        nutrients(NutrientRecs),
        follow_up(FollowUp),
        sanitation(SanitationRecs),
        policy_recommendations(PolicyRecs)
    ].

% Constraints
false :- child_under_6months(Age), Age < 0.
false :- Weight =< 0.
false :- Height =< 0.
false :- BMI =< 0.
false :- Age < 0.
false :- Age > 1200.  % Max age 100 years in months


% Pretty printer for assessment
print_assessment([]) :- nl.
print_assessment([H|T]) :-
    write('- '),
    print_item(H),
    nl,
    print_assessment(T).

print_item(category(C)) :- write('Category: '), write(C).
print_item(treatment_plan(P)) :- write('Treatment Plan: '), write(P).
print_item(feeding(F)) :- write('Feeding Recommendations: '), write(F).
print_item(nutrients(N)) :- write('Nutrient Recommendations: '), write(N).
print_item(follow_up(F)) :- write('Follow-up Schedule: '), write(F).
print_item(sanitation(S)) :- write('Sanitation Recommendations: '), write(S).
print_item(policy_recommendations(P)) :- write('Policy Recommendations: '), write(P).
print_item(meal_plan_parameters(M)) :- write('Meal Plan Parameters: '), write(M).
print_item(justification(J)) :- write('Justification: '), write(J).
print_item(Other) :- write(Other).

test1 :-
    safe_assess(4, 5, 0.6, yes, limited, inadequate, poor, Assessment),
    print_assessment(Assessment).


% Example usage:
/*
?- test_cases.
?- safe_assess(5, 5, 0.6, yes, limited, inadequate, poor, Assessment).
?- safe_assess(18, 8, 0.75, no, limited, adequate, good, Assessment).
*/
