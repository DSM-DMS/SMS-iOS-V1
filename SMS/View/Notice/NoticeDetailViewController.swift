//
//  NoticeDetailViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/23.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import EditorJSKit

class NoticeDetailViewController: UIViewController, Storyboarded {
    var uuid: String!
    var pNoticeUUID = ""
    var nNoticeUUID = ""
    var blockList: EJBlocksList!
    let disposeBag = DisposeBag()
    let viewModel = NoticeDetailViewModel(networking: SMSAPIClient.shared)
    weak var coordinator: NoticeCoordinator?
    
    private lazy var renderer = EJCollectionRenderer(collectionView: rendererCollectionView)
    
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var nTitle: UILabel!
    @IBOutlet weak var nDate: UILabel!
    @IBOutlet weak var pNoticeButton: UIButton!
    @IBOutlet weak var nNoticeButton: UIButton!
    @IBOutlet weak var rendererCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performNetworkTask()
        bind()
        setting()
    }
}



extension NoticeDetailViewController {
    func bind() {
        Observable.of(uuid)
            .bind { self.viewModel.input.noticeUUIDSubject.onNext($0)}
            .disposed(by: disposeBag)
        
        bButton.rx.tap
            .bind{
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        pNoticeButton.rx.tap
            .throttle(RxTimeInterval.nanoseconds(2), scheduler: MainScheduler.instance)
            .filter { !self.nNoticeUUID.isEmpty }
            .bind {
                self.viewModel.input.noticeUUIDSubject.onNext(self.nNoticeUUID)
            }.disposed(by: disposeBag)
        
        nNoticeButton.rx.tap
            .throttle(RxTimeInterval.nanoseconds(2), scheduler: MainScheduler.instance)
            .filter { !self.pNoticeUUID.isEmpty }
            .bind {
                self.viewModel.input.noticeUUIDSubject.onNext(self.pNoticeUUID)
            }.disposed(by: disposeBag)
        
        viewModel.output.announcements.bind { notice in
            if notice.status == 200 {
                self.nTitle.text = notice.title
                self.nDate.text = globalDateFormatter(.dotDay, unix(with: notice.date! / 1000))
                self.pNoticeButton.setTitle(notice.next_title, for: .normal)
                self.nNoticeButton.setTitle(notice.previous_title, for: .normal)
                guard let data = try! notice.content!.data(using: .utf8) else { return }
                self.blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)
                self.rendererCollectionView.reloadData()
                self.pNoticeUUID = notice.previous_announcement_uuid!
                self.nNoticeUUID = notice.next_announcement_uuid!
            } else if notice.status == 408 {
                self.view.makeToast("Time Error", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
                sleep(1)
                self.coordinator?.pop()
            }
        }.disposed(by: disposeBag)
    }
    
    func setting() {
        rendererCollectionView.delegate = self
        rendererCollectionView.dataSource = self
        let cellSize = CGSize(width: rendererCollectionView.frame.width, height: 60)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        rendererCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func performNetworkTask() {
        guard let path = Bundle.main.path(forResource: "EditorJSMock", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return }
        blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)
        
        rendererCollectionView.reloadData()
    }
}



extension NoticeDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return blockList.blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockList.blocks[section].data.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        do {
            return try renderer.render(block: blockList.blocks[indexPath.section], indexPath: indexPath)
        }
        catch {
            return UICollectionViewCell()
        }
    }
}

extension NoticeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        do {
            return try renderer.size(forBlock: blockList.blocks[indexPath.section], itemIndex: indexPath.item, style: nil, superviewSize: CGSize(width: UIScreen.main.bounds.width - 40, height: collectionView.frame.height) )
        } catch {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return renderer.spacing(forBlock: blockList.blocks[section])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return renderer.insets(forBlock: blockList.blocks[section])
    }
}
