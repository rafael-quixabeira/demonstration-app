//
//  CharacterTableView.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import SwiftUI
import UIKit
import Kingfisher

public struct CharacterTableView: UIViewRepresentable {
    public typealias UIViewType = UITableView

    let characters: [Character]
    let onPrefetch: (Int) -> Void
    let onTap: (Character) -> Void
    let pageSize: Int
    let threshold: Int

    public init(
        characters: [Character],
        onPrefetch: @escaping (Int) -> Void,
        onTap: @escaping (Character) -> Void,
        pageSize: Int = 20,
        threshold: Int = 1
    ) {
        self.characters = characters
        self.onPrefetch = onPrefetch
        self.pageSize = pageSize
        self.threshold = threshold
        self.onTap = onTap
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeUIView(context: Context) -> UITableView {
        let view = UITableView()
        view.register(CharacterCellView.self)

        view.dataSource = context.coordinator
        view.delegate = context.coordinator
        view.prefetchDataSource = context.coordinator

        return view
    }

    public func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.update(characters: characters)
        uiView.reloadData()
    }
    
    public class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
        private let parent: CharacterTableView
        private var characters: [Character] = []

        init(parent: CharacterTableView) {
            self.parent = parent
        }
        
        func update(characters: [Character]) {
            self.characters = characters
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            parent.onTap(characters[indexPath.row])
        }

        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return characters.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(CharacterCellView.self, for: indexPath)
            cell.configure(with: characters[indexPath.row])

            return cell
        }
        
        public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            let threshold = characters.count - parent.threshold
            let shouldPrefetch = indexPaths.contains { $0.row >= threshold }

            guard shouldPrefetch else { return }

            let nextPage = (characters.count / parent.pageSize) + 1
            parent.onPrefetch(nextPage)
        }
    }

    private class CharacterCellView: UITableViewCell {
        private let characterImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 30

            return imageView
        }()
        
        private let nameLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .medium)

            return label
        }()
        
        private let statusLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.textColor = .gray

            return label
        }()
        
        private lazy var labelsStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
            stack.axis = .vertical
            stack.spacing = 4

            return stack
        }()
        
        private lazy var mainStackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [characterImageView, labelsStackView])
            stack.axis = .horizontal
            stack.spacing = 12
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false

            return stack
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupUI() {
            contentView.addSubview(mainStackView)

            NSLayoutConstraint.activate([
                characterImageView.widthAnchor.constraint(equalToConstant: 60),
                characterImageView.heightAnchor.constraint(equalToConstant: 60)
            ])

            NSLayoutConstraint.activate([
                labelsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
            ])

            NSLayoutConstraint.activate([
                mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }

        func configure(with character: Character) {
            nameLabel.text = character.name
            statusLabel.text = "\(NSLocalizedString(character.species, comment: "")) - \(NSLocalizedString(character.status.rawValue, comment: "status-label"))"
            characterImageView.kf.setImage(with: character.image)
        }
    }
}
