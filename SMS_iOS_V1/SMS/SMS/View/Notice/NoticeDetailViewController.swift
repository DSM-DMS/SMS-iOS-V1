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
    let disposeBag = DisposeBag()
    let viewModel = NoticeDetailViewModel()
    weak var coordinator: NoticeCoordinator?


    //비
    //워
    //주
    //세
    //요
    //엑
    //코
    //문
    //제
    //로
    //버
    //그
    //가
    //나
    //는
    //라
    //인
    //입
    //니
    //다.



    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var nTitle: UILabel!
    @IBOutlet weak var nDate: UILabel!
    @IBOutlet weak var pNoticeButton: UIButton!
    @IBOutlet weak var nNoticeButton: UIButton!
    @IBOutlet weak var rendererCollectionView: UICollectionView!

    var pNoticeUUID = ""
    var nNoticeUUID = ""

    var blockList: EJBlocksList!

    private lazy var renderer = EJCollectionRenderer(collectionView: rendererCollectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bind()
        performNetworkTask()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindAction()
        
    }
}


extension NoticeDetailViewController {
    private func performNetworkTask() {
        guard let path = Bundle.main.path(forResource: "EditorJSMock", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return }
        blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)

        rendererCollectionView.reloadData()
    }
    
    func bind() {
        
        rendererCollectionView.delegate = self
        rendererCollectionView.dataSource = self


        viewModel.NoticeDetailData.bind { [self] data in
            if data.status == 200 {
                
                self.nTitle.text = data.title
                self.nDate.text = globalDateFormatter(.dotDay, unix(with: data.date / 1000))
                self.pNoticeButton.setTitle(data.next_title, for: .normal)
                self.nNoticeButton.setTitle(data.previous_title, for: .normal)
                guard let data = try? data.content.data(using: .utf8) else { return }
                
                self.blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)
                rendererCollectionView.reloadData()
               
            }
            self.pNoticeUUID = data.previous_announcement_uuid
            self.nNoticeUUID = data.next_announcement_uuid
        }.disposed(by: disposeBag)
    }

    func bindAction() {
        bButton.rx.tap
            .bind{
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)

        pNoticeButton.rx.tap
            .bind {
                UserDefaults.standard.setValue(self.nNoticeUUID, forKey: "announcement_uuid")
                self.presenting()
            }.disposed(by: disposeBag)

        nNoticeButton.rx.tap
            .bind {
                UserDefaults.standard.setValue(self.pNoticeUUID, forKey: "announcement_uuid")
                self.presenting()
            }.disposed(by: disposeBag)
    }
}


extension NoticeDetailViewController: UICollectionViewDataSource {
    
    func presenting() {
        let storyboard = UIStoryboard(name: "Notice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NoticeDetailViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
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
            return try renderer.size(forBlock: blockList.blocks[indexPath.section], itemIndex: indexPath.item, style: nil, superviewSize: collectionView.frame.size)
        } catch {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
        return renderer.spacing(forBlock: blockList.blocks[section])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return renderer.insets(forBlock: blockList.blocks[section])
    }
}
