//
//  ViewController.swift
//  QuePersonajeEres
//
//  Proyecto: Reto 5 - Desarrollando con Swift
//  Descripción: Quiz de 5 preguntas que determina qué "personaje" es el usuario
//               según sus respuestas, usando colecciones, operadores y
//               estructuras de control/iterativas.
//

import UIKit

// MARK: - Modelos (usando struct, parte de las colecciones/tipos de Swift)

struct QuizOption {
    let text: String
    let character: String
}

struct QuizQuestion {
    let text: String
    let options: [QuizOption]   // Colección: Array
}

class ViewController: UIViewController {

    // MARK: - Datos del quiz (Colección: Array de structs)

    private let questions: [QuizQuestion] = [
        QuizQuestion(text: "Estás en una situación desconocida, ¿qué haces primero?", options: [
            QuizOption(text: "Investigar y explorar el lugar", character: "Explorador"),
            QuizOption(text: "Proteger a quienes te rodean", character: "Guardián"),
            QuizOption(text: "Analizar la situación y planear", character: "Estratega"),
            QuizOption(text: "Buscar una forma original de resolverlo", character: "Creativo")
        ]),
        QuizQuestion(text: "¿Qué objeto llevarías siempre contigo?", options: [
            QuizOption(text: "Un mapa", character: "Explorador"),
            QuizOption(text: "Un escudo", character: "Guardián"),
            QuizOption(text: "Un libro de estrategia", character: "Estratega"),
            QuizOption(text: "Un cuaderno de dibujo", character: "Creativo")
        ]),
        QuizQuestion(text: "En un equipo, tu rol favorito es:", options: [
            QuizOption(text: "El que descubre nuevos caminos", character: "Explorador"),
            QuizOption(text: "El que cuida al equipo", character: "Guardián"),
            QuizOption(text: "El que organiza el plan", character: "Estratega"),
            QuizOption(text: "El que aporta ideas nuevas", character: "Creativo")
        ]),
        QuizQuestion(text: "¿Qué te motiva más?", options: [
            QuizOption(text: "Descubrir lugares nuevos", character: "Explorador"),
            QuizOption(text: "Ayudar y proteger a otros", character: "Guardián"),
            QuizOption(text: "Resolver problemas complejos", character: "Estratega"),
            QuizOption(text: "Crear algo único", character: "Creativo")
        ]),
        QuizQuestion(text: "Elige una palabra que te describa:", options: [
            QuizOption(text: "Aventurero", character: "Explorador"),
            QuizOption(text: "Leal", character: "Guardián"),
            QuizOption(text: "Analítico", character: "Estratega"),
            QuizOption(text: "Imaginativo", character: "Creativo")
        ])
    ]

    // Colección: Dictionary con la descripción final de cada personaje
    private let resultDescriptions: [String: String] = [
        "Explorador": "Eres el Explorador: curioso, valiente y siempre buscando nuevos horizontes.",
        "Guardián": "Eres el Guardián: leal, protector y siempre cuidando de los demás.",
        "Estratega": "Eres el Estratega: analítico, organizado y experto en resolver problemas.",
        "Creativo": "Eres el Creativo: imaginativo, original y lleno de ideas únicas."
    ]

    // Colección: Dictionary para acumular el puntaje de cada personaje
    private var scores: [String: Int] = [:]
    private var currentIndex = 0   // Estructura de control: controla el avance del quiz

    // MARK: - UI

    private let titleLabel = UILabel()
    private let progressLabel = UILabel()
    private let questionLabel = UILabel()
    private let optionsStack = UIStackView()
    private let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Estructura iterativa (for-in anidado): inicializa el marcador en 0
        // para cada personaje que aparezca en las preguntas.
        for question in questions {
            for option in question.options {
                if scores[option.character] == nil {
                    scores[option.character] = 0
                }
            }
        }

        setupUI()
        loadQuestion(at: 0)
    }

    private func setupUI() {
        titleLabel.text = "¿Qué personaje eres?"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        progressLabel.font = .systemFont(ofSize: 14)
        progressLabel.textColor = .secondaryLabel
        progressLabel.textAlignment = .center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressLabel)

        questionLabel.font = .systemFont(ofSize: 18)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)

        optionsStack.axis = .vertical
        optionsStack.spacing = 12
        optionsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsStack)

        resultLabel.font = .systemFont(ofSize: 20, weight: .medium)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.isHidden = true
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            questionLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            optionsStack.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24),
            optionsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            optionsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    /// Dibuja la pregunta y sus opciones en pantalla según el índice recibido.
    private func loadQuestion(at index: Int) {
        let question = questions[index]
        progressLabel.text = "Pregunta \(index + 1) de \(questions.count)"
        questionLabel.text = question.text

        // Estructura iterativa: limpia los botones de la pregunta anterior
        optionsStack.arrangedSubviews.forEach { view in
            optionsStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        // Estructura iterativa (for-in con enumerated): crea un botón por opción
        for (i, option) in question.options.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option.text, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.contentHorizontalAlignment = .center
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray3.cgColor
            button.layer.cornerRadius = 8
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.tag = i
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            optionsStack.addArrangedSubview(button)
        }
    }

    /// Se ejecuta al tocar una opción: registra el punto y avanza a la
    /// siguiente pregunta, o muestra el resultado si era la última.
    @objc private func optionTapped(_ sender: UIButton) {
        let question = questions[currentIndex]
        let selectedOption = question.options[sender.tag]

        // Operador de asignación compuesta (+=) sobre un Dictionary
        scores[selectedOption.character, default: 0] += 1

        currentIndex += 1   // Operador de incremento

        // Estructura de control (if / else): decide si sigue el quiz o termina
        if currentIndex < questions.count {
            loadQuestion(at: currentIndex)
        } else {
            showResult()
        }
    }

    /// Determina el personaje con más puntos y lo muestra en pantalla.
    private func showResult() {
        titleLabel.isHidden = true
        progressLabel.isHidden = true
        questionLabel.isHidden = true
        optionsStack.isHidden = true

        var winningCharacter = "Explorador"
        var highestScore = -1

        // Estructura iterativa: recorre el diccionario de puntajes
        // Operador relacional (>): compara para encontrar el máximo
        for (character, score) in scores {
            if score > highestScore {
                highestScore = score
                winningCharacter = character
            }
        }

        let description = resultDescriptions[winningCharacter] ?? ""
        resultLabel.text = description
        resultLabel.isHidden = false
    }
}
