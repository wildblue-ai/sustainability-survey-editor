-- MySQL table for Sustainability Survey Questions
-- This table stores all questions from the sustainability digital survey

CREATE TABLE sustainability_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    question_order INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('Systems', 'Best Practice', 'Performance') NOT NULL,
    answer_type ENUM('boolean', 'numeric', 'multiple_choice', 'percentage') NOT NULL,
    effort_rating DECIMAL(3,1) NULL,
    impact_rating DECIMAL(3,1) NULL,
    max_points INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes for efficient querying
    INDEX idx_category_order (category, question_order),
    INDEX idx_type (question_type),
    INDEX idx_answer_type (answer_type)
);

-- Insert all sustainability survey questions

-- GHG Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 1, 'We measure and track all applicable Scope 1 GHG emissions, in accordance with the GHG Protocol.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 2, 'We measure and track all applicable Scope 2 GHG emissions, in accordance with the GHG Protocol.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 3, 'We have identified, measure, and track relevant Scope 3 GHG emissions, in accordance with the GHG Protocol. Indicate all Scope 3 categories included in your inventory', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 4, 'We normalize GHG emissions by scope.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 5, 'We normalize total GHG emissions.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 6, 'We have established or updated a normalized GHG emissions baseline.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 7, 'Please indicate your current baseline year.', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 8, 'We have established (updated) a specific, measurable, achievable, relevant, and time bound GHG emissions reduction goal.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 9, 'We have established a science-based emissions reduction target that is in line with the latest climate science.', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 10, 'We have a goal to be carbon neutral or net zero by the identified year - please select the year closest to your goal.  ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 11, 'We have a written plan, budget time, and have allocated financial resources to support GHG emissions reduction goals.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 12, 'We have integrated GHG management into our strategic business management processes.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 13, 'We have a GHG or climate policy that guides decision making', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 14, 'Responsibility and accountability for GHG performance are integrated throughout the organization. Select all levels engaged in oversight. ', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 15, 'GHG management expectations, goals, and performance are shared/reviewed with relevant employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 16, 'We consider the impact to GHG emissions in the design and construction of facilities, equipment, processes, and/or products. Select all that apply.', 'Systems', 'multiple_choice', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 17, 'GHG impacts of purchased items are a part of our organization’s procurement criteria. ', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 18, 'We take the following climate strategy actions. Select all that apply.', 'Systems', 'multiple_choice', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 19, 'We have included all material GHG emissions in our inventory, in accordance with GHG Protocol standards.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 20, 'We have identified and fixed leaks in our system that result in increased energy use or the direct escape of greenhouse gases (e.g. refrigerants).', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 21, 'We are a member of a widely accepted program or partnership aimed at reducing emissions and improving air quality ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 22, 'We participate in a climate action coalition.  ', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 23, 'We have quantified the GHG impact of the goods/services we offer. Select the percentage of your products for which you have quantified the product-specific GHG impact. ', 'Best Practice', 'percentage', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 24, 'We share product specific GHG impacts with customers. ', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 25, 'We have engaged with internal and external stakeholders to educate them about our GHG Management program. ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 26, 'We have engaged with internal and external stakeholders pertaining to our GHG emissions and understand their needs and expectations related to our performance on this topic.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 27, 'We have engaged our value chain about opportunities to reduce the GHG impacts of our products/services. ', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 28, 'We publicly share information on our GHG emissions performance.', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 29, 'If your organization generates any of your own energy from renewable (carbon neutral) energy sources,  what percent of overall energy use does this represent?', 'Performance', 'percentage', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 30, 'If your organization purchases renewable (carbon neutral) energy  for any of the electricity you use, what percent of purchased energy use does this represent?', 'Performance', 'percentage', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 31, 'Please indicate the percentage of your GHG emissions reduction goal you have achieved. ', 'Performance', 'percentage', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 32, 'Please indicate your percent improvement in  normalized total GHG emissions, compared to your baseline. Full points awarded at 25% improvement. Select "0" if not monitored. ', 'Performance', 'percentage', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('GHG', 33, 'Please indicate your percent improvement in absolute total GHG emissions, compared to your baseline. Full points awarded at 25% improvement. Select “0” if not monitored.', 'Performance', 'percentage', NULL, NULL, 12);


-- Energy Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 1, 'We measure and track energy use by facility.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 2, 'We measure and track total energy use from all sources and facilities. ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 3, 'We normalize total energy use.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 4, 'We have established or updated a normalized energy use baseline.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 5, 'Please indicate your current baseline year.', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 6, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound energy improvement goal.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 7, 'We have a written plan, budget time, and have allocated financial resources to support energy improvement goals.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 8, 'We have integrated energy management into our strategic business management processes.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 9, 'We have an energy policy that guides decision making.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 10, 'Responsibility and accountability for energy management are integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 11, 'Energy management expectations, goals, and performance are shared/reviewed with relevant employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 12, 'We consider energy impacts (use, efficiency, source) in the design and construction of facilities, equipment, systems, processes, and/or products.', 'Systems', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 13, 'Energy impacts (use, efficiency, source) of purchased items are part of our organization’s procurement criteria. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 14, 'Within the last three years we have audited our processes and/or building(s) to identify energy savings, energy efficiency, or alternative energy opportunities and have implemented or initiated recommended projects. ', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 15, 'We have identified significant energy users in each of our facilities. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 16, 'We have partnered with an outside organization or agency to support our energy efficiency efforts.', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 17, 'We have implemented energy efficiency best practices. Select all that apply.', 'Best Practice', 'multiple_choice', NULL, NULL, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 18, 'We maintain an ISO 50001 or similar Energy Management System that requires measurement, management, and documentation for continuous improvement in energy efficiency.', 'Best Practice', 'numeric', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 19, 'We have engaged with internal and external stakeholders to educate them about our energy management program.', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 20, 'We have engaged with internal and external stakeholders pertaining to our consumption of energy and understand their needs and expectations related to our energy efficiency, use and consumption. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 21, 'We have engaged our value chain about opportunities to reduce the energy impacts of our products/services. ', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 22, 'We publicly share information about our energy performance', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 23, 'Please indicate the percentage of the buildings that you own or occupy that are certified to a sustainable building standard. ', 'Performance', 'percentage', 1.0, 7.800000000000001, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 24, 'Please indicate your percent improvement in normalized energy use compared to your baseline. Full points awarded at 25% improvement. Select "0" if not monitored.', 'Performance', 'percentage', 1.0, 11.7, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 25, 'Pleas indicate the percentage of your energy improvement goal you have achieved.', 'Performance', 'percentage', 1.0, 7.800000000000001, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Energy', 26, 'Please indicate what percentage of your total energy use comes from renewable sources.', 'Performance', 'percentage', 1.0, 11.7, 12);


-- Transportation Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 1, 'We measure and track fuel use.  ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 2, 'We measure and track miles traveled per year for employee transportation.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 3, 'We measure and track miles traveled per year for transportation of products.', 'Systems', 'boolean', 3.0, 1.0, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 4, 'We normalize transportation metrics.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 5, 'We have established or updated a normalized transportation baseline.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 6, 'Please indicate your current baseline year', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 7, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound transportation efficiency goal(s).', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 8, 'We have a written plan, budget time, and have allocated financial resources to support our transportation efficiency goal(s).', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 9, 'We have integrated transportation efficiency into our strategic business management processes.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 10, 'We have a transportation policy that guides decision making.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 11, 'Responsibility and accountability for transportation efficiency are integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 12, 'Transportation expectations, goals, and performance are shared/reviewed with relevant employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 13, 'Transportation impacts of purchased items are part of our organization’s procurement criteria.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 14, 'Within the last three years we have conducted a fleet assessment to understand costs and impacts related to fuel use in our organization.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 15, 'Please indicate what percentage of your vendors are within 100 miles of the facility using the good(s) or service(s). Full points are awarded at 50%.', 'Best Practice', 'percentage', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 16, 'We implement best practices to reduce fuel use or improve efficiency related to employee travel. Select all practices that have been implemented.', 'Best Practice', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 17, 'We implement best practices to reduce fuel use or improve efficiency related to movement of goods. Select all practices that have been implemented.', 'Best Practice', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 18, 'We have engaged with internal and external stakeholders to educate them about our transportation program. ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 19, 'We have engaged with internal and external stakeholders pertaining to transportation and understand their needs and expectations related to our performance on this topic.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 20, 'We have engaged our value chain about opportunities to reduce the transportation impacts of products/services. ', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 21, 'We are a member of a national or statewide transportation initiative or partnership aimed at helping advance fuel efficiency, electrification, or use of clean fuels. ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 22, 'We publicly share information about our transportation impacts.', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 23, 'Please indicate your percent improvement in normalized fuel use compared to your baseline. Full points are awarded at 25% improvement. Select “0” if not monitored.', 'Performance', 'percentage', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 24, 'Please indicate your percent improvement in fuel efficiency (fuel use/miles traveled) for employee transportation, compared to your baseline. Full points awarded at 25% improvement. Select “0” if not monitored.', 'Performance', 'percentage', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 25, 'Please indicate your percent improvement in fuel efficiency (fuel use/miles traveled) for transportation of products, compared to your baseline. Full points awarded at 25% improvement. Select “0” if not monitored.', 'Performance', 'percentage', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Transportation', 26, 'Please indicate the percentage of your transportation/fuel efficiency goal you have achieved.', 'Performance', 'percentage', NULL, NULL, 6);


-- Water Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 1, 'We measure and track total water intake by source. ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 2, 'We measure and track total wastewater discharge by destination.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 3, 'We measure and track total water consumption.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 4, 'We measure, estimate, and/or test the quality of wastewater discharges.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 5, 'We actively manage onsite stormwater runoff.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 6, 'We normalize monitored water metrics.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 7, 'We have established a baseline for water-related impacts. Select all issues for which a baseline has been established.  ', 'Systems', 'boolean', 2.0, 1.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 8, 'Please indicate your current baseline year.', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 9, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound water impact goal(s). Select all issues for which a goal has been established.', 'Systems', 'boolean', 2.0, 1.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 10, 'We have a written plan, budget time, and have allocated financial resources to support our water management efforts. ', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 11, 'We have integrated water stewardship into our strategic business management processes.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 12, 'We have a water policy that guides decision making.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 13, 'Responsibility and accountability for water stewardship is integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 14, 'Water stewardship expectations, goals, and performance are shared/reviewed with relevant employees (select one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 15, 'We consider water impacts in the design and construction of  facilities, equipment, and/or processes. Select all that apply.', 'Systems', 'multiple_choice', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 16, 'Water impacts of purchased items are a part of our organization’s procurement criteria.  ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 17, 'We monitor compliance with all applicable water regulations', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 18, 'We take the following water strategy actions - select all that apply', 'Systems', 'multiple_choice', NULL, NULL, 7);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 19, 'We have prioritized our water-related risks and our goals reflect the identified priorities.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 20, 'We maintain a facility-wide water balance. ', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 21, 'Within the last three years we have audited our processes and/or building(s) to identify water savings, water efficiency, or alternative water opportunities and have implemented or initiated recommended projects.', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 22, 'We actively manage water-related activities to minimize pollution from our facility. ', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 23, 'We use innovation and technological development in our water conservation efforts. ', 'Best Practice', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 24, 'We have implemented water use efficiency best practices. Indicate all measures that have been implemented.', 'Best Practice', 'boolean', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 25, 'We have implemented nature-based stormwater management and landscaping best practices. Indicate all measures that have been implemented. ', 'Best Practice', 'boolean', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 26, 'We have engaged with internal and external stakeholders to educate them about our water management program. ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 27, 'We have engaged with watershed stakeholders regarding shared water resources. Please indicate the level and type of your water-related engagement with watershed stakeholders for all facilities included in this application.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 28, 'We have engaged our value chain about opportunities to reduce the water impacts of products/services. ', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 29, 'We are a member of a national, state, or local program  aimed at water conservation.', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 30, 'We publicly share information on our water impacts. ', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 31, 'We maintain third-party certification(s) for responsible water stewardship. ', 'Performance', 'numeric', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 32, 'Please indicate the percentage of your water goal you have achieved.', 'Performance', 'percentage', 1.0, 10.0, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 33, 'Please indicate your percent improvement in normalized water intake compared to your baseline. Full points are awarded at 25% improvement. Select “0” if not monitored.', 'Performance', 'percentage', 1.0, 12.0, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Water', 34, 'Please indicate your percent improvement in normalized water consumption compared to your baseline. Full points are awarded at 25% improvement. Select “0” if not monitored.', 'Performance', 'percentage', 1.0, 12.0, 12);


-- Eco Impacts Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 1, 'We have assessed the impacts on nature from our operations and value stream activities and have identified activities contributing to pressures on natural systems. ', 'Systems', 'boolean', 3.0, 1.0, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 2, 'We have identified and prioritized risks to our business due to natural habitat degradation and/or biodiversity loss. ', 'Systems', 'boolean', 3.0, 1.0, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 3, 'We measure and track the impacts of our organization on natural habitats.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 4, 'We measure and track the impacts of our organization on biodiversity.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 5, 'We have established an ecological impact baseline.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 6, 'Please indicate your current baseline year.', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 7, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound ecological impact goal.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 8, 'We have established science-based goal(s) that address our organization''s most significant ecological impact(s)', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 9, 'We have a science-based goal of zero encroachment on marine/terrestrial ecosystems or culturally sensitive areas, regardless of organizational growth.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 10, 'Our ecological impact goal(s) reflect the identified risks to our business from natural habitat degradation and/or biodiversity loss. ', 'Systems', 'numeric', 1.0, 3.0, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 11, 'We have a written plan, budget time, and have allocated financial resources to support our ecological impact goal(s).', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 12, 'We have integrated management of our impact on natural habitats and the biodiversity into our strategic business management processes.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 13, 'We have an ecological impact policy that guides decision making.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 14, 'Responsibility and accountability for ecological impacts are integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 15, 'Expectations, goals, and performance related to ecological impacts are shared/reviewed with relevant employees (select one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 16, 'We consider direct and indirect ecological impacts in the location, design, and construction of facilities, equipment, and/or processes. Select all that are included in your evaluation.', 'Systems', 'numeric', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 17, 'We take measures to reduce or eliminate negative environmental impacts from operations that are owned, leased, or managed by our organization.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 18, 'We take measures to prevent, mitigate, and remediate (if applicable) negative impacts associated with use of hazardous products within our operations. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 19, 'We take measures to prevent, mitigate, and remediate (if applicable) negative impacts associated with use of hazardous products within our supply chain. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 20, 'We have tools and systems in place to monitor natural habitat conversion in our organization’s activities, supply chain, and sourcing locations.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 21, 'We take measures to reduce or eliminate natural habitat conversion related to our operations.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 22, 'We take measures to reduce or eliminate natural habitat conversion related to our supply chain and sourcing locations.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 23, 'We have identified historic conversion of natural habitats and account for the ongoing impacts of that conversion in our assessment of total impacts to systems. ', 'Best Practice', 'boolean', 3.0, 1.0, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 24, 'We participate in multi-stakeholder, landscape, or sector-specific initiatives to reduce or eliminate natural habitat conversion. ', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 25, 'We apply internationally accepted, industry-specific good operating principles, management practices, and technologies in our management of living natural resources.', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 26, 'When ecological impacts are unavoidable, we apply the Mitigation Hierarchy to limit negative impacts on biodiversity.', 'Best Practice', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 27, 'We have engaged with internal and external stakeholders to educate them about our biodiversity and/or natural habitat conservation program(s).', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 28, 'We have engaged with internal and external stakeholders pertaining to our ecological impacts and understand their needs and expectations related to our performance on this topic.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 29, 'We have engaged with stakeholders about opportunities to partner in reducing impacts to natural habitats and/or biodiversity.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 30, 'We publicly share information on our ecological impacts.', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 31, 'Please indicate the percentage of your operational facilities that have been assessed for impacts to natural habitats or biodiversity.', 'Performance', 'percentage', 1.0, 11.25, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 32, 'Please indicate the percentage of your supply chain that has been assessed for impacts to natural habitats or biodiversity.', 'Performance', 'percentage', 1.0, 11.25, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 33, 'Please indicate the percentage of natural resources sourced by your organization that are certified to a sustainable management standard.', 'Performance', 'percentage', 1.0, 13.5, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Eco Impacts', 34, 'Please indicate the percentage of your ecological impact goal you have achieved.Select "0" if you have not established a company-specific goal. ', 'Performance', 'percentage', 1.0, 9.0, 10);


-- Waste Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 1, 'We measure and track total solid waste generated by disposal stream.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 2, 'We measure and track total solidwaste generated across all disposal streams.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 3, 'We normalize total solid waste generated.', 'Systems', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 4, 'We have established or updated a normalized waste baseline.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 5, 'Please indicate your current baseline year.', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 6, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound waste reduction/landfill diversion goal.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 7, 'We have a written plan, budget time, and have allocated financial resources to support our waste goal(s).', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 8, 'We have integrated waste management into our strategic business management processes.', 'Systems', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 9, 'We have a waste policy that guides decision making.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 10, 'Responsibility and accountability for waste management are integrated throughout the organization. Select all levels engaged in oversight. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 11, 'Waste management expectations, goals, and performance are shared/reviewed with relevant employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 12, 'We consider waste impacts in the design and construction of facilities, equipment, processes, and/or products.', 'Systems', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 13, 'Waste minimization is part of our organization’s procurement criteria for purchased items.', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 14, 'We measure and manage hazardous risks of incoming materials and waste.', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 15, 'All wastes we generate are managed in compliance with applicable regulations, and wastes that are potentially hazardous but not regulated are identified and properly disposed.', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 16, 'Within the last three years we have audited our processes and/or facility(s) for waste management opportunities and have implemented or initiated identified projects. ', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 17, 'We implement best practices in waste management in office spaces. Select all that apply.', 'Best Practice', 'multiple_choice', 1.0, 4.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 18, 'We have a waste sorting and landfill diversion program. Indicate all materials that are diverted from landfill.', 'Best Practice', 'boolean', 1.0, 9.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 19, 'We implement redesign to reduce total waste generated. ', 'Best Practice', 'numeric', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 20, 'We implement refusal of materials to reduce total waste generated.', 'Best Practice', 'numeric', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 21, 'We implement waste reduction measures to reduce total waste generated. ', 'Best Practice', 'numeric', NULL, NULL, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 22, 'We implement reuse to reduce total waste to landfill.  ', 'Best Practice', 'numeric', NULL, NULL, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 23, 'We implement recycling to reduce total waste to landfill.  ', 'Best Practice', 'numeric', NULL, NULL, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 24, 'We implement composting to reduce total waste to landfill. ', 'Best Practice', 'numeric', NULL, NULL, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 25, 'We implement energy recovery to reduce total waste to landfill. ', 'Best Practice', 'numeric', NULL, NULL, 1);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 26, 'We have engaged with internal and external stakeholders to educate them about our waste management program.', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 27, 'We have partnered with a stakeholder to capture waste/by-products as an input. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 28, 'We have engaged our value chain about opportunities to reduce the waste impacts of products/services. ', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 29, 'We are a member of a member of a national, state, or local program  aimed at waste management', 'Best Practice', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 30, 'We publicly share information about our waste performance.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 31, 'We have obtained third-party zero waste certification. ', 'Performance', 'boolean', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 32, 'Please indicate your percent reduction in normalized waste generated, by weight or volume, compared to your baseline. Full points are awarded at 90% reduction. Select "0" if not monitored.', 'Performance', 'percentage', 1.0, 12.0, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 33, 'Please indicate the percentage of your waste that is sent to landfill.', 'Performance', 'percentage', 1.0, 12.0, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Waste', 34, 'Please indicate the percentage of your waste reduction goal you have achieved.', 'Performance', 'percentage', 1.0, 10.0, 10);


-- Materials Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 1, 'We measure and track total material consumption.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 2, 'We measure and track virgin material consumption.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 3, 'We normalize virgin material consumption as a fraction of total material consumption.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 4, 'We measure and manage first pass yield as an indicator of material use efficiency.  ', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 5, 'We have established or updated a material use baseline. Select all issues for which a baseline has been established.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 6, 'Please indicate your current baseline year.', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 7, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound total material use goal.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 8, 'We have a written plan, budget time, and have allocated financial resources to support our material use efficiency efforts.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 9, 'We have integrated material management into our strategic business management processes', 'Systems', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 10, 'We have a material use policy that guides decision making.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 11, 'Responsibility and accountability for material use is integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 12, 'Material management expectations, goals, and performance are shared/reviewed with relevant employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 13, 'We consider material use impacts in the design and construction of  facilities, equipment, systems, processes, and/or products.', 'Systems', 'numeric', 2.0, 1.0, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 14, 'Material use impacts of purchased items are part of our organization’s procurement criteria. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 15, 'Within the last three years we have audited our processes to identify material use efficiency opportunities and have implemented or initiated recommended projects. ', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 16, 'We have quantified the collateral environmental impacts related to changes in material use.', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 17, 'We have identified, documented, and routinely evaluate environmental and social risks related to our material supply.', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 18, 'We evaluate, document, and routinely consider the life cycle impact of materials used in our products and services.', 'Best Practice', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 19, 'We have taken specific steps to minimize or eliminate the use of virgin materials. Indicate all measures that have been implemented.', 'Best Practice', 'boolean', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 20, 'We have partnered with a stakeholder to capture waste/by-products as an input. ', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 21, 'What percent of your total product packaging, by unit, weight, or volume, is from recycled and/or renewable materials?', 'Best Practice', 'percentage', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 22, 'What percent of your total material input, by unit, weight, or volume, is recycled/reused content?', 'Performance', 'percentage', 1.0, 13.365, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 23, 'What percent of your total material input, by unit, weight, or volume, is renewable content?', 'Performance', 'percentage', 1.0, 13.365, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Materials', 24, 'What is your first pass yield efficiency?', 'Performance', 'numeric', 1.0, 13.365, 12);


-- Circularity Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 1, 'We measure and track product(s) with a sustainability advantage as a percentage of our total product portfolio. ', 'Systems', 'percentage', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 2, 'We measure and track product(s) with circularity potential as a percentage of our total product portfolio. ', 'Systems', 'percentage', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 3, 'We have established or updated a product sustainability/circularity baseline.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 4, 'Please indicate your current baseline year', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 5, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound product sustainability/circularity goal.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 6, 'We have a written plan, budget time, and have allocated financial resources to support our product sustainability/circularity goal.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 7, 'We have integrated product sustainability/circularity into our strategic business management processes.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 8, 'We have a life cycle impact or product sustainability policy that guides decision making', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 9, 'Responsibility and accountability for product life cycle impacts are integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 10, 'Product sustainability expectations, goals, and performance are shared/reviewed with relevant employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 11, 'Material circularity is part of our organization’s procurement criteria.', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 12, 'We consider consider the full lifetime impact to stakeholders when developing new products, services, and solutions.', 'Systems', 'numeric', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 13, 'In the design of products/services, we consider and seek to minimize social and environmental impacts throughout the life of the product/service. Select the steps of the life cycle that are considered.', 'Systems', 'numeric', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 14, 'In the design/selection of product packaging, we consider and seek to minimize the social and environmental impacts throughout the life of the material. Select the steps of the life cycle that are considered.', 'Systems', 'numeric', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 15, 'We have conducted or consulted a formal Life Cycle Assessment (LCA) for our products and packaging. Indicate the percentage of your products and packaging for which a LCA has been conducted and consulted.', 'Best Practice', 'percentage', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 16, 'We offer customers information about the environmental and/or social  impacts of our goods/services.', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 17, 'We offer customers the opportunity to voluntarily offset the environmental impacts related to production of the goods/services we offer. ', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 18, 'We participate in a take-back or exchange program for products that we sell or purchase. ', 'Best Practice', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 19, 'We have a process in place to assess the materials, chemicals, and substances used in our products for hazardous characteristics, and we seek to reduce or eliminate associated hazards and risks.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 20, 'We have replaced raw materials that include hazardous or undesirable constituents with less hazardous/toxic constituents. Indicate the percentage of hazardous inputs that have been replaced. Select "100%" if there are no hazardous/toxic constituents in use. ', 'Best Practice', 'percentage', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 21, 'We have developed a Restricted Substance List (RSL) or adopted an industry-standard list of substances that may not be used in our products.', 'Best Practice', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 22, 'We have engaged with internal and external stakeholders to educate them about our product sustainability/circularity program.', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 23, 'We have engaged with internal and external stakeholders pertaining to circularity potential of our products/services and understand their needs and expectations.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 24, 'We have engaged our value chain about opportunities to reduce the lifecycle impacts of products/services. ', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 25, 'We have obtained third-party product sustainability or circularity certification. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 26, 'What percentage of the products you sell, by unit, weight, or volume, are recyclable, reusable, biodegradable, serviceable, and/or able to be refurbished for continued use?', 'Performance', 'percentage', 1.0, 12.1875, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 27, 'What percentage of the products you sell that are recyclable, reusable, biodegradable, serviceable, and/or able to be refurbished for continued use are labeled as such?', 'Performance', 'percentage', 1.0, 12.1875, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 28, 'What percentage of your total product packaging, by unit, weight, or volume, is fully recyclable, reusable, and/or biodegradable?', 'Performance', 'percentage', 1.0, 12.1875, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 29, 'What percentage of your product packaging that is recyclable, reusable, or biodegradable is labeled as such?', 'Performance', 'percentage', 1.0, 12.1875, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Circularity', 30, 'What percentage of your total revenue comes from products that are recyclable, reusable, biodegradable, serviceable, and/or able to be refurbished for continued use?', 'Performance', 'percentage', 1.0, 12.1875, 12);


-- Employee H&S Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 1, 'We measure and track recordable workplace injuries and illnesses.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 2, 'We measure and track lost time workplace incidents.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 3, 'We measure and track near miss incidents.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 4, 'We measure and track our recordable health and safety incident rate.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 5, 'We measure and track our DART rate.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 6, 'We normalize recordable injuries based on hours worked.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 7, 'We normalize recordable injuries based on near miss incidents.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 8, 'We have established (updated) a specific, measurable, achievable, relevant, and time-bound health and safety incident reduction goal(s). Select all metrics for which a goal has been established.', 'Systems', 'boolean', 2.0, 1.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 9, 'We have a written plan, budget time, and have allocated financial resources to support our health and safety goal(s).', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 10, 'We have integrated employee health and safety into our strategic business management processes.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 11, 'We have a health and safety policy that guides decision making.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 12, 'Responsibility and accountability for employee health and safety is integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 13, 'Employee health and safety expectations, goals, and performance are shared/reviewed with all employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 14, 'We look for opportunities to improve worker safety when planning changes to facilities, equipment, and/or processes. Select all that apply.', 'Systems', 'multiple_choice', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 15, 'Health and safety impacts are considered as part of our organization’s procurement criteria.', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 16, 'We have a formal health and safety program that aligns with widely accepted frameworks . ', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 17, 'Workers and managers participate together in the development, implementation, and evaluation of our health and safety management system.', 'Best Practice', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 18, 'We have a defined process for hazard, risk, and opportunity identification and regularly conduct safety-related job skill and task  analyses. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 19, 'We have a defined process for hazard, risk, and opportunity identification and regularly conduct infrastructure and equipment  safety analyses. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 20, 'We have a defined process for hazard, risk, and opportunity identification that includes human and social factors. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 21, 'When addressing identified risks/opportunities, we consider the hierarchy of controls,  best practices, technological options, and operational requirements. ', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 22, 'We have an established process for responding to safety incidents in a timely manner. Select all that apply.', 'Best Practice', 'multiple_choice', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 23, 'We have a plan in place to prepare for and respond to emergency situations, a coordinator is assigned to oversee the response, and employees are trained on planned responses. Select all that apply.', 'Best Practice', 'multiple_choice', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 24, 'In the last twelve months, we have completed workplace safety training for all employees. Select all aspects that are included in your training program.  ', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 25, 'We verify the effectiveness of training. Please indicate all verification methods that are used.', 'Best Practice', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 26, 'We encourage employees to remove themselves from work situations they believe could cause injury or illness, and employees are made aware of the expectation to do so. ', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 27, 'We have an established process for employees to report work-related hazards and hazardous situations, and employees are made aware of the process.', 'Best Practice', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 28, 'We have a process in place to protect workers against retaliation after taking action to protect the health/safety of themselves or those around them.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 29, 'We have engaged with internal and external stakeholders to educate them about our employee health and safety program. ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 30, 'We publicly share our employee health and safety record. ', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 31, 'We track and compare our non-fatal injury and illness incident rate to Bureau of Labor Statistics (BLS) data for our sector. Please indicate your performance. ', 'Performance', 'numeric', NULL, NULL, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 32, 'We track and compare our incidents of injuries and illnesses that result in days away from work, job transfer, or restriction, to Bureau of Labor Statistics (BLS) data for our sector. Please indicate your performance. ', 'Performance', 'numeric', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 33, 'How many months since your last lost time injury? Full points awarded at 12 months.', 'Performance', 'numeric', NULL, NULL, 5);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 34, 'How many months since your last recordable injury? Full points awarded at 12 months.', 'Performance', 'numeric', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee H&S', 35, 'For the prior 12 months, by what percentage have your near miss incidents improved compared to your baseline? Full points are awarded at 25% improvement. Select “0” if not monitored.', 'Performance', 'percentage', NULL, NULL, 10);


-- Employee Experience Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 1, 'We measure and track employee turnover.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 2, 'We measure and consider the cost to our organization of employee turnover.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 3, 'We measure and track employee engagement.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 4, 'We measure and consider the cost to our organization of employee engagement/disengagement.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 5, 'We measure and track employee participation in training programs.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 6, 'We have defined the experience we want employees to have at our organization and have developed methods to monitor and track progress toward those goals.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 7, 'We have a written plan, budget time, and have allocated financial resources to support our employee experience goals.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 8, 'We do not use forced labor and have a system in place to ensure that this type of labor is not introduced. ', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 9, 'We do not use child labor and have a system in place to ensure that this type of labor is not introduced.  ', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 10, 'We acknowledge employees’ rights to form associations and negotiate wages as a group, without judgment or threat to their position.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 11, 'We ensure that all employees are paid a living wage. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 12, 'We have a formal Employee Health & Safety program to ensure healthy, safe, and respectful working conditions.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 13, 'We have a written employee handbook that is accessible to employees. ', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 14, 'We have a system for employees to raise complaints or concerns anonymously and provide protection for employees who bring complaints about management.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 15, 'We have a program in place to assess and develop the strengths of our employees.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 16, 'We offer supplemental benefits to qualified employees. Select which group qualifies for benefits.', 'Best Practice', 'numeric', NULL, NULL, 5);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 17, 'How many weeks of paid time off are offered to all full-time employees, in addition to standard paid holidays?', 'Best Practice', 'numeric', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 18, 'What percentage of health insurance premiums are paid by the company?', 'Best Practice', 'percentage', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 19, 'We offer employee retirement plans to qualified employees.  Select the type of plan offered.', 'Best Practice', 'numeric', NULL, NULL, 3);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 20, 'We provide supplemental health insurance benefits to qualified employees. Select all that are offered with majority employer-paid premiums (>50%). ', 'Best Practice', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 21, 'We provide resources for employees to maintain financial health. Select all that are offered as part of documented employee benefits. ', 'Best Practice', 'numeric', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 22, 'We provide resources for employees to maintain a healthy lifestyle. Select all that are offered as part of documented employee benefits. ', 'Best Practice', 'numeric', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 23, 'We offer family support benefits to employees. Select all that are offered as part of documented employee benefits.', 'Best Practice', 'numeric', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 24, 'We provide employees with opportunities for learning and professional development. Select the opportunities that are available.', 'Best Practice', 'numeric', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 25, 'We have an established process for providing performance feedback to employees. Select all aspects that are part of the process. ', 'Best Practice', 'boolean', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 26, 'We provide employees with opportunities for career growth. Select the opportunities that are available.', 'Best Practice', 'numeric', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 27, 'We have a program in place to build employee engagement. Select all applicable actions.', 'Best Practice', 'boolean', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 28, 'We monitor employee wellness program utilization and adjust our efforts accordingly.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 29, 'We are certified to an audited social management system, such as the SA 8000 run by Social Accountability International.', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 30, 'Please indicate the average number of hours of training provided to each employee, per year. Full points are awarded at 40 hours. Select “0” if not measured.', 'Performance', 'multiple_choice', 1.0, 7.5, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 31, 'Please indicate the average percentage of available training hours utilized by each employee during the prior calendar year. Select “0” if not measured.', 'Performance', 'percentage', 1.0, 7.5, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 32, 'Please indicate the percentage of annual revenue spent on employee wellness programs. Select “0” if not measured or offered.', 'Performance', 'percentage', 1.0, 7.5, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 33, 'Please indicate your turnover rate during the prior calendar year.', 'Performance', 'multiple_choice', 1.0, 11.25, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 34, 'Please indicate the average reported employee engagement rate across your organization. Select “0” if not measured. Full points are awarded at 50%', 'Performance', 'multiple_choice', 1.0, 11.25, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Employee Experience', 35, 'Please indicate the percentage of your employee experience goal you have achieved. Select “0” if not measured.', 'Performance', 'percentage', 1.0, 7.5, 4);


-- DEI Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 1, 'We measure and track workforce diversity. ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 2, 'We measure and track workplace discrimination and harassment complaints. ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 3, 'We measure and track demographic attrition in our organization and compare it to total attrition.  ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 4, 'We measure and consider the economic impact on our organization of a diverse workforce.', 'Systems', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 5, 'We have engaged with a diverse selection of employees regarding whether they feel welcomed and equally treated at our organization and have identified areas of improvement. ', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 6, 'We have defined the experience we want all employees to have and have developed methods to monitor and track progress toward those goals. Select all that apply. ', 'Systems', 'multiple_choice', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 7, 'We have a written plan, budget time, and have allocated financial resources to support our workforce diversity, equity, and inclusion efforts.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 8, 'We have a workforce diversity, equity, and inclusion policy that guides decision making. ', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 9, 'Responsibility and accountability for workforce diversity, equity, and inclusion is integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 10, 'Workforce diversity, equity, and inclusion expectations, goals, and performance are shared/reviewed with all employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 11, 'We have a system for employees to raise discrimination or harassment concerns and provide protection for employees who bring complaints about management.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 12, 'We investigate incidents of discrimination and develop a remediation plan in response to any confirmed incident.  ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 13, 'We have a program in place to ensure that all workers in our workforce are paid equitably and treated fairly.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 14, 'We protect the confidentiality of workers’ personal health information to ensure that it is not used for favorable/unfavorable treatment.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 15, 'We consider equity and inclusion when selecting benefits offered to employees. ', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 16, 'We implement practices to ensure financial equity across our workforce. Select all that apply. ', 'Best Practice', 'multiple_choice', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 17, 'We implement practices to promote diversity, equity, and inclusion in the workplace. Select all that apply. ', 'Best Practice', 'multiple_choice', NULL, NULL, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 18, 'We have identified barriers to participation in our workforce for minority and vulnerable groups and taken steps to minimize those barriers. ', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 19, 'We have identified barriers to participation in management and senior leadership for minority and vulnerable groups and taken steps to minimize those barriers. ', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 20, 'We have identified gender-specific barriers to participation in our workforce and have taken steps to minimize those barriers.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 21, 'We have identified gender-specific barriers to participation in management and senior leadership and have taken steps to minimize those barriers.', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 22, 'We have engaged with internal and external stakeholders  to educate them about our workforce diversity, equity, and inclusion program.', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 23, 'We have engaged with internal and external stakeholders pertaining to diversity, equity, and inclusion and understand their needs and expectations.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 24, 'We publicly share information on our workforce diversity, equity, and inclusion.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 25, 'Does the percentage of your workforce that is part of a minority or vulnerable group reflect representation of those groups in your community? ', 'Performance', 'percentage', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 26, 'Does the percentage of managers and senior leaders in your organization that are part of a minority or vulnerable group reflect representation of those groups in your workforce?', 'Performance', 'percentage', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 27, 'Are genders equally represented in your workforce?', 'Performance', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 28, 'Does the gender of managers and senior leaders in your organization reflect representation of those groups in your workforce?', 'Performance', 'numeric', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 29, 'How many discrimination and harassment complaints did the company receive during the prior calendar year?', 'Performance', 'numeric', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('DEI', 30, 'Please use the adjacent slide bar to indicate how your identified demographic attrition rate compares to your total attrition rate.', 'Performance', 'numeric', 1.0, 15.0, 12);


-- Community Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 1, 'We measure and track our annual spending on community outreach and engagement activities. ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 2, 'We measure and track employee participation in community engagement and outreach activities.  ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 3, 'We have defined the impact we want to have on our local community and have developed methods to monitor and track progress toward those goals. Select all that apply. ', 'Systems', 'multiple_choice', 2.0, 1.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 4, 'We have a written plan, budget time, and have allocated financial resources to support our community impact goals.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 5, 'We monitor the impact of our community outreach and engagement actions and adjust our efforts accordingly.', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 6, 'Internal stakeholders have participated in developing our community impact goals and outreach/engagement initiatives.', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 7, 'External stakeholders have participated in developing our community impact goals and outreach/engagement initiatives.', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 8, 'We have a community impact policy that guides outreach and engagement decision making.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 9, 'Responsibility and accountability for community impact are integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 10, 'Community impact expectations, goals, and performance are reviewed with relevant employees (check one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 11, 'We have integrated community engagement into our strategic business management processes.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 12, 'We have identified vulnerable groups and collective/individual rights that are of particular concern to the communities in which we operate.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 13, 'We have assessed actual or potential impacts on local communities from our operations. ', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 14, 'Our community outreach & engagement initiatives reflect the identified actual or potential negative impacts on local communities from our operations. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 15, 'We are engaged with and actively recruit from local resource agencies that represent vulnerable groups when making hiring, contracting, purchasing, or other resource allocation decisions.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 16, 'We are engaged with and actively recruit from local academic institutions.   ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 17, 'We donate resources to improve the communities in which we operate. Select all that apply. ', 'Best Practice', 'multiple_choice', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 18, 'We participate in initiatives to advance sustainability in our local communities. Select all that apply. ', 'Best Practice', 'multiple_choice', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 19, 'We encourage civic engagement of our workforce. Select all that apply.', 'Best Practice', 'multiple_choice', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 20, 'We publicly share information on community outreach/engagement activities.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 21, 'We publicly disclose information on taxes paid, tax rate, and where taxes are paid.  ', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 22, 'What percentage of facilities included in your Green Masters Program assessment have implemented local community engagement programs?', 'Performance', 'percentage', 1.0, 10.395000000000001, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 23, 'What percentage of employees have participated in your community engagement and outreach efforts?', 'Performance', 'percentage', 1.0, 10.395000000000001, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Community', 24, 'Please indicate the percentage of annual revenue spent on community outreach/engagement efforts. Full points awarded at 1%.', 'Performance', 'percentage', 1.0, 10.395000000000001, 12);


-- Customer Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 1, 'We measure and track product/service quality.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 2, 'We measure and track customer satisfaction with our product(s)/service(s).   ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 3, 'We have established or updated a quality or customer satisfaction baseline. Select the issues for which a baseline has been established. ', 'Systems', 'boolean', 2.0, 1.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 4, 'Please indicate your current baseline year.', 'Systems', 'multiple_choice', 0.0, 0.0, 0);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 5, 'We have established or updated a specific, measurable, achievable, relevant, and time-bound quality or customer satisfaction goal. Select the issues for which a goal has been established.', 'Systems', 'boolean', 2.0, 1.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 6, 'We have a written plan, budget time, and have allocated financial resources to support our quality/customer satisfaction goal(s).', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 7, 'We have a customer welfare policy that guides decision making.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 8, 'Responsibility and accountability for customer welfare is integrated throughout the organization. Select all levels engaged in oversight.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 9, 'Quality/customer satisfaction expectations, goals, and performance are reviewed with relevant employees (select one).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 10, 'We have formal quality control mechanisms.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 11, 'We use an established third-party methodology to manage quality assurance for our products or services.', 'Best Practice', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 12, 'We have a process in place to identify, manage, and mitigate negative outcomes for customers and users, such as health and safety risks associated with use of our product(s)/service(s).', 'Systems', 'boolean', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 13, 'We routinely assess whether our product(s)/service(s) are creating positive outcomes for our customers.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 14, 'We have a process in place to assess emerging customer and market requirements.', 'Best Practice', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 15, 'We have resources in place to continually improve outcomes for customers, including reducing negative effects or increasing positive effects. ', 'Systems', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 16, 'We consider the full lifetime impact to customers when developing products, services, and solutions.', 'Best Practice', 'numeric', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 17, 'We actively monitor and manage the privacy and security of customer data.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 18, 'We have an established and readily accessible way for customers to provide product feedback, ask questions, or file complaints.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 19, 'We have engaged our value chain about opportunities to improve the quality or sustainabilityof our products/services or improve outcomes for our customers. ', 'Best Practice', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 20, 'We have engaged with a customer to understand their sustainability goals and have partnered with them to reduce their footprint or improve their sustainability performance.', 'Best Practice', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 21, 'We provide product/ service information in the form of easy-to-understand labeling. Select all that apply. ', 'Best Practice', 'multiple_choice', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 22, 'What percentage of customer complaints received during the prior calendar year were related to product/service quality?', 'Performance', 'percentage', 1.0, 8.0, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 23, 'How many safety-related customer notifications/product recalls did you issue during the prior calendar year? Select >5 if not monitored.', 'Performance', 'numeric', 1.0, 6.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 24, 'Did you have any data breeches during the prior calendar year that endangered customer data?', 'Performance', 'numeric', 2.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 25, 'What percentage of customers you have engaged regarding the quality of your products/services?', 'Performance', 'percentage', 1.0, 6.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 26, 'Of the customers you have engaged regarding quality, what percent of your annual business volume does this represent?', 'Performance', 'percentage', 1.0, 4.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 27, 'What percentage of customers you have engaged regarding the sustainability of your products/services?', 'Performance', 'percentage', 1.0, 6.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Customer', 28, 'Of the customers you have engaged regarding sustainability, what percent of your annual business volume does this represent?', 'Performance', 'percentage', 1.0, 4.0, 4);


-- Supply Chain Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 1, 'We have mapped our supply chain to understand the key upstream environmental and social impacts of our products.', 'Systems', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 2, 'We have identified potential supply chain-related risks and opportunities for our organization.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 3, 'We have engaged with external stakeholders pertaining to our supply chain sustainability program and understand their needs and expectations.', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 4, 'We have a documented vision and/or objectives for our company’s supply chain engagement efforts', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 5, 'We have developed criteria to prioritize our engagement efforts.  ', 'Systems', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 6, 'We have developed a strategy for engaging and communicating with prioritized suppliers. ', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 7, 'We have established or updated a specific, measurable, achievable, relevant, and time-bound supply chain sustainability goal.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 8, 'We have a written plan, budget time, and have allocated financial resources to support our supply chain sustainability goal.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 9, 'Participation in our supply chain management program is integrated throughout the organization. Select all functions engaged in development and implementation of the program.', 'Systems', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 10, 'We have a supplier code of conduct that includes sustainability criteria and guides our purchasing/ procurement decisions. Select all criteria that are included.', 'Systems', 'boolean', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 11, 'Suppliers are required to verify compliance with our supplier code of conduct.', 'Systems', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 12, 'We request information about the sustainability performance of our suppliers. Select the topics included in your request. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 13, 'We use verification methods to ensure suppliers are meeting our sustainability performance expectations. Select the method you use.', 'Best Practice', 'numeric', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 14, 'We require demonstration of improvement from suppliers whose performance does not meet our sustainability performance expectations. ', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 15, 'We measure and track relevant environmental and social impacts of our products throughout the supply chain. Select the topics included.', 'Systems', 'boolean', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 16, 'We are aligning with industry best practices in supply chain management.', 'Best Practice', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 17, 'We have an established process in place for suppliers to recommend design and/or process changes to reduce the environmental impact of a purchased good/service. ', 'Best Practice', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 18, 'We engage with key suppliers early in the new product development cycle, to incorporate sustainability considerations into the design of new products and identify opportunities to reduce environmental impacts throughout the value chain. ', 'Best Practice', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 19, 'We partner with suppliers to optimize delivery and reduce impacts related to transportation of the products we purchase.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 20, 'We provide education, best practices, technical assistance, and/or resources about sustainability to our supply chain.', 'Best Practice', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 21, 'We provide incentives for suppliers to act in a more sustainable way.  Select all that apply.', 'Best Practice', 'multiple_choice', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 22, 'We train our procurement team on social and environmental issues within our supply chain.', 'Best Practice', 'numeric', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 23, 'Sustainability criteria is used when selecting packaging material for our company. Select any criteria that are true of >75% of the packaging materials used. ', 'Best Practice', 'numeric', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 24, 'What percentage of your vendors are located within 100 miles of the facility using the goods or services? Full points are awarded at 50%.', 'Best Practice', 'percentage', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 25, 'What percentage of purchases are from companies that are majority-owned by women or individuals from underrepresented populations? Full points are awarded at 50%. Select “0” if not monitored.', 'Best Practice', 'percentage', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 26, 'What percentage of suppliers participate in a sustainability certification program?  Select “0” if not monitored.', 'Best Practice', 'percentage', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 27, 'What percentage of prioritized suppliers you have engaged regarding their sustainability performance?', 'Performance', 'percentage', 1.0, 8.55, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 28, 'What percentage of prioritized suppliers have you incentivized to improve their sustainability performance?', 'Performance', 'percentage', 1.0, 6.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 29, 'What percentage of all suppliers have you engaged regarding their sustainability performance?', 'Performance', 'percentage', 1.0, 8.55, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 30, 'What percentage of all suppliers have you incentivized to improve their sustainability performance?', 'Performance', 'percentage', 1.0, 6.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 31, 'Of the material sustainability topics identified for your organization, on what percent of those topics have you engaged your supply chain?', 'Performance', 'percentage', 1.0, 8.55, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('Supply Chain', 32, 'What percentage of your product components come from fully traceable supply chains?', 'Performance', 'percentage', 1.0, 6.0, 6);


-- G&L Questions
INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 1, 'Executive leadership has participated in exploring and selecting the sustainability issues that have been identified as material to our organization.', 'Systems', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 2, 'We engage relevant stakeholders in sustainability issues that are material for our organization. ', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 3, 'We measure and track environmental and social indicators that are material for our organization. ', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 4, 'We have formally recognized sustainability as an organizational priority.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 5, 'Our most senior executive leader has publicly endorsed sustainability as an organizational priority.', 'Systems', 'numeric', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 6, 'Sustainability has been integrated into the mission, vision, and/or values of our organization. Select all aspects that are included in your publicly available statement(s).', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 7, 'We have developed and are implementing policies that align with the principles of sustainability. Select all aspects that are included.', 'Systems', 'boolean', 1.0, 2.0, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 8, 'We have developed and are implementing strategies to address environmental and social risks with potential to impact our business', 'Systems', 'boolean', 3.0, 2.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 9, 'We have systems in place to identify and ensure compliance with all applicable regulatory requirements.', 'Systems', 'boolean', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 10, 'We have established sustainability goals that are specific, measurable, achievable, relevant, and near or mid-term.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 11, 'We have established sustainability goals that are material, strategic, ambitious, and long-term.', 'Systems', 'boolean', 1.0, 2.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 12, 'Our sustainability priorities are integrated into our employee performance evaluation processes.  ', 'Systems', 'numeric', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 13, 'Our sustainability priorities are integrated into our key business decision-making and business performance evaluation processes. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 14, 'Sustainability is a key driver for innovation and product development. ', 'Systems', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 15, 'Engagement in sustainability issues is integrated throughout the organization. Select all that apply. ', 'Systems', 'multiple_choice', NULL, NULL, 10);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 16, 'We implement best practices in ethical governance. Select all that are implemented.', 'Best Practice', 'numeric', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 17, 'We take actions regarding information security. Select all that are implemented.', 'Best Practice', 'boolean', NULL, NULL, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 18, 'We take measures to ensure equitable distribution of economic value generated by our organization. Select all that are implemented. ', 'Best Practice', 'boolean', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 19, 'We use best practices in stakeholder engagement. Select all that apply.', 'Best Practice', 'multiple_choice', NULL, NULL, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 20, 'We have partnered with stakeholders to improve performance in social or environmental issues. Select the actions that have been taken.', 'Best Practice', 'boolean', NULL, NULL, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 21, 'We publicly disclose quantitative indicators on our sustainability performance, in alignment with reporting best practices for our industry. ', 'Best Practice', 'numeric', 2.0, 3.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 22, 'We have formally and publicly committed to the United Nation’s Sustainable Development Goals (SDGs). ', 'Best Practice', 'boolean', 2.0, 1.0, 2);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 23, 'We have current third-party certification for organizational sustainability.', 'Best Practice', 'boolean', 3.0, 3.0, 9);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 24, 'Please indicate the number of regulatory violations incurred by your organization during the prior calendar year. Full points awarded at zero.', 'Performance', 'multiple_choice', 1.0, 6.0, 6);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 25, 'Please indicate the number of times each year the highest organizational decision makers in your organization are briefed on performance in all material sustainability topics. ', 'Performance', 'multiple_choice', 1.0, 8.0, 8);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 26, 'Please indicate what percentage of sustainability indicators that have been identified as material to your organization are included in your public performance disclosure(s).', 'Performance', 'percentage', 1.0, 15.299999999999999, 12);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 27, 'Please indicate what percentage of your board members are women. Full points are awarded at 50%.', 'Performance', 'percentage', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 28, 'Please indicate what percentage of your C-suite executives are women.  Full points are awarded at 50%.', 'Performance', 'percentage', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 29, 'Please indicate what percentage of your board members are part of a traditionally under-represented group. Full points are awarded at 50%.', 'Performance', 'percentage', 2.0, 2.0, 4);

INSERT INTO sustainability_questions (category, question_order, question_text, question_type, answer_type, effort_rating, impact_rating, max_points) VALUES
('G&L', 30, 'Please indicate what percentage of your C-suite executives are part of a traditionally under-represented group.  Full points are awarded at 50%.', 'Performance', 'percentage', 2.0, 2.0, 4);

