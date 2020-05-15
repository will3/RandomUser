//
//  FilterViewController.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxFeedback
import RxSwift
import RxViewController
import UIKit

enum FilterRow {
    case gender(Gender)
    case country(CountryCode?)
}

extension FilterViewController {
    static func prompt(from: UIViewController, filter: Filter) -> Observable<FilterViewController?> {
        return Observable.create { observer in
            let vc = FilterViewController(nibName: "FilterView", bundle: nil)
            vc.filter.accept(filter)
            from.present(vc, animated: true, completion: nil)

            let dispose = vc.rx.viewWillDisappear.bind { [weak vc] _ in
                observer.on(.next(vc))
                observer.onCompleted()
            }

            return dispose
        }
    }
}

extension Gender {
    func next() -> Gender {
        switch self {
        case .male:
            return .female
        case .female:
            return .both
        case .both:
            return .male
        }
    }
}

class FilterViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!

    var onFilterChanged: ((Filter?) -> Void)?

    let disposeBag = DisposeBag()

    lazy var filter: BehaviorRelay<Filter?> = BehaviorRelay(value: nil)

    var filterChanged = false

    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FilterRow>>(
        configureCell: { (_, tableView, _, row: FilterRow) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell")! as! FilterCell

            switch row {
            case let .gender(gender):
                cell.titleLabel.text = "Show me"
                cell.detailLabel.text = gender.format()
            case let .country(code):
                cell.titleLabel.text = "Country"
                cell.detailLabel.text = code?.formatName() ?? "All"
            }

            return cell
        })

    override func viewDidLoad() {
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.modelSelected(FilterRow.self).subscribe(onNext: { [weak self] row in
            guard let self = self else { return }
            switch row {
            case .gender:
                let filter = self.filter.value?.mutate { filter in
                    filter.gender = filter.gender.next()
                }
                self.filter.accept(filter)
            case .country(_):
                let filter = self.filter.value?.mutate { filter in
                    filter.countryCode = filter.countryCode?.next() ?? .AU
                }
                self.filter.accept(filter)
            }
        }).disposed(by: disposeBag)

        doneButton.rx.tap
            .bind { [weak self] in
                self?.filterChanged = true
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

        filter.map { filter -> [FilterRow] in
            guard let filter = filter else {
                return [FilterRow]()
            }
            return [
                FilterRow.gender(filter.gender),
                FilterRow.country(filter.countryCode)
            ]
        }
        .map { [SectionModel(model: "Results", items: $0)] }
        .asDriver(onErrorJustReturn: [])
        .drive(tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
