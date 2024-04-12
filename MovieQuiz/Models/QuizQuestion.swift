//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Alexey Shimanskii on 11.04.2024.
//

import UIKit

 struct QuizQuestion {
    // строка с названием фильма.
    // совпадает с название картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
