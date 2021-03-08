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
    @IBOutlet weak var nContent: UITextView!
    @IBOutlet weak var pNoticeButton: UIButton!
    @IBOutlet weak var nNoticeButton: UIButton!
    
    
//    var blockList: EJBlocksList!
//
//    let renderer: EJCollectionRenderer! = nil
//
    //previous noticebtn
    //nextnoticebtn
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        bindAction()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}

extension NoticeDetailViewController {
    func bind() {
        nContent.isEditable = false
        viewModel.NoticeDetailData.bind { data in
            if data.status == 200 {
                
                self.nTitle.text = data.title
                self.nDate.text = globalDateFormatter(.dotDay, unix(with: data.date))
                let contentArr = Array(data.content)
                let contentlength = contentArr.count
                var resultContent = ""
                for i in 75..<(contentlength - 26) {
                    resultContent.append(contentArr[i])
                }
                
                self.nContent.text = resultContent
//                try? self.blockList = EJBlocksList(from: data.content as! Decoder)
                
                if(data.previous_title.count >= 18) {
                    let titleArr = Array(data.previous_title)
                    var noticeTitle = ""
                    for i in 0..<16 {
                        noticeTitle.append(titleArr[i])
                    }
                    noticeTitle.append("...")
                    self.nNoticeButton.setTitle(noticeTitle, for: .normal)
                } else {
                    self.nNoticeButton.setTitle(data.previous_title, for: .normal)
                }
                if(data.next_title.count >= 18) {
                    let titleArr = Array(data.next_title)
                    var noticeTitle = ""
                    for i in 0..<16 {
                        noticeTitle.append(titleArr[i])
                    }
                    noticeTitle.append("...")
                    self.pNoticeButton.setTitle(noticeTitle, for: .normal)
                } else {
                    self.pNoticeButton.setTitle(data.next_title, for: .normal)
                }
            }
        }.disposed(by: disposeBag)
        
        
        
    }
    
    func bindAction() {
        bButton.rx.tap
            .bind{
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
    
}

//extension NoticeDetailViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        blockList.blocks[section].data.numberOfItems
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        do {
//            return try renderer.size(forBlock: blockList.blocks[indexPath.section], itemIndex: indexPath, style: EJBlockStyle?, superviewSize: CGSize())
//        }
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return blockList.blocks.count
//    }
//}
