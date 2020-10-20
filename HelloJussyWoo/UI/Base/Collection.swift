//
//  Collection.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 07/10/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//
import SwiftUI
import UIKit

struct CollectionComponent : UIViewRepresentable {
    func makeCoordinator() -> CollectionComponent.Coordinator {
        Coordinator(data: [])
    }

    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        var data: [String] = []

        init(data: [String]) {

            for index in (0...1000) {
                self.data.append("\(index)")
            }
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            data.count
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GenericCell

            cell.customView?.rootView = Text(data[indexPath.item])

            return cell
        }
    }


    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cvs = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cvs.dataSource = context.coordinator
        cvs.delegate = context.coordinator
        cvs.register(GenericCell.self, forCellWithReuseIdentifier: "cell")

        cvs.backgroundColor = .white
        return cvs
    }
    func updateUIView(_ uiView: UICollectionView, context: Context) {

    }
}


public class GenericCell: UICollectionViewCell {

    public var textView = Text("")
    public var customView: UIHostingController<Text>?
    public override init(frame: CGRect) {
        super.init(frame: .zero)


        customView = UIHostingController(rootView: textView)
        customView!.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customView!.view)

        customView!.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customView!.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        customView!.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        customView!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
