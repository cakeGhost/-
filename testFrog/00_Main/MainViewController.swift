//
//  MainViewController.swift
//  testFrog
//
//  Created by betty on 2022/01/13.
//

import UIKit

class MainViewController: UIViewController {

    //let vc = GameViewController()
    

    @IBAction func onClickStart(_ sender: Any) {
      //  self.performSegue(withIdentifier: "gameSegue", sender: self)
      //  vc.modalPresentationStyle = .fullScreen
      //  self.present(vc, animated: true, completion: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
          
        vc.modalPresentationStyle = .fullScreen
            
        self.present(vc, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
